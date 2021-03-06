set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Find the toolchain
find_path(MSP_INCLUDEPATH msp430.h)
find_program(MSP_CC NAMES msp430-elf-gcc msp430-gcc)
find_program(MSP_CXX NAMES msp430-elf-g++ msp430-g++)
find_program(MSP_NM NAMES msp430-elf-nm msp430-nm)
find_program(MSP_SIZE NAMES msp430-elf-size msp430-size)
find_program(MSP_OBJDUMP NAMES msp430-elf-objdump msp430-objdump)

set(MSP_WARN
  "-pedantic -Wall -Wextra -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wstrict-prototypes -Wshadow -Wformat-security -Wpointer-arith -Wbad-function-cast -Wcast-align -Wunused"
  CACHE STRING "Warnings")

set(MSP_DISABLED_BUILTINS
  "-fno-builtin-printf -fno-builtin-sprintf"
  CACHE STRING "Disabled Builtins")

set(MSP_CFLAGS
  "-mmcu=${MSP_MCU} -isystem ${MSP_INCLUDEPATH} -g -O3 -fdata-sections -ffunction-sections -fverbose-asm ${MSP_DISABLED_BUILTINS} ${MSP_WARN}"
  CACHE STRING "MSP compilation flags")

set(MSP_LFLAGS
  "-mmcu=${MSP_MCU} -Wl,-L${MSP_INCLUDEPATH} -Wl,--gc-sections"
  CACHE STRING "MSP linker flags")

set(MSP_MAPFLAGS
  "-Wl,-Map,"
  CACHE STRING "MSP map flags")

set(CMAKE_CXX_LINK_EXECUTABLE
  "<CMAKE_C_COMPILER> ${CMAKE_EXE_LINKER_FLAGS} <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>"
  CACHE STRING "C++ link command")

set(CMAKE_C_LINK_EXECUTABLE
  ${CMAKE_CXX_LINK_EXECUTABLE}
  CACHE STRING "C link command")
