
.nolist
.include "m16def.inc"
.list

.org 0

main:  
ldi r16, 0xFF
out ddrc, r16
push r16
ldi r16, 0x00

back:

com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16

call delay_extra

com r16
out portc, r16
call delay_long
com r16
out portc, r16
call delay_long
com r16
out portc, r16
call delay_long
com r16
out portc, r16
call delay_long
com r16
out portc, r16
call delay_long
com r16
out portc, r16

call delay_extra

com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16
call delay_short
com r16
out portc, r16

call delay_extra
call delay_extra
call delay_extra

rjmp back

delay_short:
ldi r18, 100
loop01: ldi r17, 255
loop00: dec r17
brne loop00
dec r18
brne loop01
ret

delay_long:
ldi r18, 200
loop11: ldi r17, 255
loop10: dec r17
brne loop10
dec r18
brne loop11
ret

delay_extra:
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
