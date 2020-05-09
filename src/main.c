#include <msp430.h>

int
main(void)
{
    WDTCTL = WDTPW | WDTHOLD;
	
    P1DIR |= BIT0 | BIT6;
	
    P1OUT |= BIT0;
    P1OUT &= ~BIT6;
	
    for (;;) {
        __delay_cycles(1000000);
        P1OUT ^= BIT0 | BIT6;
    }

    return 0;
}
