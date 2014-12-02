*--------------------------------*
*     Written By: Zeke Snider    *
*     CSS 422                    *
*     Fall 2014                  *
*--------------------------------*

*D6 is used to store the masks. 
*D0 is assumed to be input line
*Data is returned on D7

*(These variables are flexible and can be changed later)


*-----COMMON USE MASKS-----*

*12-15 often used for OP codes
BitMask12to15 
      MOVE.L   %1111000000000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #8,D7                      ;Shifting the irrelavant bits out the right side
      LSR      #4,D7
      RTS

*9-11 commonly used for register
BitMask9to11 
      MOVE.L   %0000111000000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #8,D7                      ;Shifting the irrelavant bits out the right side
      LSR      #1,D7 
      RTS


*6-8 commonly used for OPMode, OP code
BitMask6to8 
      MOVE.L   %0000000111000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #6,D7                      ;Shifting the irrelavant bits out the right side
      RTS

*6-7 commonly used for size codes
BitMask6to7 
      MOVE.L   %0000000011000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #6,D7                      ;Shifting the irrelavant bits out the right side
      RTS

*3-5 commonly used for EA Mode
BitMask3to5 
      MOVE.L   %0000000000111000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #3,D7                      ;Shifting the irrelavant bits out the right side
      RTS

*0-2 commonly used for EA Register
BitMask0to2 
      MOVE.L   %0000000000000111,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      RTS

*-----SPECIFIC USE MASKS----*

*14-15 used for MOVE OP code
BitMask14to15 
      MOVE.L   %1100000000000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #8,D7                     ;Shifting the irrelavant bits out the right side
      LSR      #6,D7
      RTS

*12-13 used for MOVE size code
BitMask12to13 
      MOVE.L   %0011000000000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #8,D7                      ;Shifting the irrelavant bits out the right side
      LSR      #4,D7
      RTS

*8-15 used for ORI OP Code
BitMask8to15 
      MOVE.L   %1111111100000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #8,D7                      ;Shifting the irrelavant bits out the right side
      RTS

*7-15 used for MOVEM OP Code
BitMask7to15 
      MOVE.L   %1111111110000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #7,D7                      ;Shifting the irrelavant bits out the right side
      RTS

*8,12-15 SUBQ OP Code
BitMaskSubQ 
      MOVE.L   %1111000100000000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      RTS


*5 used for LSR/LSL i/r
BitMask5to5 
      MOVE.L   %0000000000100000,D6       ;Storing the mask to D6
      MOVE.L   D0,D7                      ;Copying the input line to D7
      AND.L    D6,D7                      ;ANDING the Data
      LSR      #3,D7                      ;Shifting the irrelavant bits out the right side
      RTS

