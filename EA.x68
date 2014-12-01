*--------------------------------*
*     Written By: Zeke Snider    *
*     CSS 422                    *
*     Fall 2014                  *
*--------------------------------*


*D0 is assumed to be input line
*Assuming D2 is Addressing Mode
*Assuming D3 is Register
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

      MOVE.B      #0,(A0)+          ;Terminating character

      RTS                           ;Returning to source


*D0 is assumed to be input line
*D1 is assumed to be input for opmode type
*D7 is used to store the return value from the BitMasks
*Assuming D2 is EA Addressing Mode
*Assuming D3 is EA Register
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

      CMP.B       D1,#1             ;if the OPMode is type 1, the EA is the source
      BSR         EA_OR_SOURCE      

      CMP.B       D1,#2             ;if the OPMode is type 2, the EA is the destination
      BSR         EA_OR_SOURCE

      MOVE.B      #0,(A0)+          ;Terminating character

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

      BSR         EA_PARSE_IMMEDIATE_DATA  ;parsing immediate data

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      CMP.L       %001,D2           ;Address register direct is not a valid input for ORI
      BRA         ERROR

      CMP.L       %111,D2           ;immediate data is not a valid input for ORI
      CMP.L       %100,D3
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;Calling parse mode function to write data to the stack

      MOVE.B      #0,(A0)+          ;Terminating character

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

      CMP.B       D1,#1             ;if the OPMode is type 1, the EA is the source
      BSR         EA_AND_SOURCE      

      CMP.B       D1,#2             ;if the OPMode is type 2, the EA is the destination
      BSR         EA_AND_SOURCE

      MOVE.B      #0,(A0)+          ;Terminating character

      RTS                           ;Returning to source

*Called if the EA address field is a source operand
EA_AND_SOURCE

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA source
      BRA         ERROR

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

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_IMMEDIATE_DATA          

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA destinaton
      BRA         ERROR

      MOVE.L      D5,D7
      BSR         EA_PARSE_MODE       ;outputting Address register destination

      RTS                           ;Returning to source

*Input: D0 (input Line)
*Input: D1 (OPMOde type (1 or 2))
*Input: D2 (Isbyte (0 or 1))
EA_SUB                              ;Parsing EA for AND function
      MOVE.L      D2,D4             ;moving isbyte variable to D4

      BSR         BitMask9to11      ;isolating register number
      MOVE.L      D7,D5             ;moving return value to D5

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.B       D1,#1             ;if the OPMode is type 1, the EA is the source
      BSR         EA_AND_SOURCE      

      CMP.B       D1,#2             ;if the OPMode is type 2, the EA is the destination
      BSR         EA_AND_SOURCE

      MOVE.B      #0,(A0)+          ;Terminating character

      RTS                           ;Returning to source

*Called if the EA address field is a source operand
EA_SUB_SOURCE

      CMP.L       %000,D2           ;Address register direct is not a valid input for EA source
      CMP.L       #1,D4             ;if it is a byte-sized operation
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;outputing the source EA

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      MOVE.L      D5,D7             ;Moving register number to D7
      BSR         EA_PARSE_Dn       ;Outputting register

      RTS

*Called if the EA address field is a destinaton operand
EA_SUB_DESTINATION
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

*Input: D0 (input Line)
*Input: D1 (Isbyte (0 or 1))
EA_SUBQ                             ;Parsing EA for SUBQ function

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_IMMEDIATE_DATA          

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      CMP.L       #1,D1             ;Address register direct is not a valid input for EA destinaton
      CMP.L       %001,D2           ;if it is a byte-operation
      BRA         ERROR
      
      MOVE.L      D5,D7
      BSR         EA_PARSE_MODE       ;outputting Address register destination

      RTS                           ;Returning to source


*Input: D0 (input Line)
EA_MOVE                             ;Parsing EA for MOVE function

      BSR         BitMask3to5       ;isolating source address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      BSR         BitMask6to8       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask9to11       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %001,D2           ;Address register direct is not a valid destination mode
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the destination     

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_MOVEA                            ;Parsing EA for MOVEA function

      BSR         BitMask3to5       ;isolating source address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      BSR         BitMask9to11      ;isloating destination address register

      MOVE.L      D7,D3             ;Moving return value to D3
      BSR         EA_PARSE_An       ;parsing address register direct for the destination     

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_CMP                             ;Parsing EA for CMP function

      BSR         BitMask3to5       ;isolating source address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      BSR         BitMask9to11      ;isloating destination address register

      MOVE.L      D7,D3             ;Moving return value to D3
      BSR         EA_PARSE_Dn       ;parsing data register direct for the destination     

      RTS                           ;Returning to source


EA_CMPI                             ;Parsing EA for CMPI function

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_IMMEDIATE_DATA          

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA destinaton
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;outputting Address register destination

      RTS                           ;Returning to source


*Input: D0 (input Line)
EA_MULS                             ;Parsing EA for MULS function

      BSR         BitMask3to5       ;isolating source address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %001,D2           ;Address Register direct is not a valid EA Mode for DIVS
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      BSR         BitMask9to11      ;isloating destination address register

      MOVE.L      D7,D3             ;Moving return value to D3
      BSR         EA_PARSE_Dn       ;parsing data register direct for the destination     

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_DIVS                             ;Parsing EA for DIVS function

      BSR         BitMask3to5       ;isolating source address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %001,D2           ;Address Register direct is not a valid EA Mode for DIVS
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      BSR         BitMask9to11      ;isloating destination address register

      MOVE.L      D7,D3             ;Moving return value to D3
      BSR         EA_PARSE_Dn       ;parsing data register direct for the destination     

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_LS                             ;Parsing EA for LSR/LSL function

      BSR         BitMask0to2       ;isloating source EA register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %001,D2           ;Address Register direct is not a valid EA Mode for DIVS
      BRA         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.W      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.W      #' ',(A0)+

      BSR         BitMask9to11      ;isloating destination address register

      MOVE.L      D7,D3             ;Moving return value to D3
      BSR         EA_PARSE_Dn       ;parsing data register direct for the destination     

      RTS                           ;Returning to source



*Finds correct function to parse the EA Mode 
*Input: D2 (EA Mode)
*Input: D3 (EA Register Number)
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

      CMP.W       D2,%111
      BSR         EA_ADDITIONAL_DATA

      RTS

EA_ADDITIONAL_DATA
      CMP.W       D3,%000
      BSR         EA_PARSE_ABSOLUTE_WORD_ADDRESS

      CMP.W       D3,%001
      BSR         EA_PARSE_ABSOLUTE_LONG_ADDRESS

      CMP.W       D3,%100
      BSR         EA_PARSE_IMMEDIATE_DATA

      RTS
x
*These functions are called when the EA Mode matches.
*They store the human ouput code to the A0 register, then increment it.
*Then return to where they were called from.


*Input: D3 (Register Address number)
*Uses:  D7
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
      BSR         EA_PARSE_REGISTER
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.W      #')',(A0)+
      RTS

EA_PARSE_INDIRECT_INCREMENT_An
      BSR         EA_PARSE_REGISTER
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.W      #')',(A0)+
      MOVE.W      #'+',(A0)+
      RTS

EA_PARSE_INDIRECT_DECREMENT_An
      BSR         EA_PARSE_REGISTER
      MOVE.W      #'-',(A0)+
      MOVE.W      #'(',(A0)+
      MOVE.W      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.W      #')',(A0)+
      RTS

EA_PARSE_IMMEDIATE_DATA
      MOVE.W     #'#',(A0)+
      BSR        IO_GET_WORD
      RTS

EA_PARSE_ABSOLUTE_LONG_ADDRESS
      MOVE.W     #'$',(A0)+
      BSR        IO_GET_WORD
      MOVE.W     #'.',(A0)+
      MOVE.W     #'L',(A0)+
      RTS
      
EA_PARSE_ABSOLUTE_WORD_ADDRESS
      MOVE.W     #'$',(A0)+
      BSR        IO_GET_WORD
      MOVE.W     #'.',(A0)+
      MOVE.W     #'W',(A0)+
      RTS


IO_GET_WORD
      MOVE.W  (A5),D0         *Gets the data of where the pointer is at
      BSR     getOP           *Gets the data at add
      ADDQ.W  #byte,A5        *Incrementing the pointer one word
      MOVE.W  D0,D2           *Moves data to D2 to use
      BSR     n2asciiSTACK    *Branching to n2asciiSTACK to push the word to the stack
      RTS


*Modified version of the n2ascii function that pushes to the A0 stack instead of outputting to console
n2asciiSTACK      MOVE.B  #12,D4          *Sets up D4 as counter.
n2asciiSTACK2     MOVE.W  D2,D3           *Moves to D3 to work on there 
                  LSR.W   D4,D3           
                  ANDI.W  #$000F,D3       *Masks to check last nibble
                  CMP.B   #$0,D3          *Chekcs if D3 is equal to 0
                  MOVE.W  #'0',(A0)+
                  CMP.B   #$1,D3          *Chekcs if D3 is equal to 1
                  MOVE.W  #'1',(A0)+
                  CMP.B   #$2,D3          *Chekcs if D3 is equal to 2
                  MOVE.W  #'2',(A0)+
                  CMP.B   #$3,D3          *Chekcs if D3 is equal to 3
                  MOVE.W  #'3',(A0)+
                  CMP.B   #$4,D3          *Chekcs if D3 is equal to 4
                  MOVE.W  #'4',(A0)+
                  CMP.B   #$5,D3          *Chekcs if D3 is equal to 5
                  MOVE.W  #'5',(A0)+
                  CMP.B   #$6,D3          *Chekcs if D3 is equal to 6
                  MOVE.W  #'6',(A0)+
                  CMP.B   #$7,D3          *Chekcs if D3 is equal to 7
                  MOVE.W  #'7',(A0)+
                  CMP.B   #$8,D3          *Chekcs if D3 is equal to 8
                  MOVE.W  #'8',(A0)+
                  CMP.B   #$9,D3          *Chekcs if D3 is equal to 9
                  MOVE.W  #'9',(A0)+
                  CMP.B   #$A,D3          *Chekcs if D3 is equal to A
                  MOVE.W  #'A',(A0)+
                  CMP.B   #$B,D3          *Chekcs if D3 is equal to B
                  MOVE.W  #'B',(A0)+
                  CMP.B   #$C,D3          *Chekcs if D3 is equal to C
                  MOVE.W  #'C',(A0)+
                  CMP.B   #$D,D3          *Chekcs if D3 is equal to D
                  MOVE.W  #'D',(A0)+
                  CMP.B   #$E,D3          *Chekcs if D3 is equal to E
                  MOVE.W  #'E',(A0)+
                  CMP.B   #$F,D3          *Checks if D3 is equal to F
                  MOVE.W  #'F',(A0)+
 n2acheckSTACK    SUB.B   #4,D4           *Decrements our counter
                  CMP.B   #0,D4           *Checks if counter reached 0
                  BGE     n2ascii2        *Returns to top of loop to continue        
                  RTS                     *Else return to caller


*Converts a register number to decimal and stores to D7 
*Input:  D3 (Register Number)
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

      
