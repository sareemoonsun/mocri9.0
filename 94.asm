; ==============================================================
; Program: MCS-51 Pulse Generator (Clean Version for M-IDE)
; Crystal: 11.0592 MHz
; P3.4 = Pulse Output
; P1.0 = Button A (100 Pulses, 12 ms Interval)
; P1.1 = Button B (300 Pulses,  6 ms Interval)
; P1.2 = Button C (500 Pulses,  3 ms Interval)
; P1.3 = Button D (700 Pulses,  1 ms Interv al)
; ==============================================================

DLY_MULT    EQU     30H
PULSE_H     EQU     31H
PULSE_L     EQU     32H

            ORG     0000H
            LJMP    MAIN

            ORG     0100H
MAIN:
            MOV     SP, #40H
            CLR     P3.4            ; Reset Pulse Output

            ; Set buttons as Input
            SETB    P1.0
            SETB    P1.1
            SETB    P1.2
            SETB    P1.3

            MOV     TMOD, #01H      ; Timer 0 Mode 1 (16-bit)

LOOP:
            ; Check Button A
            JB      P1.0, CHK_B
            LCALL   DEBOUNCE
            JB      P1.0, CHK_B
            
            MOV     PULSE_H, #00H
            MOV     PULSE_L, #64H
            MOV     DLY_MULT, #12
            LCALL   SEND_PULSE
WAIT_A:     JNB     P1.0, WAIT_A
            SJMP    LOOP

            ; Check Button B
CHK_B:      JB      P1.1, CHK_C
            LCALL   DEBOUNCE
            JB      P1.1, CHK_C
            
            MOV     PULSE_H, #01H
            MOV     PULSE_L, #2CH
            MOV     DLY_MULT, #6
            LCALL   SEND_PULSE
WAIT_B:     JNB     P1.1, WAIT_B
            SJMP    LOOP

            ; Check Button C
CHK_C:      JB      P1.2, CHK_D
            LCALL   DEBOUNCE
            JB      P1.2, CHK_D
            
            MOV     PULSE_H, #01H
            MOV     PULSE_L, #0F4H
            MOV     DLY_MULT, #3
            LCALL   SEND_PULSE
WAIT_C:     JNB     P1.2, WAIT_C
            SJMP    LOOP

            ; Check Button D
CHK_D:      JB      P1.3, LOOP
            LCALL   DEBOUNCE
            JB      P1.3, LOOP
            
            MOV     PULSE_H, #02H
            MOV     PULSE_L, #0BCH
            MOV     DLY_MULT, #1
            LCALL   SEND_PULSE
WAIT_D:     JNB     P1.3, WAIT_D
            SJMP    LOOP


; ==============================================================
; Subroutine: Generate Pulses on P3.4
; ==============================================================
SEND_PULSE:
SP_LOOP:
            SETB    P3.4            ; High
            LCALL   DELAY_DYNAMIC
            
            CLR     P3.4            ; Low
            LCALL   DELAY_DYNAMIC

            ; 16-bit Decrement
            MOV     A, PULSE_L
            JZ      SP_DEC_H
            DEC     PULSE_L
            SJMP    SP_CHECK
SP_DEC_H:
            DEC     PULSE_H
            DEC     PULSE_L
SP_CHECK:
            MOV     A, PULSE_H
            ORL     A, PULSE_L
            JNZ     SP_LOOP
            RET

; ==============================================================
; Subroutine: Dynamic Delay (0.5ms base)
; ==============================================================
DELAY_DYNAMIC:
            MOV     R7, DLY_MULT
DYN_LOOP:
            MOV     TH0, #0FEH
            MOV     TL0, #33H
            CLR     TF0
            SETB    TR0
WAIT_T0:    JNB     TF0, WAIT_T0
            CLR     TR0
            
            DJNZ    R7, DYN_LOOP
            RET

; ==============================================================
; Subroutine: Button Debounce (~20ms)
; ==============================================================
DEBOUNCE:
            MOV     R6, #40
DB_LOOP:
            MOV     TH0, #0FEH
            MOV     TL0, #33H
            CLR     TF0
            SETB    TR0
WAIT_DB:    JNB     TF0, WAIT_DB
            CLR     TR0
            DJNZ    R6, DB_LOOP
            RET

            END