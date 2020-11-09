
.nolist
.include "m16def.inc"
.list

.equ f_cpu = 16000000
.equ cnt=$0000
.org 0

main:
ldi ZL, low(cnt)
ldi ZH, high(cnt)
ldi r20, 0xFF
out ddrc, r20
push r20

EEPROM_read:
sbic    EECR, EEWE
rjmp    EEPROM_read
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

rjmp back

delay:
ldi r19, 3
loop22: ldi r18, 255
loop21: ldi r17, 255
loop20: dec r17
brne loop20
dec r18
brne loop21
dec r19
brne loop22
ret
