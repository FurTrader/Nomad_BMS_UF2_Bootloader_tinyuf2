Customized for the Nomad BMS by Overkill Solar, which runs on a ESP32-S3

TODO: figure out how to make a new favicon.

### Setup before building
I had to do a bunch of stuff to build this. Starting from where I can build the Nomad firmware:     
Working from the powershell terminal inside VSCODE/PlatformIO:    
install chocolatey     
Install MAKE: `choco install make`       
`cd C:\Users\user\esp\esp-idf\tools`     
setup python environment. `python idf_tools.py install-python-env`     
if this fails with "virtual environment already exixts" or something, rename python.exe in C:\Users\user\.platformio\penv\Scripts and retry (revert this change later)      
Change the execution policy so the following will run: `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine`    
check execution policy: `Get-ExecutionPolicy -List`     
(might want to change it back with `Set-ExecutionPolicy -ExecutionPolicy Allsigned -Scope LocalMachine`)       
run the install scripts for ESP-IDF:
  `.$HOME/esp/esp-idf/install`       
  `.$HOME/esp/esp-idf/export.ps1`      
`git submodule update --init --recursive`       
`cd D:\Public\Nomad_BMS_UF2_Bootloader_tinyuf2\tools`    
`python get_deps.py esp32s3`      
`cd D:\Public\Nomad_BMS_UF2_Bootloader_tinyuf2\ports\espressif`      
`make BOARD=Nomad_BMS_ESP32-S3-WROOM-1-N8_no_psram all`

I'm sure I forgot something...     

fucking python nightmare-     
To build the bootloader, I have to remove python.exe from C:\Users\user\.platformio\penv\Scripts     
to build the firmware, I have to restore that version of python.     
try `where.exe python` to see whats going on         

### Might have to do this EVERY TIME you go back and build the bootloader again:     
`cd D:\Public\Nomad_BMS_UF2_Bootloader_tinyuf2\ports\espressif`      
`Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine`      
`.$HOME/esp/esp-idf/export.ps1`      
`make BOARD=Nomad_BMS_ESP32-S3-WROOM-1-N8_no_psram all`      


# TinyUF2 Bootloader

[![Build Status](https://github.com/adafruit/tinyuf2/workflows/Build/badge.svg)](https://github.com/adafruit/tinyuf2/actions)[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

This repo is cross-platform UF2 Bootloader projects for MCUs based on [TinyUSB](https://github.com/hathach/tinyusb)

```
.
├── apps              # Useful applications such as self-update, erase firmware
├── lib               # Sources from 3rd party such as tinyusb, mcu drivers ...
├── ports             # Port/family specific sources
│   ├── espressif
│   │   └── boards/   # Board specific sources
│   │   └── Makefile  # Makefile for this port
│   └── mimxrt10xx
├── src               # Cross-platform bootloader sources files
```

## Features

Supported features are

- Double tap to enter DFU, reboot to DFU and quick reboot from application
- DFU with MassStorage (MSC)
- Self update with uf2 file
- Indicator: LED, RGB, TFT
- Debug log with uart/swd

Not all features are implemented for all MCUs, following is supported MCUs and its feature

| MCU         | MSC  | Double Reset | Self-update | Write Protection | Neopixel | TFT  |
| :---------- | :--: | :----------: | :---------: | :--------------: | :------: | :--: |
| ESP32 S2/S3 |  ✔   |   Need RC    |      ✔      |                  |    ✔     |  ✔   |
| K32L2       |  ✔   |      ✔       |             |                  |          |      |
| LPC55       |  ✔   |      ✔       |             |                  |    ✔     |      |
| iMXRT       |  ✔   |      ✔       |      ✔      |                  |    ✔     |      |
| STM32F3     |  ✔   |      ✔       |      ✔      |        ✔         |    ✔     |      |
| STM32F4     |  ✔   |      ✔       |      ✔      |        ✔         |    ✔     |      |

## Build and Flash

Following is generic compiling information. Each port may require extra set-up and slight different process e.g esp32s2 require setup IDF.

### Clone

Clone this repo with its submodule

```
$ git clone git@github.com:adafruit/tinyuf2.git tinyuf2
$ cd tinyuf2
$ git submodule update --init
```

### Compile

To build this for a specific board, we need to change current directory to its port folder

```
$ cd ports/stm32f4
```

Firstly we need to get all submodule dependency for our board using `tools/get_deps.py` script with either family input or using --board option. You only need to do this once for each family

```
python tools/get_deps.py stm32f4
python tools/get_deps.py --board feather_stm32f405_express
```

Then compile with `all` target:

```
make BOARD=Nomad_BMS_ESP32-S3-WROOM-1-N8_no_psram all
```

### Flash

`flash` target will use the default on-board debugger (jlink/cmsisdap/stlink/dfu) to flash the binary, please install those support software in advance. Some board use bootloader/DFU via serial which is required to pass to make command

```
$ make BOARD=feather_stm32f405_express flash
```

If you use an external debugger, there is `flash-jlink`, `flash-stlink`, `flash-pyocd` which are mostly like to work out of the box for most of the supported board.

### Debug

To compile for debugging add `DEBUG=1`, this will mostly change the compiler optimization

```
$ make BOARD=feather_stm32f405_express DEBUG=1 all
```

#### Log

Should you have an issue running example and/or submitting an bug report. You could enable TinyUSB built-in debug logging with optional `LOG=`.
- **LOG=1** will print message from bootloader and error if any from TinyUSB stack.
- **LOG=2** and **LOG=3** will print more information with TinyUSB stack events

```
$ make BOARD=feather_stm32f405_express LOG=1 all
```

#### Logger

By default log message is printed via on-board UART which is slow and take lots of CPU time comparing to USB speed. If your board support on-board/external debugger, it would be more efficient to use it for logging. There are 2 protocols:

- `LOGGER=rtt`: use [Segger RTT protocol](https://www.segger.com/products/debug-probes/j-link/technology/about-real-time-transfer/)
  - Cons: requires jlink as the debugger.
  - Pros: work with most if not all MCUs
  - Software viewer is JLink RTT Viewer/Client/Logger which is bundled with JLink driver package.
- `LOGGER=swo`: Use dedicated SWO pin of ARM Cortex SWD debug header.
  - Cons: only work with ARM Cortex MCUs minus M0
  - Pros: should be compatible with more debugger that support SWO.
  - Software viewer should be provided along with your debugger driver.

```
$ make BOARD=feather_stm32f405_express LOG=2 LOGGER=rtt all
$ make BOARD=feather_stm32f405_express LOG=2 LOGGER=swo all
```
