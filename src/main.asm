%define endl 10, 13

[ORG 0x10000]
[BITS 16]

;; CODE

mov bh, 0x07
call clear
mov si, welcome_msg
call puts

command_loop:
  mov si, prompt
  call puts

  mov di, command_buffer
  mov cx, 255
  call gets

  mov si, help_cmd
  call cmps
  jc ch_help

  mov si, clear_cmd
  call cmps
  jc ch_clear

  mov si, boykisser_cmd
  call cmps
  jc ch_boykisser

  mov si, bothkisser_cmd
  call cmps
  jc ch_bothkisser

  mov si, neofetch_cmd
  call cmps
  jc ch_neofetch

  mov si, restart_cmd
  call cmps
  jc ch_restart

  jmp ch_invalid

halt:
  cli
  hlt
  jmp halt

;; COMMAND HANDLERS

ch_help:
  mov si, help_msg
  call puts
  jmp command_loop

ch_clear:
  call clear
  jmp command_loop

ch_boykisser:
  mov si, boykisser
  call puts
  jmp command_loop

ch_bothkisser:
  mov si, bothkisser
  call puts
  jmp command_loop

ch_neofetch:
  mov si, neofetch_msg
  call puts
  jmp command_loop

ch_restart:
  mov si, restart_msg
  call puts
  jmp command_loop

ch_invalid:
  mov si, invalid_msg
  call puts
  jmp command_loop

;; FUNCTIONS

puts: ; prints a string to the screen | params: ( string: ds:si ) | returns: void
  push si
  push ax
  push bx
  xor bh, bh
  mov ah, 0x0e
  .loop:
    lodsb
    test al, al
    jz .end
    int 0x10
    jmp .loop
  .end:
    pop bx
    pop ax
    pop si
    ret

gets: ; gets a string from the user | params: ( buffer: es:di, max_count: cx ) | returns: void
  push di
  push cx
  push bx
  push ax

  xor bx, bx
  .loop:
    xor ah, ah
    int 0x16
    cmp ah, 0x1c
    je .end

    test cx, cx
    jz .loop
    dec cx

    stosb
    mov ah, 0x0e
    int 0x10
    jmp .loop
  .end:
    mov byte es:[di], 0

    mov ah, 0x0e
    mov al, 10
    int 0x10
    mov al, 13
    int 0x10

    pop ax
    pop bx
    pop cx
    pop di
    ret

cmps: ; compares two strings | params: ( string1: ds:si, string2: es:di ) | returns: ( equal: CF )
  push di
  push si
  push ax

  .loop:
    mov al, ds:[si]
    mov ah, es:[di]
    cmp al, ah
    jne .not_equal
    test al, al
    jz .equal
    inc si
    inc di
    jmp .loop
  .not_equal:
    clc
    jmp .done
  .equal:
    stc
  .done:
    pop ax
    pop si
    pop di
    ret

clear: ; clears the screen | params: ( colour: bh ) | returns: void
  push dx
  push cx
  push ax
  mov ax, 0x0700
  xor cx, cx
  mov dx, 0x184f
  int 0x10
  mov ah, 0x02
  mov ch, bh
  xor bh, bh
  xor dx, dx
  int 0x10
  mov bh, ch
  pop ax
  pop cx
  pop dx
  ret

;; DATA

welcome_msg: db "Welcome to The Bothkisser Operating System (BiOS) based on BoykisserOS :3", endl, 0
prompt: db ":3 ", 0

help_cmd: db "help", 0
help_msg: 
          db "Aw, you need help? I gotchu!", endl, endl   ; same as with neofetch_msg
          db "help - shows this message", endl
          db "clear - clears the screen", endl
          db "boykisser - shows boykisser uwu", endl
          db "bothkisser - shows bothkisser owo", endl
          db "neofetch - that is not neofetch >:3", endl, 0   ; do not forget zero at end, as it tells the puts function when to stop printing

boykisser_cmd: db "boykisser", 0
boykisser: db "    .@.                       .@-  ", endl
           db "   .@@@@.                   .@@@@. ", endl
           db "  .@@@@@@%    @#..         @@@@@@@ ", endl
           db "  @@@@@@@@@.  =@@@@@:    @@@@@@@@@.", endl
           db " .@@@@@@@@@@@  :=@@@@@%:@@@@@@@@@@.", endl
           db " .@@@@@@@@@+@@@@@@@@@@@@@@@@@@@@@@.", endl
           db "  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ", endl
           db "  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@# ", endl
           db "   @@@@@@@@@@@@@@@@@-   ++.*@@@@@  ", endl
           db "    @@@.@@.   @@@@@@    @@@+@@@:   ", endl
           db ".@%-:@@@@@-   @@@@@@.   @@@.@@@@@  ", endl
           db "  @@@@@=@@@  -@@@@@@@*:@@@@*@@@=   ", endl
           db "   .@-=@=@@@@@@@@@@@@@@@@-%+@@@    ", endl
           db "  .@@@@@@@@@@%##:%::@@@@@@@@@@@@#  ", endl
           db "    .  =@@@@@@@@@@@@@@@@@@.        ", endl
           db "          @=..@@@@@@@@@@           ", endl
           db "            @@@@@@@@@@@@@          ", endl
           db "           @@@@@@@@@@@@@@+         ", endl
           db "            %@@@@@@@@@@@@@.        ", endl
           db "           .@@@@@@@@@@@@@@@        ", endl
           db "           @@@@@@@@@@@@@@@@.       ", endl
           db "           @@@@@@@@@@@@@@@@.       ", endl
           db "          *@@@@@@@@@@@@@@@@#       ", endl
           db "          @@@@@@@@@@@@@@@@@@       ", endl, 0

bothkisser_cmd: db "bothkisser", 0
bothkisser:
            db "      ......           ...==..                            ", endl,                        
            db "      ..#**+...        ..*****..                          ", endl,                 
            db "    ..+**+***..     ..=***++**:...                        ", endl,        
            db "    ..+**+++***=.. ...#**++++***.. ..+#-.                 ", endl, 
            db "    .:**++++++*********++++++++*+..**+***:=*-.            ", endl,
            db "   ..**+++++++++++++++++++++++++*.=#**++**++*#.           ", endl,
            db "    :**+++++++++++++++++++++++++*==#**#****+*#.           ", endl,
            db "   .-*+++++++++++++++++++*****++**.#####***##-......      ", endl,
            db "   .:**********++++++***#@@%%****=..%%%%%##+.:+**+..      ", endl,
            db " ...-***###%%%******+*%#****+++****..%%#-..:**++*=..      ", endl,
            db " ..=*++++++++++********++++++++++**..:. ..=*++++**:.      ", endl,
            db " ...**++++++++**######**+++++++++*=.   ...**+++**=..      ", endl,
            db "   .-*++++++++++*####*++++++++++**..    .-*++++**...      ", endl,
            db "    .:**++++++++*#++**++++++++**=..     .=*++++**...      ", endl,
            db "   ...=**+++++++***++++++++**+..       .-*+++++*=..       ", endl,
            db "      ...=****+++++++++++******:.       ..********=...    ", endl,
            db "      ..=*****++****************-..      .-*********...   ", endl,
            db "        .***********************#=...     ..-*********=...", endl,
            db "        :***********************#**=.. ..   ..*********+..", endl,
            db "     .+**************************#*:...   ..+*******#*..  ", endl,
            db "     ..+#***************************#*:..   ..=#***#*##-. ", endl,
            db "       ..+#*******######*###############*...  ..=########.", endl, 0

neofetch_cmd: db "neofetch", 0
neofetch_msg:
        db "BothkisserOS", endl, endl  ; can use 2 newlines instead of db empty line, could also technically do 'db BothkisserOS, 10, endl, 0' to save 1 byte of space (not that it really matters)
        ;; db bothkisser, endl
        db "Version: v1.0.0 Birobice", endl, 0

restart_cmd: db "restart", 0
restart_msg: db "Restarting is not yet implemented", endl, 0

clear_cmd: db "clear", 0

invalid_msg: db "Uh oh you used an invalid command >:(", endl, 0

command_buffer: times 256 db 0
