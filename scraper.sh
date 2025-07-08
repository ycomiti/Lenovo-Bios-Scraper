#!/bin/bash
set -euo pipefail

biosFile="egcn41ww.exe"
biosUrl="https://download.lenovo.com/consumer/mobiles/${biosFile}"
currentDir=$(pwd)
timestamp=$(date +%s)
workDir="LenovoBiosExtract-${timestamp}"

requiredCommands=(curl innoextract 7z realpath jq)
for cmd in "${requiredCommands[@]}"; do
  command -v "${cmd}" >/dev/null || { echo "❌ '${cmd}' not installed. Please run: sudo apt install ${cmd}"; exit 1; }
done

mkdir -p "${workDir}"
cd "${workDir}"

download() {
  curl -LO# --retry 3 --retry-delay 5 --retry-max-time 30 "${1}"
}

echo "📥 Attempting to download BIOS from Lenovo..."
if download "${biosUrl}"; then
  echo "✅ Download succeeded."
  echo "📤 Archiving BIOS on Wayback Machine..."
  location=$(curl -sI "https://web.archive.org/save/${biosUrl}" | awk 'tolower($1) == "location:" {print $2}' | tr -d '\r' || true)
  echo "${location}"
  [[ -n "${location}" ]] && echo "✅ Archived at: ${location}" || echo "⚠️  Archiving may have failed."
else
  echo "⚠️  Lenovo download failed, fetching latest archive..."
  timestamp=$(curl -s "https://web.archive.org/cdx/search/cdx?url=${biosUrl}&output=json&fl=timestamp&filter=statuscode:200&limit=1&sort=descending" | jq -r '.[1][0]' || true)
  [[ -z "${timestamp}" ]] && { echo "❌ No archive found."; exit 2; }
  archiveUrl="https://web.archive.org/web/${timestamp}/${biosUrl}"
  download "${archiveUrl}" || { echo "❌ Failed to download archive."; exit 3; }
fi

echo "📦 Extracting outer installer..."
innoextract --quiet "${biosFile}"

innerDir=$(find . -type d -name "code\$GetExtractPath" -print -quit)
[[ -z "${innerDir}" ]] && { echo "❌ Inner directory not found."; exit 4; }
cd "${innerDir}"

biosInstaller=$(find . -maxdepth 1 -name "EGCN*.exe" -print -quit)
[[ -z "${biosInstaller}" ]] && { echo "❌ BIOS installer not found."; exit 5; }

echo "🗜️ Extracting BIOS payload..."
7z x -y "${biosInstaller}" >/dev/null

if [[ -f "BIOS.fd" ]]; then
  cp -v "$(realpath BIOS.fd)" "${currentDir}/BIOS.EFI"
  echo "✅ BIOS.fd extracted."
else
  echo "❌ BIOS.fd not found after extraction."
  exit 6
fi
