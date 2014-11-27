*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
*KNOWN ISSUES*

*EOR doesn't increment the word for the immediate, so assumes the next word is a new command
*Since next word is usually small, the first two bytes are often $00, leading decompiler to
*think it's another EOR
* Put program code here
            NOP                     *Test NOP
            EOR     D0,D1           *Test EOR
            ORI.W   #13,D0          *Test ORI
            OR      D0,D0           *Test OR
            ADDA.L    A0,A0           *Test ADDA
            ADD     D0,D0           *Test ADD
            CLR.W   D0              *Clears D0
            LEA     cur_address,A5   *Load start address
            LEA     test_end,A6     *Load end address
        
loop        MOVE.W  (A5),D0         *Gets the data of where the pointer is at
            BSR     getOP           *Gets the data at add
            ADDQ.W  #byte,A5        *Incrementing the pointer one word
            CMPA.W  A6,A5           *Seeing if we're at end of the search area
            BGT     end_search      *go to end if we leave search area
            BRA     loop            *else go back to the beginning of the loop
            
getOP       MOVE.W  D0,D2           *Moves data to D2 to use
            CMP.W   #nop_code,D2     *Compares to NOP
            BEQ     isNOP           *Skips the return if it is NOP
            
            BSR     firstByte       *Masks to the first byte
            BRA     compare_ORI     *Compares the ORI op codes
endORI      BSR     compMask        *Masks D2 to make comparisons easier
            BRA     compare_EOR     *Compares the EOR op codes
endEOR      BRA     compare_OR      *Compares the OR op codes
endOR       BRA     compare_ADD     *Compares the ADD op codes
endADD
                                    *if we get here, the operation is unknown
            MOVE.W  D0,D2           *Restores D2 to default
            BSR     outaddress      *Data unknown, just print the address
            BSR     isData          *And then the data
endOP       RTS                     *Returns to caller

*Comparison subroutines, broken up by Operation
compare_ORI
            CMP.W   #ori_code,D2    *Compares to ORI
            BEQ     isORI
            BRA     endORI
            
compare_OR
            CMP.W   #orbDn_code,D2  *Compares to ORI.B -> Dn
            BEQ     isOR
            CMP.W   #orwDn_code,D2  *Compares to ORI.W -> Dn
            BEQ     isOR
            CMP.W   #orlDn_code,D2  *Compares to ORI.L -> Dn
            BEQ     isOR
            CMP.W   #orbEA_code,D2  *Compares to ORI.B -> EA
            BEQ     isOR
            CMP.W   #orwEA_code,D2  *Compares to ORI.W -> EA
            BEQ     isOR
            CMP.W   #orlEA_code,D2  *Compares to ORI.L -> EA
            BEQ     isOR
            BRA     endOR
            
compare_EOR
            CMP.W   #eorb_code,D2   *Compares to EOR.B
            BEQ     isEOR
            CMP.W   #eorw_code,D2   *Compares to EOR.W
            BEQ     isEOR
            CMP.W   #eorl_code,D2   *Compares to EOR.L
            BEQ     isEOR
            BRA     endEOR
            
compare_ADD
            CMP.W   #addbDn_code,D2 *Compares to ADD.B -> Dn
            BEQ     isADD
            CMP.W   #addwDn_code,D2 *Compares to ADD.W -> Dn
            BEQ     isADD
            CMP.W   #addlDn_code,D2 *Compares to ADD.L -> Dn
            BEQ     isADD
            CMP.W   #addbEA_code,D2 *Compares to ADD.B -> EA
            BEQ     isADD
            CMP.W   #addwEA_code,D2 *Compares to ADD.W -> EA
            BEQ     isADD
            CMP.W   #addlEA_code,D2 *Compares to ADD.L -> EA
            BEQ     isADD
            CMP.W   #addaw_code,D2  *Compares to ADDA.W
            BEQ     isADDA
            CMP.W   #addal_code,D2  *Compares to ADDA.L
            BEQ     isADDA
            BRA     endADD

isNOP       BSR     outaddress      *prints current address
            LEA     NOPstring,A1    *Loads NOPstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP            
isEOR       BSR     outaddress      *prints current address
            LEA     EORstring,A1    *Loads EORstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP            
isORI       BSR     outaddress      *prints current address
            LEA     ORIstring,A1    *Loads ORIstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isOR        BSR     outaddress      *prints current address
            LEA     ORstring,A1     *Loads ORstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isADD       BSR     outaddress      *prints current address
            LEA     ADDstring,A1     *Loads ADDstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isADDA      BSR     outaddress      *prints current address
            LEA     ADDAstring,A1   *Loads ADDstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
            
*Masks to make comparisons easier
compMask    MOVE.W  D0,D2           *Gets fresh copy of D0
            ANDI.W  #opMask,D2      *Masks D2 for rest of comparisons
            RTS
firstByte   ANDI.W  #BitMask15to8,D2   *Masks D2 for the first byte
            RTS
            
*prints address
outaddress  MOVE.W  D2,-(sp)        *Saves D2
            MOVE.W  A5,D2           *Moves current address to D2
            BSR     n2ascii         *prints current address
            MOVE.W  (sp)+,D2        *Loads D2
            MOVE.B  space,D1        *Loads ascii space in D1
            MOVE.B  #6,D0           *Sets up trap
            TRAP    #15
            RTS
            
*prints word 'DATA '            
isData      LEA     datastring,A1   *Loads datastring for printing
            MOVE.B  #14,D0          *Sets up Trap
            TRAP    #15
*prints the data
            BSR     n2ascii         *Prints out the data
            LEA     newline,A1      *Sets up trap for new line
            MOVE.B  #14,D0
            TRAP    #15
            RTS
**************************************************
*Takes the word hex in D2 and prints it to screen*
**************************************************

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
test_end    EQU     $00001030   *End of search
mydata      REG     D0-D7/A0-A6  *Used for pushing registers to stack
datastring  DC.B    'DATA ',0   *Data string
NOPstring   DC.B    'NOP',0     *NOP string
EORstring   DC.B    'EOR',0     *EOR string
ORIstring   DC.B    'ORI',0     *ORI string
ORstring    DC.B    'OR',0      *OR string
ADDstring   DC.B    'ADD',0     *ADD string
ADDAstring  DC.B    'ADDA',0     *ADDA string

nop_code    EQU     $4E71       *Hex for NOP
BitMask15to8 EQU     $FF00       *Mask for showing first two bytes, 0'ing last 2
opMask      EQU     $F1C0       *Masks word so first byte and OP mode are visible
                                *The rest of the word are 0's
eorb_code   EQU     %1011000100000000   *Binary of EOR.B, masked
eorw_code   EQU     %1011000101000000   *Binary of EOR.W, masked
eorl_code   EQU     %1011000110000000   *Binary of EOR.L, masked
ori_code    EQU     $0000               *Hex of first two bytes of ORI
                                        *last 2 bytes don't matter for compare
orbDn_code  EQU     %1000000000000000   *Binary of OR.B -> Dn
orwDn_code  EQU     %1000000001000000   *Binary of OR.W -> Dn
orlDn_code  EQU     %1000000010000000   *Binary of OR.L -> Dn
orbEA_code  EQU     %1000000100000000   *Binary of OR.B -> EA
orwEA_code  EQU     %1000000101000000   *Binary of OR.W -> EA
orlEA_code  EQU     %1000000110000000   *Binary of OR.L -> EA
addbDn_code EQU     %1101000000000000   *Binary of ADD.B -> Dn
addwDn_code EQU     %1101000001000000   *Binary of ADD.W -> Dn
addlDn_code EQU     %1101000010000000   *Binary of ADD.L -> Dn
addbEA_code EQU     %1101000100000000   *Binary of ADD.B -> EA
addwEA_code EQU     %1101000101000000   *Binary of ADD.W -> EA
addlEA_code EQU     %1101000110000000   *Binary of ADD.L -> EA
addaw_code  EQU     %1101000011000000   *Binary of ADDA.W
addal_code  EQU     %1101000111000000   *Binary of ADDA.L

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
