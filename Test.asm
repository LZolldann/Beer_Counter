;Test-Skript
.include "m16def.inc"
.org 0

.org 0x000
rjmp init

.org INT0addr
rjmp int0_handler

.org INT1addr
rjmp int1_handler

.org INT2addr
rjmp int2_handler

;Initialisierung
init:
cli
ldi R16, LOW(RAMEND)
out SPL, R16
ldi R16, HIGH(RAMEND)
out SPH, R16
ldi R16, 0b11111111
out DDRC, R16
ldi R16, 0b00010000
out PORTC, R16
clr R16
out DDRB, R16
out PORTB, R16
out DDRD, R16
out PORTD, R16
ldi R16, 0b01001010
out MCUCR, R16
ldi R16, 0b11000000
out GICR, R16
ldi R16, 0b10000000
out ACSR, R16
sei
rjmp end

int0_handler:
sbi PORTC, 7
reti

int1_handler:
sbi PORTC, 6
reti

int2_handler:
sbi PORTC, 5
reti

;Routine für Delay
delay:
ldi R18, 200
loop01: ldi R17, 255
loop00: dec R17
brne loop00
dec R18
brne loop01
ret

;Routine für sichtbares Delay
delay_eye:
ldi R19, 5
loop12: ldi R18, 255
loop11: ldi R17, 255
loop10: dec R17
brne loop10
dec R18
brne loop11
dec R19
brne loop12
ret

;Dauerschleife
end: rjmp end
