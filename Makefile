TARGET = kernel.bin
ISO = kernel.iso
CC = gcc
AS = nasm
LD = ld
CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -m elf_i386

SRC = src/kernel.c
ASM = src/boot.s

OBJ = $(ASM:.s=.o) $(SRC:.c=.o)

all: $(ISO)

%.o: %.s
	$(AS) -f elf32 $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJ) linker.ld
	$(LD) $(LDFLAGS) -T linker.ld -o $@ $(OBJ)

$(ISO): $(TARGET)
	mkdir -p iso/boot/grub
	cp $(TARGET) iso/boot/kernel.bin
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My Kernel" {' >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/kernel.bin' >> iso/boot/grub/grub.cfg
	echo '  boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) iso

qemu: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

clean:
	rm -rf $(OBJ) $(TARGET) iso $(ISO)
