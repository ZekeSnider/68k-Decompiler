*--------------------------------*
*     Written By: Zeke Snider    *
*     CSS 422                    *
*     Fall 2014                  *
*--------------------------------*


*D0 is assumed to be input line
*Assuming D2 is Addressing Mode
*Assuming D3 is Register
*D4 stores register as decimal number
*D7 is used to store return values

*Input: D0 (Input Line)
EA_NEG                              ;Parsing EA for NEG function

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.L       %001,D2           ;Address register direct is not a valid input for NEG
      BRA         ERROR

      CMP.L       %111,D2           ;immediate data is not a valid input for NEG
      CMP.L       %100,D3
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;Calling parse mode function to write data to the stack

      RTS                           ;Returning to source


*D0 is assumed to be input line
*D1 is assumed to be input for opmode type
*D7 is used to store the return value from the BitMasks
*Assuming D2 is EA Addressing Mode
*Assuming D3 is EA Register
*D4 stores register as decimal number
*D5 stores register

*Input: D0 (input Line)
*Input: D1 (OPMOde type (1 or 2))
EA_OR                              ;Parsing EA for OR function

      BSR         BitMask6to8       ;isolating register number
      MOVE.L      D7,D5             ;moving return value to D5

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3




      BSR         EA_PARSE_MODE     ;Calling parse mode function to write data to the stack

      RTS                           ;Returning to source

*Called if the EA address field is a source operand
EA_OR_SOURCE
      CMP.L       %001,D2           ;Address register direct is not a valid input for EA Source
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;outputing the source EA

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      MOVE.L      D5,D3             ;Moving register number to D3
      BSR         EA_PARSE_Dn       ;Outputting register

      RTS

*Called if the EA address field is a destinaton operand
EA_OR_DESTINATION
      CMP.L       %000,D2           ;Data register direct is not a valid input for EA Source
      BRA         ERROR

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA Source
      BRA         ERROR

      MOVE.L      D3,D6             ;backing up EA register to D6
      MOVE.L      D5,D3             ;Moving register number to D3
      BSR         EA_PARSE_Dn       ;Outputting register

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      MOVE.L      D6,D3             ;Moving EA register back
      BSR         EA_PARSE_MODE     ;outputing the destination EA


      RTS


*Input: D0 (Input Line)
*Input: D1 (immediate data source)
EA_ORI                              ;Parsing EA for ORI function

      BSR         EA_PARSE_DISPLAY_IMMEDIATE_DATA  ;displays immediate data

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.L       %001,D2           ;Address register direct is not a valid input for NEG
      BRA         ERROR

      CMP.L       %111,D2           ;immediate data is not a valid input for ORI
      CMP.L       %100,D3
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;Calling parse mode function to write data to the stack

      RTS                           ;Returning to source


*Input: D0 (input Line)
*Input: D1 (OPMOde type (1 or 2))
EA_AND                              ;Parsing EA for AND function

      BSR         BitMask9to11      ;isolating register number
      MOVE.L      D7,D5             ;moving return value to D5

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3




      BSR         EA_PARSE_MODE     ;Calling parse mode function to write data to the stack

      RTS                           ;Returning to source

*Called if the EA address field is a source operand
EA_AND_SOURCE

      BSR         EA_PARSE_MODE     ;outputing the source EA

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      MOVE.L      D5,D7             ;Moving register number to D7
      BSR         EA_PARSE_Dn       ;Outputting register

      RTS

*Called if the EA address field is a destinaton operand
EA_AND_DESTINATION
      CMP.L       %000,D2           ;Data register direct is not a valid input for EA destinaton
      BRA         ERROR

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA destinaton
      BRA         ERROR

      MOVE.L      D3,D6             ;backing up EA register to D6
      MOVE.L      D5,D7             ;Moving register number to D3
      BSR         EA_PARSE_Dn       ;Outputting register

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      MOVE.L      D6,D7             ;Moving EA register back
      BSR         EA_PARSE_MODE     ;outputing the destination EA


      RTS

EA_ANDI                             ;Parsing EA for ANDI function

      BSR         BitMask9to11      ;isolating register number
      MOVE.L      D7,D5             ;moving return value to D5

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_MODE     ;outputting EA source           

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      MOVE.L      D5,D7
      BSR         EA_PARSE_An       ;outputting Address register destination

      RTS                           ;Returning to source


*Finds correct function to parse the EA Mode 
*Input: D2
EA_PARSE_MODE                       
      CMP.W       D2,%000
      BSR         EA_PARSE_An

      CMP.W       D2,%001
      BSR         EA_PARSE_Dn

      CMP.W       D2,%010
      BSR         EA_PARSE_INDIRECT_An

      CMP.W       D2,%011
      BSR         EA_PARSE_INDIRECT_INCREMENT_An

      CMP.W       D2,%100
      BSR         EA_PARSE_INDIRECT_DECREMENT_An

      RTS


*These functions are called when the EA Mode matches.
*They store the human ouput code to the A0 register, then increment it.
*Then return to where they were called from.

*Input: D7 (Register Address number)
*Output: A0
EA_PARSE_Dn
      BSR         EA_PARSE_REGISTER
      MOVE.W      #'D',(A0)+
      MOVE.W      D7,(A0)+
      RTS

EA_PARSE_An
      BSR         EA_PARSE_REGISTER
      MOVE.W      #'A',(A0)+
      MOVE.W      D7,(A0)+
      RTS

EA_PARSE_INDIRECT_An
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.W      #')',(A0)+
      RTS

EA_PARSE_INDIRECT_INCREMENT_An
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.W      #')',(A0)+
      MOVE.W      #'+',(A0)+
      RTS

EA_PARSE_INDIRECT_DECREMENT_An
      MOVE.W      #'-',(A0)+
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.W      #')',(A0)+
      RTS

EA_PARSE_IMMEDIATE_DATA

EA_PARSE_ABSOLUTE_LONG_ADDRESS

EA_PARSE_ABSOLUTE_WORD_ADDRESS

EA_PARSE_DISPLAY_IMMEDIATE_DATA

*Converts a register number to decimal and stores to D7 
*Input:  D3
*Output: D7 
EA_PARSE_REGISTER                   

      CMP.W       D3,%000
      MOVE.W      #0,D7

      CMP.W       D3,%001
      MOVE.W      #1,D7

      CMP.W       D3,%010
      MOVE.W      #2,D7

      CMP.W       D3,%011
      MOVE.W      #3,D7

      CMP.W       D3,%100
      MOVE.W      #4,D7

      CMP.W       D3,%101
      MOVE.W      #5,D7

      CMP.W       D3,%110
      MOVE.W      #6,D7

      CMP.W       D3,%111
      MOVE.W      #7,D7

      RTS



ERROR
      *TODO: handle illegal inputs

      
