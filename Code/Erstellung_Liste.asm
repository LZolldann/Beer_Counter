;Listenerstellung, vor Benutzung aktualisieren
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

;Startbedingungen Liste

;Josh
ldi ZH, high($0000)
ldi ZL, low($0000)
ldi R16, 74
rcall EEPROM_write
ldi R16, 111
rcall EEPROM_write
ldi R16, 115
rcall EEPROM_write
ldi R16, 104
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 1
rcall EEPROM_write
ldi R16, 47
rcall EEPROM_write
ldi R16, 1
rcall EEPROM_write
ldi R16, 44
rcall EEPROM_write

;Luca
ldi ZL, low($0010)
ldi R16, 76
rcall EEPROM_write
ldi R16, 117
rcall EEPROM_write
ldi R16, 99
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 1
rcall EEPROM_write
ldi R16, 18
rcall EEPROM_write
ldi R16, 1
rcall EEPROM_write
ldi R16, 69
rcall EEPROM_write

;Soerrn
ldi ZL, low($0020)
ldi R16, 83
rcall EEPROM_write
ldi R16, 111
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 114
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 110
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
ldi R16, 221
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
ldi R16, 225
rcall EEPROM_write

;Valle
ldi ZL, low($0030)
ldi R16, 86
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 108
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
ldi R16, 40
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
ldi R16, 50
rcall EEPROM_write

;Tobi
ldi ZL, low($0040)
ldi R16, 84
rcall EEPROM_write
ldi R16, 111
rcall EEPROM_write
ldi R16, 98
rcall EEPROM_write
ldi R16, 105
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 6
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Gerrit
ldi ZL, low($0050)
ldi R16, 71
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 114
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 105
rcall EEPROM_write
ldi R16, 116
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 12
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Jannes
ldi R16, 74
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 110
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 115
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 16
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Lennart
ldi R16, 76
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 110
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 114
rcall EEPROM_write
ldi R16, 116
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 4
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Flo
ldi R16, 70
rcall EEPROM_write
ldi R16, 108
rcall EEPROM_write
ldi R16, 111
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 20
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Max
ldi R16, 77
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 120
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 7
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Matti
ldi R16, 77
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 116
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 105
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 47
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Helena
ldi R16, 72
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 108
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 110
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 5
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Cem
ldi R16, 67
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 109
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 7
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Kilian
ldi R16, 75
rcall EEPROM_write
ldi R16, 105
rcall EEPROM_write
ldi R16, 108
rcall EEPROM_write
ldi R16, 105
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 110
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 2
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Nora
ldi R16, 78
rcall EEPROM_write
ldi R16, 111
rcall EEPROM_write
ldi R16, 114
rcall EEPROM_write
ldi R16, 97
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 3
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Felix
ldi R16, 70
rcall EEPROM_write
ldi R16, 101
rcall EEPROM_write
ldi R16, 108
rcall EEPROM_write
ldi R16, 105
rcall EEPROM_write
ldi R16, 120
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
rcall EEPROM_write
ldi R16, 2
rcall EEPROM_write
ldi R16, 0
rcall EEPROM_write
rcall EEPROM_write

;Fertig
sbi PORTC, 7
rcall end

;Routine zum Schreiben der Werte in R16 in den EEPROM an Adresse in Register Z und verschiebt diese um 1
EEPROM_write:
sbic EECR, EEWE
rjmp EEPROM_write
out EEARH, ZH
out EEARL, ZL
out EEDR, r16
cli
sbi EECR, EEMWE
sbi EECR, EEWE
sei
inc ZL
brne OK
inc ZH
OK: ret

;Dauerwarten
end:
rjmp end
