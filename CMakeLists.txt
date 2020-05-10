cmake_minimum_required(VERSION 3.1...3.16)

if(${CMAKE_VERSION} VERSION_LESS 3.12)
  cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
endif()

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

include("config")

set(TOOLCHAIN "${CMAKE_MODULE_PATH}/${MSP_TOOLCHAIN}/${MSP_FAMILY}.cmake")

if(NOT EXISTS ${TOOLCHAIN})
  message(FATAL_ERROR "Can't locate toolchain ${TOOLCHAIN} for ${MSP_FAMILY} family of MCUs and ${MSP_TOOLCHAIN} toolchain!")
endif()

set(CMAKE_TOOLCHAIN_FILE ${TOOLCHAIN})

project(example
  VERSION 0.1
  LANGUAGES)

set(CMAKE_C_COMPILER   ${MSP_CC} CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER ${MSP_CXX} CACHE STRING "" FORCE)

set(AR      ${MSP_AR}        CACHE STRING "" FORCE)
set(AS      ${MSP_AS}        CACHE STRING "" FORCE)
set(NM      ${MSP_NM}        CACHE STRING "" FORCE)  
set(OBJCOPY ${MSP_OBJCOPY}   CACHE STRING "" FORCE)
set(OBJDUMP ${MSP_OBJDUMP}   CACHE STRING "" FORCE)
set(SIZE    ${MSP_SIZE}      CACHE STRING "" FORCE)

# Do not link executables during compiler tests
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

enable_language(C)
enable_language(CXX)

add_subdirectory(src)

set(EXE ${PROJECT_NAME})
set(ELF "${EXE}-${MSP_MCU}.elf")
set(MAP "${EXE}-${MSP_MCU}.map")
set(LST "${EXE}-${MSP_MCU}.lst")
set(SYM "${EXE}-${MSP_MCU}.sym")

add_executable(${ELF}
  src/main.c)

set_target_properties(
  ${ELF} PROPERTIES
  C_STANDARD 99
  COMPILE_FLAGS "${MSP_CFLAGS}"
  LINK_FLAGS "${MSP_LFLAGS} -Wl,-Map,${MAP}")

if(DEFINED OBJDUMP)
  add_custom_target(
    ${LST} ALL
    ${OBJDUMP} -h -S ${ELF} > ${LST}
    DEPENDS ${ELF})
endif()

if(DEFINED SIZE)
  add_custom_target(
    ${EXE}-${MSP_MCU}-size ALL
    ${SIZE} ${ELF}
    DEPENDS ${ELF})
endif()

add_custom_target(
  ${SYM} ALL
  ${NM} -l -a -S -s --size-sort ${ELF} > ${SYM}
  DEPENDS ${ELF})

add_custom_target(${EXE} ALL DEPENDS ${ELF})
