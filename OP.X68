*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
            LEA     cur_address,A5   *Load start address
            LEA     test_end,A6     *Load end address
        
loop        BSR     getdata         *Gets the data at add
            ADDQ.W  #byte,A5        *Incrementing the pointer one word
            CMPA.W  A6,A5           *Seeing if we're at end of the search area
            BGT     end_search      *go to end if we leave search area
            BRA     loop            *else go back to the beginning of the loop
        

getdata     MOVE.W  (A5),D0         *Gets the data of where the pointer is at
            BSR     output          *Outputs the data
            RTS                     *Returns to caller

output      MOVE.W  D0,D2           *Moves data to D2
            CLR.W   D0              *Clears D0
*prints address
            MOVE.W  D2,-(sp)        *Saves D2
            MOVE.W  A5,D2           *Moves current address to D2
            BSR     n2ascii         *prints current address
            MOVE.W  (sp)+,D2        *Loads D2
            MOVE.B  space,D1        *Loads ascii space in D1
*prints word 'DATA '
            MOVE.B  #6,D0           *Sets up trap
            TRAP    #15
            LEA     datastring,A1   *Loads datastring for printing
            MOVE.B  #14,D0          *Sets up Trap
            TRAP    #15
*prints the data
            BSR     n2ascii         *Prints out the data
            LEA     newline,A1      *Sets up trap for new line
            MOVE.B  #14,D0
            TRAP    #15
            RTS
*********************************************
*Takes the word hex in D2 and prints it to screen*
*********************************************

n2ascii     MOVE.B  #12,D4          *Sets up D4 as counter.
n2ascii2    MOVE.W  D2,D3           *Moves to D3 to work on there 
            LSR.W   D4,D3           
            ANDI.W  #$000F,D3       *Masks to check last nibble
            CMP.B   #$0,D3          *Chekcs if D3 is equal to 0
            BEQ     print0
            CMP.B   #$1,D3          *Chekcs if D3 is equal to 1
            BEQ     print1
            CMP.B   #$2,D3          *Chekcs if D3 is equal to 2
            BEQ     print2
            CMP.B   #$3,D3          *Chekcs if D3 is equal to 3
            BEQ     print3
            CMP.B   #$4,D3          *Chekcs if D3 is equal to 4
            BEQ     print4
            CMP.B   #$5,D3          *Chekcs if D3 is equal to 5
            BEQ     print5
            CMP.B   #$6,D3          *Chekcs if D3 is equal to 6
            BEQ     print6
            CMP.B   #$7,D3          *Chekcs if D3 is equal to 7
            BEQ     print7
            CMP.B   #$8,D3          *Chekcs if D3 is equal to 8
            BEQ     print8
            CMP.B   #$9,D3          *Chekcs if D3 is equal to 9
            BEQ     print9
            CMP.B   #$A,D3          *Chekcs if D3 is equal to A
            BEQ     printA
            CMP.B   #$B,D3          *Chekcs if D3 is equal to B
            BEQ     printB
            CMP.B   #$C,D3          *Chekcs if D3 is equal to C
            BEQ     printC
            CMP.B   #$D,D3          *Chekcs if D3 is equal to D
            BEQ     printD
            CMP.B   #$E,D3          *Chekcs if D3 is equal to E
            BEQ     printE
            CMP.B   #$F,D3          *Checks if D3 is equal to F
            BEQ     printF
n2acheck    SUB.B   #4,D4           *Decrements our counter
            CMP.B   #0,D4           *Checks if counter reached 0
            BGE     n2ascii2        *Returns to top of loop to continue        
            RTS                     *Else return to caller

print0      CLR.L   D1              *Clears D1
            MOVE.B  #$30,D1         *Sets D1 as ascii 0
            BRA     printchar       *prints the character
print1      CLR.L   D1              *Clears D1
            MOVE.B  #$31,D1         *Sets D1 as ascii 1
            BRA     printchar       *prints the character
print2      CLR.L   D1              *Clears D1
            MOVE.B  #$32,D1         *Sets D1 as ascii 2
            BRA     printchar       *prints the character
print3      CLR.L   D1              *Clears D1
            MOVE.B  #$33,D1         *Sets D1 as ascii 3
            BRA     printchar       *prints the character
print4      CLR.L   D1              *Clears D1
            MOVE.B  #$34,D1         *Sets D1 as ascii 4
            BRA     printchar       *prints the character
print5      CLR.L   D1              *Clears D1
            MOVE.B  #$35,D1         *Sets D1 as ascii 5
            BRA     printchar       *prints the character
print6      CLR.L   D1              *Clears D1
            MOVE.B  #$36,D1         *Sets D1 as ascii 6
            BRA     printchar       *prints the character
print7      CLR.L   D1              *Clears D1
            MOVE.B  #$37,D1         *Sets D1 as ascii 7
            BRA     printchar       *prints the character
print8      CLR.L   D1              *Clears D1
            MOVE.B  #$38,D1         *Sets D1 as ascii 8
            BRA     printchar       *prints the character
print9      CLR.L   D1              *Clears D1
            MOVE.B  #$39,D1         *Sets D1 as ascii 9
            BRA     printchar       *prints the character
printA      CLR.L   D1              *Clears D1
            MOVE.B  #$41,D1         *Sets D1 as ascii A
            BRA     printchar       *prints the character
printB      CLR.L   D1              *Clears D1
            MOVE.B  #$42,D1         *Sets D1 as ascii B
            BRA     printchar       *prints the character
printC      CLR.L   D1              *Clears D1
            MOVE.B  #$43,D1         *Sets D1 as ascii C
            BRA     printchar       *prints the character
printD      CLR.L   D1              *Clears D1
            MOVE.B  #$44,D1         *Sets D1 as ascii D
            BRA     printchar       *prints the character
printE      CLR.L   D1              *Clears D1
            MOVE.B  #$45,D1         *Sets D1 as ascii E
            BRA     printchar       *prints the character         
printF      CLR.L   D1              *Clears D1
            MOVE.B  #$46,D1         *Sets D1 as ascii F
            BRA     printchar       *prints the character
printchar   MOVE.B  #6,D0           *Sets up Trap
            TRAP    #15
            BRA     n2acheck        *returns to n2ascii
            

end_search    

    SIMHALT             ; halt simulator

* Put variables and constants here

space       DC.B    $20         *space
CR          EQU     $0D         *Carriage return
LF          EQU     $0A         *Line Feed
newline     DC.B    CR,LF,0     *New Line
byte        EQU     2           *How much to move the search address.
                                *2 bytes because we're searching for a word
cur_address EQU     $00001000   *Start of search
test_end    EQU     $00001100   *End of search
mydata      REG     D0-D7/A0-A6  *Used for pushing registers to stack
datastring  DC.B    'DATA ',0   *Data string

nop_code    EQU     $4E71


    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
