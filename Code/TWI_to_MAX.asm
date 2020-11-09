;Skript zur Ansteuerung des Max über den TWI - noch in Bearbeitung
.include "m16def.inc"
.org 0

;Initialisierung
ldi R16, LOW(RAMEND)
out SPL, R16
ldi R16, HIGH(RAMEND)
out SPH, R16
sei
ldi R16, 0b11111111
out DDRC, R16
sbi PORTC, 6
sbi PORTC, 4

;TWI initialisieren
ldi R16, 32					;Bustakt
out TWBR, R16
ldi R16, 0					;Vorteiler Bustakt
out TWSR, R16
ldi R16, 0b00000100
out TWCR, R16

;TWI senden
ldi R16, 0b10100100			;Startbefehl TWI
out TWCR, R16
rcall TWINT_wait
rcall TWSR_check
ldi R16, 0b00000000			;Adresse: general_call & write
out TWDR, R16
ldi R16, 0b10000100
out TWCR, R16
rcall TWINT_wait
rcall TWSR_check
ldi R16, 0b00000111			;Daten: Adresse für Display-Test
ldi R17, 0b00000001			;Daten: Flag des Display-Test
out TWDR, R16
ldi R16, 0b00000100			;TWI_Sendebefehl
cbi PORTC, 4				;Aktivierung Max_Input
out TWCR, R16
rcall TWINT_wait
rcall TWSR_check
out TWDR, R17
ldi R16, 0b00000100			;TWI_Sendebefehl
out TWCR, R16
rcall TWINT_wait
rcall TWSR_check
sbi PORTC, 4				;Deaktivierung Max_Input
ldi R16, 0b00000010			;Daten: Adresse für Intensität
ldi R17, 0b00001111			;Daten: volle Intentisät
out TWDR, R16
ldi R16, 0b00000100			;TWI_Sendebefehl
cbi PORTC, 4				;Aktivierung Max_Input
out TWCR, R16
rcall TWINT_wait
rcall TWSR_check
out TWDR, R17
ldi R16, 0b00000100			;TWI_Sendebefehl
out TWCR, R16
rcall TWINT_wait
rcall TWSR_check
sbi PORTC, 4				;Deaktivierung Max_Input
ldi R16, 0b10010100			;Stopbefehl TWI
out TWCR, R16
sbi PORTC, 7				;Aktivierung blaue LED
rcall end

;Senderoutine für Register R18
send:
out TWDR, R18
ldi R16, 0b10000100
out TWCR, R16
rcall TWINT_wait
rcall TWSR_check

;Testroutine für TWSR
TWSR_check:
in R16, TWSR
andi R16, 0xF8
cpi R16, 0x08
brne not_ack
back:
ret

;Routine bei Nicht-Ack des receivers
not_ack:
ldi R16, 0b00001000
out TWSR, R16
cpi R16, 0x18
brne back

;Errorroutine
error:
sbi PORTC, 5
cbi PORTC, 6
ldi R16, 0b10010100
out TWCR, R16
ldi R16, 0
out TWCR, R16
rcall end

;Warteroutine für INT-Flag
TWINT_wait:
in R16, TWCR
sbrs R16, 7
rjmp TWINT_wait
ret

;Warteroutine
delay:
push R17
ldi	R17, 255
loop:	
dec	R17
brne loop
pop R17
ret

;Dauerwarten
end:
rjmp end
