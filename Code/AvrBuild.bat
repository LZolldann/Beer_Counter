@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\Temp\Mikrocontroller\Code\labels.tmp" -fI -W+ie -C V2E -o "C:\Temp\Mikrocontroller\Code\Test.hex" -d "C:\Temp\Mikrocontroller\Code\Test.obj" -e "C:\Temp\Mikrocontroller\Code\Test.eep" -m "C:\Temp\Mikrocontroller\Code\Test.map" "C:\Temp\Mikrocontroller\Code\Main.asm"
