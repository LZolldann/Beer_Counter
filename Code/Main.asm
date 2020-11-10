;Haupt-Skript zur Bedienung der Getränkeliste
.include "m16def.inc"
.org 0

.org 0x000
rjmp init

.org INT0addr
rjmp int0_handler

.org INT1addr
rjmp int1_handler

;Interrupt 0 Handler
int0_handler:
in R15, SREG
ldi R23, 2
loopy0:
sbis PIND, 3
rjmp turn_right
dec R23
brne loopy0
out SREG, R15
sei
sbic PORTC, 6
ret
sleep

;Interrupt 1 Handler
int1_handler:
in R15, SREG
ldi R23, 2
loopy1:
sbis PIND, 2
rjmp turn_left
dec R23
brne loopy1
out SREG, R15
sei
sbic PORTC, 6
ret
sleep

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
out ADCSRA, R16
ldi R16, 0b01001010		;enabling idle mode and defining interrupts as falling edge sensitive
out MCUCR, R16
ldi R16, 0b11000000
out GICR, R16
ldi R16, 0b10000000
out ACSR, R16
rcall clear
rcall Hi
rcall delay_eye
ldi XH, 0x65
rcall rise
ldi XH, 0x66
rcall rise
rcall shutdown
rcall clear
sei
sleep

;Reaktion auf Rechtsdrehen
turn_right:
in R15, SREG
adiw Z, 0x0010
sbrs ZH, 0
sbis PORTC, 6
rcall first_int
rcall show
out SREG, R15
sei
rjmp wait

;Reaktion auf Linksdrehen
turn_left:
in R15, SREG
subi ZL, 0x10
sbis PORTC, 6
rcall first_int
rcall show
out SREG, R15
sei
rjmp wait

;Routine zur Reaktion bei erstem Interrupt
first_int:
sbi PORTC, 6
ldi ZH, HIGH($0000)
ldi ZL, LOW($0000)
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
ldi R19, 2
loop12: ldi R18, 255
loop11: ldi R17, 255
loop10: dec R17
brne loop10
dec R18
brne loop11
dec R19
brne loop12
ret

;Routine zum Erhöhen / Verringern des Drink-counters um 1
drink:
in R15, SREG
cli
movw Y, Z
adiw Y, 12
rcall read_2
rcall delay
ldi R19, 2
loop22: ldi R18, 255
loop21: ldi R17, 255
loop20:
sbic PINB, 1
rjmp drink_up
dec R17
brne loop20
dec R18
brne loop21
dec R19
brne loop22
subi XL, 1
brcc drink_down_end
subi XH, 1
brcs error00
drink_down_end:
movw Y, Z
adiw Y, 12
rcall write_2
rcall show
out SREG, R15
sei
drink_down_loop:
sbis PINB, 1
rjmp drink_down_loop
rcall delay
rjmp wait
drink_up:
adiw X, 1
movw Y, Z
adiw Y, 12
rcall write_2
rcall test_999
clr R16
cpse XL, R16
rjmp no_thousand
cpse XH, R16
rjmp no_thousand
cpi R22, 0
breq no_thousand
rcall thousand
no_thousand:
rcall show
out SREG, R15
sei
rjmp wait

;Routine zum kleinen Würdigen von getrunkenen Vielfachen von 1000
thousand:
rcall clear
rcall wake_smile
rcall clear
rcall wake
ldi XH, 0x24
ldi XL, 0b01111110
rcall send
rcall delay_eye
rcall delay_eye
ldi XH, 0x23
rcall send
rcall delay_eye
rcall delay_eye
ldi XH, 0x22
rcall send
rcall delay_eye
rcall delay_eye
ldi XH, 0x21
ldi XL, 0b00110000
rcall send
ldi XH, 0x25
ldi XL, 0b11111111
rcall send
ldi XH, 0x26
rcall send
rcall delay_eye
rcall blink_smile
ret

;Error_handler
error00:
cli
sbi PORTC, 5
rcall err
ldi R16, 0
rcall dig3
rcall dig4
rcall delay_eye
rcall delay_eye
rcall delay_eye
cbi PORTC, 5
rcall show
out SREG, R15
sei
rjmp wait

;Routine zum Erhöhen / Verringern des Bezahlt-counters um 25
pay:
in R15, SREG
cli
movw Y, Z
adiw Y, 14
rcall read_2
rcall delay
ldi R19, 2
loop32: ldi R18, 255
loop31: ldi R17, 255
loop30:
sbic PIND, 5
rjmp pay_up
dec R17
brne loop30
dec R18
brne loop31
dec R19
brne loop32
subi XL, 25
brcc pay_down_end
subi XH, 1
brcs error00
pay_down_end:
movw Y, Z
adiw Y, 14
rcall write_2
rcall show
out SREG, R15
sei
pay_down_loop:
sbis PIND, 5
rjmp pay_down_loop
rcall delay
rjmp wait
pay_up:
adiw X, 25
movw Y, Z
adiw Y, 14
rcall write_2
rcall show
out SREG, R15
sei
rjmp wait

;Routine zum Warten auf weitere Befehle
wait:
ldi R19, 15
loop2: ldi R18, 255
loop1: ldi R17, 255
loop0:
sbis PINB, 1
rjmp drink
nop
sbis PIND, 5
rjmp pay
nop
dec R17
brne loop0
dec R18
brne loop1
dec R19
brne loop2
nop
rcall shutdown
cbi PORTC, 5
cbi PORTC, 6
cbi PORTC, 7
sleep

;Routine zur Anzeige der Werte im EEPROM an Adresse in Register Z über den MAX auf 5 Digits
show:
rcall clear
rcall dec_on
rcall LED
movw Y, Z
adiw Y, 12
rcall read_2
mov R25, XH
mov R24, XL
rcall test_999
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
sbic PORTC, 7
sbr R16, 0b10000000
rcall dig4
mov R16, R17
sbic PORTC, 7
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
rcall error01
c_dec3: ret

;Routine zur Subtraktion der Werte in X um die Werte in R25 & R24 inklusive Betragsbildung und Setzen von PORTC, 5 bei negativem Ergebnis
sub_signed:
cbi PORTC, 7
cp XH, R25
brcs gr
breq eq
rjmp sm
eq:
cp XL, R24
brcs gr
breq eq_eq
rjmp sm
gr:
sbi PORTC, 7
mov R21, R25
mov R20, R24
sub R21, XH
sub R20, XL
brcc end_gr
dec R21
rjmp end_gr
end_gr:
mov XH, R21
mov XL, R20
rjmp end_sub
sm:
sub XH, R25
sub XL, R24
brcc end_sub
dec XH
rjmp end_sub
eq_eq:
clr XH
clr XL
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
in R15, SREG
cli
sbi EECR, EEMWE
sbi EECR, EEWE
out SREG, R15
inc YL
in R18, SREG
sbrc R18, 1
inc YH
sbrc YH, 1
rjmp error02
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
rjmp error02
ret

;Routine zum Test, ob Wert in X 1000 oder Vielfache erreicht, Speichern des Ergebnis in R22 und Bilden des Modulus auf X
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
cpi R22, 0b00001000
brpl error01
ret

;Routine zum Test, ob Wert in X 99 übersteigt
test_99:
clr R16
cpse R16, XH
rcall error01
cpi XL, 100
brcc error01
ret

;Error_handler
error01:
cli
sbi PORTC, 5
rcall err
ldi R16, 0
rcall dig3
inc R16
rcall dig4
rcall delay_eye
rcall delay_eye
rcall delay_eye
cbi PORTC, 5
out SREG, R15
sei
rjmp wait

;Error_handler
error02:
cli
sbi PORTC, 5
rcall err
ldi R16, 0
rcall dig3
ldi R16, 2
rcall dig4
rcall delay_eye
rcall delay_eye
rcall delay_eye
cbi PORTC, 5
out SREG, R15
sei
rjmp wait

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

;Befehl zum Setzen auf maximale Intensität
intense:
ldi XH, 0x02
ldi XL, 0b00001111
rcall send
ret

;Befehl zum Setzen des Scans-limits auf 7
limit:
ldi XH, 0x03
ldi XL, 0x06
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

;Befehl zur Anzeige von Hello über den Max
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

;Befehl zur sichtbaren Füllung der LED's von Digit definiert über XH
rise:
clr XL
sbr XL, 0b10000000
rcall send
rcall delay_eye
sbr XL, 0b00000001
rcall send
rcall delay_eye
sbr XL, 0b00000010
rcall send
rcall delay_eye
sbr XL, 0b00000100
rcall send
rcall delay_eye
sbr XL, 0b00001000
rcall send
rcall delay_eye
sbr XL, 0b00010000
rcall send
rcall delay_eye
sbr XL, 0b00100000
rcall send
rcall delay_eye
sbr XL, 0b01000000
rcall send
rcall delay_eye
ret

;Befehl zur Anzeige eines aufwachenden Smileys über den MAX
wake_smile:
rcall clear
ldi XH, 0x60
ldi XL, 0b00000001
rcall send
ldi XH, 0x63
rcall send
ldi XH, 0x66
ldi XL, 0b01111000
rcall send
rcall wake
ldi R16, 5
smile_loop0:
rcall delay_eye
dec R16
brne smile_loop0
ldi XH, 0x60
ldi XL, 0b01100011
rcall send
ldi XH, 0x63
rcall send
ldi R16, 2
smile_loop1:
rcall delay_eye
dec R16
brne smile_loop1
ldi XH, 0x66
ldi XL, 0b10110100
rcall send
ldi R16, 3
smile_loop2:
rcall delay_eye
dec R16
brne smile_loop2
ret

;Befehl zur Anzeige eines blinkenden Smileys auf P1 des MAX, P0 bleibt erhalten und wird sonst angezeigt
blink_smile:
ldi XL, 0b00000000
ldi XH, 0x41
rcall delay
rcall send
ldi XH, 0x42
rcall send
ldi XH, 0x44
rcall send
ldi XH, 0x45
rcall send
ldi XH, 0x40
ldi XL, 0b01100011
rcall send
ldi XH, 0x43
rcall send
ldi XH, 0x46
ldi XL, 0b10110100
rcall send
ldi XH, 0x04
ldi XL, 0b00001101
rcall send
ldi R16, 20
smile_loop:
rcall delay_eye
dec R16
brne smile_loop
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

;Befehle zur Anzeige von decodierter Ziffer in R16 auf Digit 0, 1, 2, 3 oder 4 inklusive binärer Tausenderanzeige via Punkt im Digit überprüft in R22
dig0:
ldi XH, 0x60
mov XL, R16
sbrc R22, 2
sbr XL, 0b10000000
rcall send
ret

dig1:
ldi XH, 0x61
mov XL, R16
sbrc R22, 1
sbr XL, 0b10000000
rcall send
ret

dig2:
ldi XH, 0x62
mov XL, R16
sbrc R22, 0
sbr XL, 0b10000000
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

;Routine zur Aktivierung der LED in Digit 5, die der Stelle in Z entspricht
LED:
mov YH, ZH
mov YL, ZL
mov R16, ZL
clc
ror R16
ror R16
ror R16
ror R16
ldi XH, 0x65
sbrc R16, 3
ldi XH, 0x66
sbrc R16, 3
cbr R16, 0b00001000
ldi ZH, HIGH(table)
ldi ZL, LOW(table)
add ZL, R16
brcc not_full
inc ZH
not_full:
clr R16
icall
mov ZH, YH
mov ZL, YL
mov XL, R16
rcall send
ret

;Routine zur seriellen Sendung über PORTC, 1 was in X ist
send:
in R15, SREG
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
out SREG, R15
ret

;Routine zur Clock Erzeugung
clock:
sbi PORTC, 0
push R16
ldi R16, 2
loop40: dec R16
brne loop40
pop R16
nop
cbi PORTC, 0
ret

;Tabelle zur Auswahl der LED
table:
rjmp tab0
rjmp tab1
rjmp tab2
rjmp tab3
rjmp tab4
rjmp tab5
rjmp tab6
rjmp tab7
tab0:
sbr R16, 0b10000000
ret
tab1:
sbr R16, 0b00000001
ret
tab2:
sbr R16, 0b00000010
ret
tab3:
sbr R16, 0b00000100
ret
tab4:
sbr R16, 0b00001000
ret
tab5:
sbr R16, 0b00010000
ret
tab6:
sbr R16, 0b00100000
ret
tab7:
sbr R16, 0b01000000
ret
