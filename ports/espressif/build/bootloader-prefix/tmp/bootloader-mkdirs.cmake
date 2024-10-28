# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/components/bootloader/subproject"
  "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader"
  "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader-prefix"
  "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader-prefix/tmp"
  "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader-prefix/src/bootloader-stamp"
  "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader-prefix/src"
  "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader-prefix/src/bootloader-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader-prefix/src/bootloader-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/Public/Nomad_BMS_UF2_Bootloader_tinyuf2/ports/espressif/build/bootloader-prefix/src/bootloader-stamp${cfgdir}") # cfgdir has leading slash
endif()
