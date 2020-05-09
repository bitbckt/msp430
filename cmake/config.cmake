# Sets a default for an empty variable and displays a message
function(set_variable_if_empty VARIABLE_NAME DEFAULT_VALUE)
    if (NOT ${VARIABLE_NAME})
        set(${VARIABLE_NAME} ${DEFAULT_VALUE} PARENT_SCOPE)
        message(STATUS "${VARIABLE_NAME} is not defined, defaulting to ${DEFAULT_VALUE}")
    endif()
endfunction()

# Supported toolchains:
#  * gcc [default]
set_variable_if_empty(MSP_TOOLCHAIN gcc)

# Supported MCU families:
#  * msp430 [default]
set_variable_if_empty(MSP_FAMILY msp430)

# Supported MCUs:
#  * msp430g2553 [default]
set_variable_if_empty(MSP_MCU msp430g2553)
