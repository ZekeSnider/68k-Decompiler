*--------------------------------*
*     Written By: Zeke Snider    *
*     CSS 422                    *
*     Fall 2014                  *
*--------------------------------*


*D0 is assumed to be input line
*D1 is used to store the return value from the BitMasks
*Assuming D2 is Addressing Mode
*Assuming D3 is Register
*D4 stores register as decimal number

EA_NEG                              ;Parsing EA for NEG function

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D1,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D1,D3             ;Moving return value to D3

      CMP.L       %001,D2           ;Register direct is not a valid input for NEG
      BRA         ERROR

      JSR         EA_PARSE_MODE     ;Calling parse mode function to write data to the stack

      BSR                           ;Returning to source


*These functions are called when the EA Mode matches.
*They store the human ouput code to the A0 register, then increment it.
*Then return to where they were called from.
EA_PARSE_Dn
      JSR         EA_PARSE_REGISTER
      MOVE.W      #'D',(A0)+
      MOVE.W      D4,(A0)+
      BSR

EA_PARSE_An
      JSR         EA_PARSE_REGISTER
      MOVE.W      #'A',(A0)+
      MOVE.W      D4,(A0)+
      BSR

EA_PARSE_INDIRECT_An
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D4,(A0)+
      MOVE.W      #')',(A0)+
      BSR

EA_PARSE_INDIRECT_INCREMENT_An
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D4,(A0)+
      MOVE.W      #')',(A0)+
      MOVE.W      #'+',(A0)+
      BSR

EA_PARSE_INDIRECT_DECREMENT_An
      MOVE.W      #'-',(A0)+
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D4,(A0)+
      MOVE.W      #')',(A0)+
      BSR

EA_PARSE_REGISTER                   ;ConveBSR a register number to decimal and stores to D4  

      CMP.W       D3,%000
      MOVE.W      #0,D4

      CMP.W       D3,%001
      MOVE.W      #1,D4

      CMP.W       D3,%010
      MOVE.W      #2,D4

      CMP.W       D3,%011
      MOVE.W      #3,D4

      CMP.W       D3,%100
      MOVE.W      #4,D4

      CMP.W       D3,%101
      MOVE.W      #5,D4

      CMP.W       D3,%110
      MOVE.W      #6,D4

      CMP.W       D3,%111
      MOVE.W      #7,D4

      BSR

EA_PARSE_MODE                       ;Finds correct function to parse the EA Mode 
      CMP.W       D2,%000
      JSR EA_PARSE_An

      CMP.W       D2,%001
      JSR EA_PARSE_Dn

      CMP.W       D2,%010
      JSR EA_PARSE_INDIRECT_An

      CMP.W       D2,%011
      JSR EA_PARSE_INDIRECT_INCREMENT_An

      CMP.W       D2,%100
      JSR EA_PARSE_INDIRECT_DECREMENT_An


      BSR

ERROR
      *TODO: handle illegal inputs

      
