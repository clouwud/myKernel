{
  description = "kernel from scratch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "kernel-dev-shell";
        buildInputs = [
          pkgs.gcc               # C compiler
          pkgs.binutils          # assembler, linker, objdump, etc.
          pkgs.nasm              # NASM assembler
          pkgs.asm-lsp           # NASM assembler
          pkgs.qemu              # VM to test kernel
          pkgs.grub2             # bootloader tools
          pkgs.xorriso           # for making bootable ISO images
          pkgs.gdb               # debugger (optional, but useful)
        ];

        shellHook = ''
          echo "Welcome to the kernel dev shell!"
          echo "You have GCC, NASM, QEMU, GRUB, xorriso, and GDB ready."
          echo "Run 'make qemu' (after writing your Makefile) to boot your kernel."
        '';
      };
    };
}
