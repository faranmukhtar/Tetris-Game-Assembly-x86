INCLUDE Irvine32.inc

BOARD_WIDTH      EQU 10                             ; 10 columns
BOARD_HEIGHT     EQU 20                             ; 20 rows
BOARD_SIZE       EQU BOARD_WIDTH * BOARD_HEIGHT

TOTAL_ROTATIONS             EQU 4
TOTAL_COORDINATES           EQU 4
TOTAL_PIECES                EQU 7                              ; 7 shapes
PIECE_LENGTH                EQU 5
PIECE_SIZE                  EQU PIECE_LENGTH * PIECE_LENGTH    ; 5 x 5 matrix = 25
PIECE_ROTATIONS_SIZE        EQU PIECE_SIZE * TOTAL_ROTATIONS   ; 25 * 4 matrix = 100

SPAWN_X          EQU 3         ; column 3 (center)
SPAWN_Y          EQU 0        ; top row

IFNDEF BOARD_STATE_ASM
    EXTERN boardArray:BYTE     ; Declared in board_state.asm
    EXTERN initializeBoard@0:PROC
    EXTERN setBoardCoordinates@0:PROC
ENDIF

IFNDEF PIECE_DEFINITIONS_ASM
    EXTERN pieceArray:BYTE
    EXTERN getRandomPiece@0:PROC
ENDIF

IFNDEF LINES_ASM
    EXTERN clearFullLines@0:PROC
    EXTERN checkFullLine@0:PROC
    EXTERN checkGameOver@0:PROC
ENDIF

IFNDEF MAP_ARRAY_ASM
    EXTERN mapArray@0:PROC
ENDIF

IFNDEF MOVEMENT_ASM
    EXTERN movePieceHorizontal@0:PROC
    EXTERN movePieceDown@0:PROC
    EXTERN placePiece@0:PROC
    EXTERN rotatePiece@0:PROC
    EXTERN isSafe@0:PROC
    EXTERN checkCollision@0:PROC
ENDIF

IFNDEF GAME_ASM
    EXTERN startGame@0:PROC
ENDIF

IFNDEF INPUT_ASM
    EXTERN takeInput@0:PROC
ENDIF

IFNDEF SCORE_ASM
    EXTERN score:DWORD
    EXTERN updateScore@0:PROC
ENDIF

IFNDEF SCREEN_ASM
    EXTERN drawBoard@0:PROC
    EXTERN drawNextPiece@0:PROC
ENDIF