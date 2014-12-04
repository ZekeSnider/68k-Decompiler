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
      BEQ         ERROR

      CMP.L       %111,D2           ;immediate data is not a valid input for NEG
      CMP.L       %100,D3
      BEQ         ERROR

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

      CMP.B       #1,D1             ;if the OPMode is type 1, the EA is the source
      BEQ         EA_OR_SOURCE      

      CMP.B       #2,D1             ;if the OPMode is type 2, the EA is the destination
      BEQ         EA_OR_SOURCE

      MOVE.B      #0,(A0)+          ;Terminating character

      RTS                           ;Returning to source

*Called if the EA address field is a source operand
EA_OR_SOURCE
      CMP.L       %001,D2           ;Address register direct is not a valid input for EA Source
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;outputing the source EA

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      MOVE.L      D5,D3             ;Moving register number to D3
      BSR         EA_PARSE_Dn       ;Outputting register

      RTS

*Called if the EA address field is a destinaton operand
EA_OR_DESTINATION
      CMP.L       %000,D2           ;Data register direct is not a valid input for EA Source
      BEQ         ERROR

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA Source
      BEQ         ERROR

      MOVE.L      D3,D6             ;backing up EA register to D6
      MOVE.L      D5,D3             ;Moving register number to D3
      BSR         EA_PARSE_Dn       ;Outputting register

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      MOVE.L      D6,D3             ;Moving EA register back
      BSR         EA_PARSE_MODE     ;outputing the destination EA


      RTS


*Input: D0 (Input Line)
*Input: D1 (immediate data source)
EA_ORI                              ;Parsing EA for ORI function

      BSR         EA_PARSE_IMMEDIATE_DATA  ;displays immediate data

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_IMMEDIATE_DATA  ;parsing immediate data

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      CMP.L       %001,D2           ;Address register direct is not a valid input for ORI
      BEQ         ERROR

      CMP.L       %111,D2           ;immediate data is not a valid input for ORI
      CMP.L       %100,D3
      BEQ         ERROR

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

      CMP.B       #1,D1             ;if the OPMode is type 1, the EA is the source
      BEQ         EA_AND_SOURCE      

      CMP.B       #2,D1             ;if the OPMode is type 2, the EA is the destination
      BEQ         EA_AND_SOURCE

      MOVE.B      #0,(A0)+          ;Terminating character

      RTS                           ;Returning to source

*Called if the EA address field is a source operand
EA_AND_SOURCE

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA source
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;outputing the source EA

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      MOVE.L      D5,D7             ;Moving register number to D7
      BSR         EA_PARSE_Dn       ;Outputting register

      RTS

*Called if the EA address field is a destinaton operand
EA_AND_DESTINATION
      CMP.L       %000,D2           ;Data register direct is not a valid input for EA destinaton
      BEQ         ERROR

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA destinaton
      BEQ         ERROR

      MOVE.L      D3,D6             ;backing up EA register to D6
      MOVE.L      D5,D7             ;Moving register number to D3
      BSR         EA_PARSE_Dn       ;Outputting register

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      MOVE.L      D6,D7             ;Moving EA register back
      BSR         EA_PARSE_MODE     ;outputing the destination EA


      RTS

EA_ANDI                             ;Parsing EA for ANDI function

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_IMMEDIATE_DATA          

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA destinaton
      BEQ         ERROR

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

      CMP.B       #1,D1             ;if the OPMode is type 1, the EA is the source
      BEQ         EA_AND_SOURCE      

      CMP.B       #2,D1             ;if the OPMode is type 2, the EA is the destination
      BEQ         EA_AND_SOURCE

      MOVE.B      #0,(A0)+          ;Terminating character

      RTS                           ;Returning to source

*Called if the EA address field is a source operand
EA_SUB_SOURCE

      CMP.L       %000,D2           ;Address register direct is not a valid input for EA source
      CMP.L       #1,D4             ;if it is a byte-sized operation
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;outputing the source EA

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      MOVE.L      D5,D7             ;Moving register number to D7
      BSR         EA_PARSE_Dn       ;Outputting register

      RTS

*Called if the EA address field is a destinaton operand
EA_SUB_DESTINATION
      CMP.L       %000,D2           ;Data register direct is not a valid input for EA destinaton
      BEQ         ERROR

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA destinaton
      BEQ         ERROR

      MOVE.L      D3,D6             ;backing up EA register to D6
      MOVE.L      D5,D7             ;Moving register number to D3
      BSR         EA_PARSE_Dn       ;Outputting register

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

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

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

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

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      BSR         BitMask6to8       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask9to11       ;isloating destination address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %001,D2           ;Address register direct is not a valid destination mode
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the destination     

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_MOVEA                            ;Parsing EA for MOVEA function

      BSR         BitMask3to5       ;isolating source address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

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

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

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

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      CMP.L       %001,D2           ;Address register direct is not a valid input for EA destinaton
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;outputting Address register destination

      RTS                           ;Returning to source


*Input: D0 (input Line)
EA_MULS                             ;Parsing EA for MULS function

      BSR         BitMask3to5       ;isolating source address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %001,D2           ;Address Register direct is not a valid EA Mode for DIVS
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

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
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+

      BSR         BitMask9to11      ;isloating destination address register

      MOVE.L      D7,D3             ;Moving return value to D3
      BSR         EA_PARSE_Dn       ;parsing data register direct for the destination     

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_LS_REGISTER                      ;Parsing EA for LSR/LSL function for register shifts

      BSR         BitMask5to5
      MOVE.L      D7,D5             ;storing i/r value in D5

      BSR         BitMask9to11      ;isloating source EA source register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_REGISTER ;parsing the count/register field
      MOVE.L      D7,D5             ;moving result to D5

      CMP.W       %1,D5             ;if the i/r value is 1 display the data register
      MOVE.B      #'D',(A0)+

      CMP.W       %0,D5             ;if the i/r value is 0 display immediate data
      MOVE.B      #'#',(A0)+

      MOVE.B      D5,(A0)+          ;pushing the register number or immediate data to the stack

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+
 
      BSR         BitMask0to2       ;isloating source destination register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_Dn       ;displaying the destination data register

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_LS_MEMORY                        ;Parsing EA for LSR/LSL function for memory shifts

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %000,D2           ;Data Register direct is not a valid EA mode
      BEQ         ERROR

      CMP.W       %001,D2           ;Address Register direct is not a valid EA Mode
      BEQ         ERROR

      CMP.W       %111,D2           ;Immediate Data
      CMP.W       %010,D3
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_AS_REGISTER                      ;Parsing EA for ASR/ASL function for register shifts

      BSR         BitMask5to5
      MOVE.L      D7,D5             ;storing i/r value in D5

      BSR         BitMask9to11      ;isloating source EA source register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_REGISTER ;parsing the count/register field
      MOVE.L      D7,D5             ;moving result to D5

      CMP.W       %1,D5             ;if the i/r value is 1 display the data register
      MOVE.B      #'D',(A0)+

      CMP.W       %0,D5             ;if the i/r value is 0 display immediate data
      MOVE.B      #'#',(A0)+

      MOVE.B      D5,(A0)+          ;pushing the register number or immediate data to the stack

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+
 
      BSR         BitMask0to2       ;isloating source destination register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_Dn       ;displaying the destination data register

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_AS_MEMORY                        ;Parsing EA for ASR/ASL function for memory shifts

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %000,D2           ;Data Register direct is not a valid EA mode
      BEQ         ERROR

      CMP.W       %001,D2           ;Address Register direct is not a valid EA Mode
      BEQ         ERROR

      CMP.W       %111,D2           ;Immediate Data
      CMP.W       %010,D3
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      RTS                           ;Returning to source


*Input: D0 (input Line)
EA_RO_REGISTER                      ;Parsing EA for ROR/ROL function for register shifts

      BSR         BitMask5to5
      MOVE.L      D7,D5             ;storing i/r value in D5

      BSR         BitMask9to11      ;isloating source EA source register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_REGISTER ;parsing the count/register field
      MOVE.L      D7,D5             ;moving result to D5

      CMP.W       %1,D5             ;if the i/r value is 1 display the data register
      MOVE.B      #'D',(A0)+

      CMP.W       %0,D5             ;if the i/r value is 0 display immediate data
      MOVE.B      #'#',(A0)+

      MOVE.W      D5,(A0)+          ;pushing the register number or immediate data to the stack

      MOVE.B      #',',(A0)+        ;pushing ", " to the stack.
      MOVE.B      #' ',(A0)+
 
      BSR         BitMask0to2       ;isloating source destination register
      MOVE.L      D7,D3             ;Moving return value to D3

      BSR         EA_PARSE_Dn       ;displaying the destination data register

      RTS                           ;Returning to source

*Input: D0 (input Line)
EA_RO_MEMORY                        ;Parsing EA for ROR/ROL function for memory shifts

      BSR         BitMask3to5       ;isolating destination address mode
      MOVE.L      D7,D2             ;moving return value to D2

      BSR         BitMask0to2       ;isloating source address register
      MOVE.L      D7,D3             ;Moving return value to D3

      CMP.W       %000,D2           ;Data Register direct is not a valid EA mode
      BEQ         ERROR

      CMP.W       %001,D2           ;Address Register direct is not a valid EA Mode
      BEQ         ERROR

      CMP.W       %111,D2           ;Immediate Data
      CMP.W       %010,D3
      BEQ         ERROR

      BSR         EA_PARSE_MODE     ;parsing mode and register for the source   

      RTS                           ;Returning to source


*Finds correct function to parse the EA Mode 
*Input: D2 (EA Mode)
*Input: D3 (EA Register Number)
EA_PARSE_MODE                       
      CMP.W       %000,D2
      BEQ         EA_PARSE_An

      CMP.W       %001,D2
      BEQ         EA_PARSE_Dn

      CMP.W       %010,D2
      BEQ         EA_PARSE_INDIRECT_An

      CMP.W       %011,D2
      BEQ         EA_PARSE_INDIRECT_INCREMENT_An

      CMP.W       %100,D2
      BEQ         EA_PARSE_INDIRECT_DECREMENT_An

      CMP.W       %111,D2
      BEQ         EA_ADDITIONAL_DATA

      RTS

EA_ADDITIONAL_DATA
      CMP.W       %000,D3
      BEQ         EA_PARSE_ABSOLUTE_WORD_ADDRESS

      CMP.W       %001,D3
      BEQ         EA_PARSE_ABSOLUTE_LONG_ADDRESS

      CMP.W       %100,D3
      BEQ         EA_PARSE_IMMEDIATE_DATA

      RTS

*These functions are called when the EA Mode matches.
*They store the human ouput code to the A0 register, then increment it.
*Then return to where they were called from.


*Input: D3 (Register Address number)
*Uses:  D7
*Output: A0
EA_PARSE_Dn
      BSR         EA_PARSE_REGISTER
      MOVE.B      #'D',(A0)+
      MOVE.W      D7,(A0)+
      RTS

EA_PARSE_An
      BSR         EA_PARSE_REGISTER
      MOVE.B      #'A',(A0)+
      MOVE.W      D7,(A0)+
      RTS

EA_PARSE_INDIRECT_An
      BSR         EA_PARSE_REGISTER
      MOVE.B      #'(',(A0)+
      MOVE.B      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.B      #')',(A0)+
      RTS

EA_PARSE_INDIRECT_INCREMENT_An
      BSR         EA_PARSE_REGISTER
      MOVE.B      #'(',(A0)+
      MOVE.B      #'A',(A0)+
      MOVE.W      D7,(A0)+
      MOVE.B      #')',(A0)+
      MOVE.B      #'+',(A0)+
      RTS

EA_PARSE_INDIRECT_DECREMENT_An
      BSR         EA_PARSE_REGISTER
      MOVE.B      #'-',(A0)+
      MOVE.B      #'(',(A0)+
      MOVE.B      #'A',(A0)+
      MOVE.B      D7,(A0)+
      MOVE.B      #')',(A0)+
      RTS

EA_PARSE_IMMEDIATE_DATA
      MOVE.B     #'#',(A0)+
      BSR        IO_GET_WORD
      RTS

EA_PARSE_ABSOLUTE_LONG_ADDRESS
      MOVE.B     #'$',(A0)+
      BSR        IO_GET_WORD
      MOVE.B     #'.',(A0)+
      MOVE.B     #'L',(A0)+
      RTS
      
EA_PARSE_ABSOLUTE_WORD_ADDRESS
      MOVE.B     #'$',(A0)+
      BSR        IO_GET_WORD
      MOVE.B     #'.',(A0)+
      MOVE.B     #'W',(A0)+
      RTS


IO_GET_WORD
      MOVE.W  (A5),D0         *Gets the data of where the pointer is at
      ADDQ.W  #byte,A5        *Incrementing the pointer one word
      MOVE.W  D0,D2           *Moves data to D2 to use
      BSR     n2asciiSTACK    *Branching to n2asciiSTACK to push the word to the stack
      RTS


*Modified version of the n2ascii function that pushes to the A0 stack instead of outputting to console
n2asciiSTACK      MOVE.B  #12,D4          *Sets up D4 as counter.
n2asciiSTACK2     MOVE.W  D2,D3           *Moves to D3 to work on there 
                  LSR.W   D4,D3           
                  ANDI.W  #$000F,D3       *Masks to check last nibble
                  CMP.B   #$0,D3          *checks if D3 is equal to 0
                  BEQ     push0
                  CMP.B   #$1,D3          *checks if D3 is equal to 1
                  BEQ     push1
                  CMP.B   #$2,D3          *checks if D3 is equal to 2
                  BEQ     push2
                  CMP.B   #$3,D3          *checks if D3 is equal to 3
                  BEQ     push3
                  CMP.B   #$4,D3          *checks if D3 is equal to 4
                  BEQ     push4
                  CMP.B   #$5,D3          *checks if D3 is equal to 5
                  BEQ     push5
                  CMP.B   #$6,D3          *checks if D3 is equal to 6
                  BEQ     push6
                  CMP.B   #$7,D3          *checks if D3 is equal to 7
                  BEQ     push7
                  CMP.B   #$8,D3          *checks if D3 is equal to 8
                  BEQ     push8
                  CMP.B   #$9,D3          *checks if D3 is equal to 9
                  BEQ     push9
                  CMP.B   #$A,D3          *checks if D3 is equal to A
                  BEQ     pushA
                  CMP.B   #$B,D3          *checks if D3 is equal to B
                  BEQ     pushB
                  CMP.B   #$C,D3          *checks if D3 is equal to C
                  BEQ     pushC
                  CMP.B   #$D,D3          *checks if D3 is equal to D
                  BEQ     pushD
                  CMP.B   #$E,D3          *checks if D3 is equal to E
                  BEQ     pushE
                  CMP.B   #$F,D3          *Checks if D3 is equal to F
                  BEQ     pushF
n2acheckSTACK     SUB.B   #4,D4           *Decrements our counter
                  CMP.B   #0,D4           *Checks if counter reached 0
                  BGE     n2asciiSTACK2   *Returns to top of loop to continue        
                  RTS                     *Else return to caller

push0       MOVE.B  #'0',(A0)+
            RTS
push1       MOVE.B  #'1',(A0)+
            RTS
push2       MOVE.B  #'2',(A0)+
            RTS
push3       MOVE.B  #'3',(A0)+
            RTS
push4       MOVE.B  #'4',(A0)+
            RTS
push5       MOVE.B  #'5',(A0)+
            RTS
push6       MOVE.B  #'6',(A0)+
            RTS
push7       MOVE.B  #'7',(A0)+
            RTS
push8       MOVE.B  #'8',(A0)+
            RTS
push9       MOVE.B  #'9',(A0)+
            RTS
pushA       MOVE.B  #'A',(A0)+
            RTS
pushB       MOVE.B  #'B',(A0)+
            RTS
pushC       MOVE.B  #'C',(A0)+
            RTS
pushD       MOVE.B  #'D',(A0)+
            RTS
pushE       MOVE.B  #'E',(A0)+
            RTS         
pushF       MOVE.B  #'F',(A0)+
            RTS

*Converts a register number to decimal and stores to D7 
*Input:  D3 (Register Number)
*Output: D7 
EA_PARSE_REGISTER                   

      CMP.W       %000,D3
      MOVE.W      #0,D7

      CMP.W       %001,D3
      MOVE.W      #1,D7

      CMP.W       %010,D3
      MOVE.W      #2,D7

      CMP.W       %011,D3
      MOVE.W      #3,D7

      CMP.W       %100,D3
      MOVE.W      #4,D7

      CMP.W       %101,D3
      MOVE.W      #5,D7

      CMP.W       %110,D3
      MOVE.W      #6,D7

      CMP.W       %111,D3
      MOVE.W      #7,D7

      RTS

IO_PRINT_OUTPUT
      LEA       OUPUT_START,A0
      MOVE.B    #1,D0
      TRAP      #15

ERROR
      *TODO: handle illegal inputs

SIMHALT

OUTPUT_START EQU     $000A000
byte         EQU     2           *How much to move the search address.
      
