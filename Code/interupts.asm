.include "m16def.inc"
.org 0

.org 0x000
rjmp main
.org INT0addr
rjmp int0_handler    ; IRQ0 Handler
.org INT1addr
rjmp int1_handler    ; IRQ1 Handler

main:
ldi R16, (1<<ISC01)|(1<<ISC11) ; INT0 auf fallende Flanke konfigurieren
out MCUCR, R16
ldi R16, (1<<INT0)|(1<<INT1)  ; INT0  aktivieren
out GICR, R16
sei                   ; Interrupts allgemein aktivieren

loop:
rjmp loop             ; eine leere Endlosschleife
int0_handler:
sbi PORTC, 5
reti
int1_handler:
cbi PORTC, 5
reti
