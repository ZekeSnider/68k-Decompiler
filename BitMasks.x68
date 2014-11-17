*--------------------------------*
*     Written By: Zeke Snider    *
*     CSS 422                    *
*     Fall 2014                  *
*--------------------------------*

*D7 is used to store the masks. 
*D0 is assumed to be input line
*Data is returned on D1

*(These variables are flexible and can be changed later)


*-----COMMON USE MASKS-----*

*12-15 often used for OP codes
BitMask12to15 
      MOVE.L   %1111000000000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #12,D1                     ;Shifting the irrelavant bits out the right side
      RTS

*9-11 commonly used for register
BitMask9to11 
      MOVE.L   %0000111000000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #9,D1                      ;Shifting the irrelavant bits out the right side
      RTS


*6-8 commonly used for OPMode, OP code
BitMask6to8 
      MOVE.L   %0000000111000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #6,D1                      ;Shifting the irrelavant bits out the right side
      RTS

*6-7 commonly used for size codes
BitMask6to8 
      MOVE.L   %0000000011000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #6,D1                      ;Shifting the irrelavant bits out the right side
      RTS

*3-5 commonly used for EA Mode
BitMask3to5 
      MOVE.L   %0000000000111000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #3,D1                      ;Shifting the irrelavant bits out the right side
      RTS

*0-2 commonly used for EA Register
BitMask0to2 
      MOVE.L   %0000000000000111,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      RTS

*-----SPECIFIC USE MASKS----*

*14-15 used for MOVE OP code
BitMask14to15 
      MOVE.L   %1100000000000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #14,D1                      ;Shifting the irrelavant bits out the right side
      RTS

*12-13 used for MOVE size code
BitMask12to13 
      MOVE.L   %0011000000000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #12,D1                      ;Shifting the irrelavant bits out the right side
      RTS

*8-15 used for ORI OP Code
BitMask8to15 
      MOVE.L   %1111111100000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #8,D1                      ;Shifting the irrelavant bits out the right side
      RTS

*7-15 used for MOVEM OP Code
BitMask7to15 
      MOVE.L   %1111111110000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      ASR      #7,D1                      ;Shifting the irrelavant bits out the right side
      RTS

*8,12-15 SUBQ OP Code
BitMaskSubQ 
      MOVE.L   %1111000100000000,D7       ;Storing the mask to D7
      MOVE.L   D0,D1                      ;Copying the input line to D1
      AND.L    D7,D1                      ;ANDING the Data
      RTS

