# LibTiff6 for Delphi

A modernized Delphi wrapper for **LibTiff 4.7.1**, specifically refactored for **x64 compatibility**, **BigTIFF** support, and **Unicode-safe** string handling.

## Overview
This project is an updated version of the classic LibTiff Delphi headers. It has been overhauled to work seamlessly with modern Delphi versions (tested on XE7) and provides a stable interface for both 32-bit and 64-bit Windows applications.

## Key Improvements
* **Full 64-bit Support**: All internal types (`THandle`, `NativeInt`, `UInt64`) have been corrected to match the x64 ABI.
* **BigTIFF Ready**: Replaced legacy 32-bit file pointers with `SetFilePointerEx`, enabling support for TIFF files larger than 4GB.
* **Safety Checks**: Added explicit checks for Windows API limits (e.g., 32-bit DWORD limits in `ReadFile`/`WriteFile`) to prevent data corruption.
* **Unicode Compatibility**: Correct mapping of `PAnsiChar` for library calls, ensuring stability in Unicode Delphi environments.
* **Clean Implementation**: Removed obsolete `.obj` linking and legacy 16/32-bit hacks.

## Precompiled Binaries
The repository includes `libtiff.dll` (v4.7.1) for both x86 and x64 architectures. These were compiled using the **MinGW-w64** environment and are **standalone** (no external dependencies).

Built-in support for the following codecs:
* **libdeflate**: High-performance DEFLATE compression.
* **liblzma**: LZMA (7z) compression.
* **zlib**: Standard ZIP/Deflate compression.
* **jpeg-10**: JPEG-in-TIFF support.

## Requirements
* **Delphi**
* **libtiff.dll** (Included in the `/Bin` folder).

## Usage
Simply include the unit in your project:
```pascal
uses
  LibTiff6;
```
  
## License
This project is licensed under the **Mozilla Public License (MPL) 2.0**.

## Credits
Based on the original work by:
* **Vampyre Imaging Library** - (https://github.com/galfar/imaginglib)
* **Do-wan Kim** (Aware Systems - LibTiffDelphi)

Updated and maintained by **bigmike** & **Gemini (Google AI)**.
