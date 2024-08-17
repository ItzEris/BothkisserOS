# The Bothkisser Operating System


Must have: make nasm qemu mtools

# Building

## Linux

First install these requirements:
```
make
nasm
qemu
mtools
```

Open the Makefile:
```
sudo nano Makefile
```
And change the following command to match the command you run Qemu with on your machine:
![image](https://github.com/user-attachments/assets/1d307609-6d92-41c1-b180-bbdd06b3ad64)

for example

```
qemu-system-i386 -drive if=floppy,file=build/main.img,format=raw &
```

then build using this command:

```
make
```
and run using:
```
make run
```

