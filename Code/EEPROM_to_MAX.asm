;Skript zur Anzeige ausgewählter Daten im EEPROM über den MAX
.include "m16def.inc"
.org 0

;Initialisierung
ldi R16, LOW(RAMEND)
out SPL, R16
ldi R16, HIGH(RAMEND)
out SPH, R16
ldi R16, 0b11111111
out DDRC, R16
ldi R16, 0b01010000
out PORTC, R16
sei
rcall delay

;Main
ldi ZH, high($0010)
ldi ZL, low($0010)
rcall show

sbi PORTC, 7
rjmp end

;Routine zur Anzeige der Werte im EEPROM an Adresse in Register Z über den MAX auf 5 Digits
show:
rcall dec_on
movw Y, Z
adiw Y, 12
rcall read_2
rcall test_999
mov R25, XH
mov R24, XL
rcall bin_to_dec
rcall dig2
mov R16, R17
rcall dig1
mov R16, R18
rcall dig0
rcall read_2
rcall sub_signed
rcall test_99
rcall bin_to_dec
sbic PORTC, 5
sbr R16, 0b10000000
rcall dig4
mov R16, R17
sbic PORTC, 5
sbr R16, 0b10000000
rcall dig3
rcall wake
ret

;Routine zum Umrechnen des Binärwerts in X und Speicherung der Ziffern in R18, R17 & R16
bin_to_dec:
clr R18
clr R17
clr R16
sbrc XH, 1
rcall add_512
sbrc XH, 0
rcall add_256
sbrc XL, 7
rcall add_128
sbrc XL, 6
rcall add_64
sbrc XL, 5
rcall add_32
sbrc XL, 4
rcall add_16
sbrc XL, 3
rcall add_8
sbrc XL, 2
rcall add_4
sbrc XL, 1
rcall add_2
sbrc XL, 0
rcall add_1
ret

;Subs für bin_to_dec
add_512:
inc R16
inc R16
inc R17
ldi R19, 5
add R18, R19
rcall c_dec
ret
add_256:
ldi R19, 6
add R16, R19
dec R19
add R17, R19
inc R18
inc R18
rcall c_dec
ret
add_128:
ldi R19, 8
add R16, R19
inc R17
inc R17
inc R18
rcall c_dec
ret
add_64:
ldi R19, 4
add R16, R19
ldi R19, 6
add R17, R19
rcall c_dec
ret
add_32:
inc R16
inc R16
ldi R19, 3
add R17, R19
rcall c_dec
ret
add_16:
ldi R19, 6
add R16, R19
inc R17
rcall c_dec
ret
add_8:
ldi R19, 8
add R16, R19
rcall c_dec
ret
add_4:
ldi R19, 4
add R16, R19
rcall c_dec
ret
add_2:
inc R16
inc R16
rcall c_dec
ret
add_1:
inc R16
rcall c_dec
ret
c_dec:
cpi R16, 10
brcs c_dec1
inc R17
subi R16, 10
c_dec1:
cpi R17, 10
brcs c_dec2
inc R18
subi R17, 10
c_dec2:
cpi R18, 10
brcs c_dec3
rcall error
c_dec3: ret

;Routine zur Subtraktion der Werte in X um die Werte in R25 & R24 inklusive Betragsbildung und Setzen von PORTC, 5 bei negativem Ergebnis
sub_signed:
cbi PORTC, 5
sub XH, R25
brcs gr
breq eq
rjmp sm
gr:
com XH
inc XH
sbi PORTC, 5
sub XL, R24
brcc end_sub
dec XH
rjmp end_sub
eq:
sub XL, R24
brcc end_sub
sbi PORTC, 5
com XL
inc XL
rjmp end_sub
sm:
sub XL, R24
brcc end_sub
dec XH
rjmp end_sub
end_sub: ret

;Routine zum Schreiben der Werte in X über EEPROM_write
write_2:
push R16
mov R16, XH
rcall EEPROM_write
mov R16, XL
rcall EEPROM_write
pop R16
ret

;Routine zum Schreiben des Werts in R16 in den EEPROM an Adresse in Register Y inkl. Postinkrementierung
EEPROM_write:
sbic EECR, EEWE
rjmp EEPROM_write
out EEARH, YH
out EEARL, YL
out EEDR, R16
cli
sbi EECR, EEMWE
sbi EECR, EEWE
sei
inc YL
in R18, SREG
sbrc R18, 1
inc YH
sbrc YH, 1
rjmp error
ret

;Routine zum Lesen in X über EEPROM_read
read_2:
push R16
rcall EEPROM_read
mov XH, R16
rcall EEPROM_read
mov XL, R16
pop R16
ret

;Routine zum Lesen der Werte an Adresse in Register Y aus EEPROM in R16 inkl. Postinkrementierung
EEPROM_read:
sbic EECR, EEWE
rjmp EEPROM_read
out EEARH, YH
out EEARL, YL
sbi EECR, EERE
in R16, EEDR
inc YL
in R18, SREG
sbrc R18, 1
inc YH
sbrc YH, 1
rjmp error
ret

;Routine zum Test, ob Wert in X 999 übersteigt
test_999:
ldi R16, 0b11111100
clr R17
and R16, XH
cpse R16, R17
rjmp error
mov R25, XH
mov R24, XL
adiw R24, 24
sbrc R25, 2
rcall error
ret

;Routine zum Test, ob Wert in X 99 übersteigt
test_99:
clr R16
cpse R16, XH
rcall error
cpi XL, 100
brcc error
ret

;Error_handler
error:
cbi PORTC, 6
sbi PORTC, 5
rcall err
ldi R16, 0
rcall dig3
inc R16
rcall dig4
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

;Befehl zur Löschung aller Digits, Deaktivierung der Decodierung und Aktivierung des Shutdown-Modus
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
delay_h:
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

