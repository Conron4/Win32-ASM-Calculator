# Win32-ASM-Calculator
This is a simple win32 based x86 Calculator.
This program runs using the printf and scanf C Standard Libary Functions.

It accepts a double precision floating point input and does scalar double precision arethmitic relying on the SSE2 extenstion set.
# Run
To run simply do ```.\Calculator.exe```
# Source Build
If you wish to build from source:
```nasm -f win32 Calculator.asm```

Then link the .obj file I use golink but you can use any asm linker. **Don't forget msvcrt.dll, this is essential for the c function calls**

```golink /mix /entry _main calculator.obj msvcrt.dll /console```
