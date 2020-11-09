;Test-Skript zur Feststellung, wie häufig der Wert in X über 1000 liegt

.include "m16def.inc"
.org 0

.org 0x000
rjmp init

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
ldi XH, 0x03
ldi XL, 0xE9
ldi R22, 0b00000100
sbrs R22, 2
sbr R16, 7
rcall test_999
sei
rjmp end

;Testroutine
test_999:
clr R22
test_999_loop:
cpi XL, 0xE8
ldi R16, 0x03
cpc XH, R16
brmi test_999_end
inc R22
subi XL, 0xE8
sbci XH, 0x03
rjmp test_999_loop
test_999_end:
ret

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
