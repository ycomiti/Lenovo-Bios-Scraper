# Lenovo Bios Scraper

A bash script to download and extract Lenovo BIOS files on Linux without requiring Windows.

## Disclaimer

⚠️ Use this script at your own risk.

Flashing a BIOS is a sensitive operation that, if interrupted or done improperly, can render your system unbootable (“bricked”).<br>
This script is provided **as is**, without any warranty.<br>
The author is **not responsible** for any damage, data loss, or hardware failure resulting from the use of this tool.

Always make sure to double-check the BIOS file you are using, ensure your machine is connected to a reliable power source, and understand the risks before proceeding.

## Features

- Downloads the latest BIOS updater executable directly from Lenovo.
- Automatically archives the BIOS on the Wayback Machine for community preservation.
- Falls back to downloading the latest archived BIOS if the Lenovo download fails.
* Extracts the BIOS payload `BIOS.fd` from the installer and copies it to the current directory as `BIOS.EFI`.
- Requires minimal dependencies and works entirely on Linux.

## Requirements

- `bash`
- `curl`
- `innoextract`
- `7z` (from p7zip)
- `jq`

Install dependencies on Debian/Ubuntu:

```bash
sudo apt update
sudo apt install curl innoextract p7zip-full jq
````

## Usage

1. **Set the `biosFile` variable in the script** (`scraper.sh`) to match the `.exe` filename of your Lenovo BIOS updater before running the script. *(This step may be automated in the future.)*
   ![Sans titre](https://github.com/user-attachments/assets/20cb7196-8232-4963-9d96-5aa6760d66cd)
3. Run the script:

```bash
./scraper.sh
```

The extracted BIOS firmware will be saved as `BIOS.EFI` in your current directory.

## Notes

* The script archives the BIOS updater on the Wayback Machine automatically.
* If the official Lenovo download is unavailable, it attempts to download the latest archived version.
* Make sure you have sufficient disk space and permissions to run the script.
* This script applies the method described in [this tutorial](https://forums.lenovo.com/t5/Gaming-Laptops/GUIDE-How-to-extract-BIOS-from-Lenovo-BIOS-Update-Package-such-as-ATCN37WW-exe/m-p/5008973) ([archive](https://web.archive.org/web/20250708000635/https://forums.lenovo.com/t5/Gaming-Laptops/GUIDE-How-to-extract-BIOS-from-Lenovo-BIOS-Update-Package-such-as-ATCN37WW-exe/m-p/5008973)), adapted for Linux.

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).<br>
See the [LICENSE](LICENSE) file for details.

---

Contributions and suggestions are welcome!
[GitHub Repository](https://github.com/ycomiti/Lenovo-Bios-Scraper)
