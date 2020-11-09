@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\Privat\Mikrocontroller\Code\labels.tmp" -fI -W+ie -C V2E -o "C:\Privat\Mikrocontroller\Code\Test.hex" -d "C:\Privat\Mikrocontroller\Code\Test.obj" -e "C:\Privat\Mikrocontroller\Code\Test.eep" -m "C:\Privat\Mikrocontroller\Code\Test.map" "C:\Privat\Mikrocontroller\Code\Main.asm"
