
.nolist
.include "m16def.inc"
.list

.equ cnt=$0000
.org 0

main:  
ldi r16, 3
ldi ZL, low(cnt)
ldi ZH, high(cnt)
ldi r20, 0xFF
out ddrc, r20
push r20

EEPROM_write:
sbic    EECR, EEWE
rjmp    EEPROM_write
out EEARH, ZH
out EEARL, ZL
out EEDR, r16
in r17, sreg
cli
sbi EECR, EEMWE
sbi EECR, EEWE
out sreg, r17
call delay

ldi r16, 0x00
ldi r17, 0x00


start:
EEPROM_read:
sbic EECR, EEWE
rjmp EEPROM_read
out EEARH, ZH
out EEARL, ZL
sbi EECR, EERE
in r16, EEDR

back:
out portc, r20
call delay
com r20
out portc, r20
call delay
com r20
dec r16
brne back

call delay
call delay
call delay
call delay
call delay

rjmp start

delay:
ldi r19, 3
loop2: ldi r18, 255
loop1: ldi r17, 255
loop0: dec r17
brne loop0
dec r18
brne loop1
dec r19
brne loop2
ret
