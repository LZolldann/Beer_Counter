;Skript zur manuellen Ansteuerung des Max über die I/O Pins PortC - noch in Bearbeitung
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
ldi R16, 0b01010000
out PORTC, R16
rcall delay

;Main
rcall intense
rcall Hi

sbi PORTC, 7
rjmp end

;Befehl zur Beendigung des Shutdown-Modus
wake:
ldi XH, 0x04
ldi XL, 0b00000001
rcall send
ret

;Befehl zur Aktivierung des Shutdown-Modus
shutdown:
ldi XH, 0x04
ldi XL, 0b00000000
rcall send
ret

;Befehl zur Erhöhung der Intensität auf oberes Mittel
intense:
ldi XH, 0x02
ldi XL, 0b00001011
rcall send
ret

;Befehl zum Setzen des Scans-limits auf 8
limit:
ldi XH, 0x03
ldi XL, 0x07
rcall send
ret

;Befehl zur Aktivierung der Decodierung für die Digits 0 bis 4
dec_on:
ldi XH, 0x01
ldi XL, 0b00011111
rcall send
ret

;Befehl zur Deaktivierung der Decodierung für alle Digits
dec_off:
ldi XH, 0x01
ldi XL, 0b00000000
rcall send
ret

;Befehlt zur Anzeige von Hello über
Hi:
rcall clear
ldi XH, 0x60
ldi XL, 0b00110111
rcall send
ldi XH, 0x61
ldi XL, 0b01001111
rcall send
ldi XH, 0x62
ldi XL, 0b00001110
rcall send
ldi XH, 0x63
rcall send
ldi XH, 0x64
ldi XL, 0b01111110
rcall send
rcall wake
ret

;Befehl zur Anzeige von Err über den MAX
err:
rcall clear
ldi XH, 0x01
ldi XL, 0b00011000
rcall send
ldi XH, 0x60
ldi XL, 0b01001111
rcall send
ldi XH, 0x61
ldi XL, 0b00000101
rcall send
ldi XH, 0x62
ldi XL, 0b00000101
rcall send
rcall wake
ret

;Befehl zur Löschung aller Digits und Aktivierung des Shutdown-Modus
clear:
rcall limit
rcall intense
rcall dec_off
ldi XH, 0x04
ldi XL, 0b00100000
rcall send
ret

;Befehl zur De-/Aktivierung des Display Tests senden
test_on:
ldi XH, 0x07
ldi XL, 0b00000001
rcall send
ret

test_off:
ldi XH, 0x07
ldi XL,0b00000000
rcall send
ret

;Befehle zur Anzeige von decodierter Ziffer in R16 auf Digit 0, 1, 2, 3 oder 4
dig0:
ldi XH, 0x60
mov XL, R16
rcall send
ret

dig1:
ldi XH, 0x61
mov XL, R16
rcall send
ret

dig2:
ldi XH, 0x62
mov XL, R16
rcall send
ret

dig3:
ldi XH, 0x63
mov XL, R16
rcall send
ret

dig4:
ldi XH, 0x64
mov XL, R16
rcall send
ret

;Routine zur seriellen Sendung über PORTC, 1 was in X ist
send:
cli
cbi PORTC, 4
sbi PORTC, 1
sbrs XH, 7
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XH, 6
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XH, 5
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XH, 4
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XH, 3
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XH, 2
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XH, 1
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XH, 0
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 7
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 6
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 5
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 4
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 3
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 2
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 1
cbi PORTC, 1
rcall clock
sbi PORTC, 1
sbrs XL, 0
cbi PORTC, 1
rcall clock
sbi PORTC, 4
sei
ret

;Routine zur Clock Erzeugung
clock:
sbi PORTC, 0
push R16
ldi R16, 2
loop1: dec R16
brne loop1
pop R16
nop
cbi PORTC, 0
ret

;Delay
delay:
ldi r17, 20
loop: dec r17
brne loop
ret

;Delay for human eye
delayl:
ldi r18, 255
loop01: ldi r17, 255
loop00: dec r17
brne loop00
dec r18
brne loop01
ret

;Dauerwarten
end:
rjmp end
