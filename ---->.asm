format PE console
entry start

include 'win32a.inc'

MAX_WIDTH = 80
MAX_HEIGHT = 25
MAX_SNAKE = 100

section '.data' data readable writeable
snake_x dd MAX_SNAKE dup(0)
snake_y dd MAX_SNAKE dup(0)
snake_length dd 0
food_x dd ?
food_y dd ?
dir_x dd ?
dir_y dd ?
score dd 0
game_over db 0

section '.code' code readable executable
start:
    ; Initialize console
    push STD_OUTPUT_HANDLE
    call [GetStdHandle]
    mov [stdout], eax

    ; Set random seed
    invoke GetTickCount
    mov eax, dword [eax]
    mov dword [rand_seed], eax

    ; Initialize game
    invoke init_game

    ; Game loop
game_loop:
    ; Handle input
    invoke handle_input

    ; Move snake
    invoke move_snake

    ; Check for collision
    invoke check_collision
    jnz game_over

    ; Check if food has been eaten
    invoke check_food

    ; Draw screen
    invoke draw_screen

    ; Sleep for a bit
    invoke Sleep, 100

    ; Loop back to game_loop
    jmp game_loop

    ; Game over
game_over:
    invoke draw_game_over
    invoke Sleep, 2000
    invoke exit_game

; Initialize game
init_game:
    ; Initialize snake position and direction
    mov dword [snake_x], MAX_WIDTH/2
    mov dword [snake_y], MAX_HEIGHT/2
    mov dword [dir_x], 1
    mov dword [dir_y], 0
    mov dword [snake_length], 1

    ; Spawn food
    invoke spawn_food

    ; Clear screen
    invoke clear_screen

    ; Draw border
    invoke draw_border

    ret

; Handle input
handle_input:
    ; Check for keyboard input
    invoke GetKeyState, VK_LEFT
    and eax, 0x8000
    jnz move_left

    invoke GetKeyState, VK_RIGHT
    and eax, 0x8000
    jnz move_right

    invoke GetKeyState, VK_UP
    and eax, 0x8000
    jnz move_up

    invoke GetKeyState, VK_DOWN
    and eax, 0x8000
    jnz move_down

    ; No input, move in current direction
    mov eax, dword [dir_x]
    mov edx, dword [snake_x]
    add edx, eax
    mov dword [snake_x], edx

    mov eax, dword [dir_y]
    mov edx, dword [snake_y]
    add edx, eax
    mov dword [snake_y], edx

    ret

move_left:
    ; Check that we're not already moving right
    cmp dword [dir_x], 1
    jne .move_left

    ret

.move_left:
    mov dword [dir_x], -1
    mov dword [dir_y], 0
    ret

move_right:
    ; Check that we're not already moving left
    cmp dword [dir_x], -1
    jne .move_right

    ret

.move_right:
    mov dword [dir_x], 1
    mov dword [dir_y], 0
    ret

move_up:
    ; Check that we're not already moving down
    cmp dword [dir_y], 1
    jne .move_up

    ret

.move_up:
    mov dword