# brainfuck-interpreter-assembly
An interpreter for the esoteric language Brainfuck, written in x86 Assembly.

The actual interpreter is contained by the file `brainfuck.s`, and it has to be built in order to run it.

# Disclaimer

I've only worked on the actual interpreter part of the program, the rest are support files that help with compiling and reading any valid BF file you throw at it into the memory. Thus, I only own rights to the `brainfuck.s` file.

# How to use

Build the file by using either executing `make` or compiling each file manually through 
```bash
cc -no-pie -c -g -o "build/main.o" "main.s"
cc -no-pie -c -g -o "build/brainfuck.o" "brainfuck.s"
cc -no-pie -c -g -o "build/read_file.o" "read_file.s"

cc -no-pie -g  -o "brainfuck" build/main.o build/brainfuck.o build/read_file.o
```
Execute the compiled `brainfuck` file by using the command `./brainfuck [filepath]`, where `[filepath]` represents the path of the brainfuck file (ending in .b) you want to interpret.
