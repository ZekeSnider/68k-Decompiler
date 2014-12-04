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
            ADDA.L  A0,A0           *Test ADDA
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
            BRA     compare_NOP     *compares the NOP op code
endNOP      BRA     compare_RTS     *Compares the RTS op code
endRTS
            BSR     maskMulDivL     *Masks to compare to MULS.L and DIVS.L
            BRA     compare_MULSL   *Compares the MULS.L op code
endMULSL    BRA     compare_DIVSL   *Compares the DIVS.L op code
endDIVSL
            BSR     mask15to6       *Masks to compare BCLR
            BRA     compare_BCLRI   *Compare to BCLR with an immidiate
endBCLRI    BRA     compare_JSR     *Compare to JSR
endJSR
            BSR     mask15to7       *Masks to compare to MoveM
            BRA     compare_MOVEM   *Compares to MoveM
endMOVEM
            BSR     mask15to8       *Masks to the first byte
            BRA     compare_ORI     *Compares the ORI op codes
endORI      BRA     compare_CMPI    *Compares the CMPI op code
endCMPI     BRA     compare_Bcc     *Compares the Bcc op codes
endBcc
            BSR     compMask        *Masks D2 to make comparisons easier
            BRA     compare_EOR     *Compares the EOR op codes
endEOR      BRA     compare_OR      *Compares the OR op codes
endOR       BRA     compare_ADD     *Compares the ADD op codes
endADD      BRA     compare_MOVEA   *Compares the MOVEA op codes
endMOVEA    BRA     compare_SUB     *Compares the SUB op codes
endSUB      BRA     compare_SUBQ    *Compares the SUBQ op codes
endSUBQ     BRA     compare_MULSW   *Compares the MULS.W op code
endMULSW    BRA     compare_DIVSW   *Compares the DIVS.W op code
endDIVSW    BRA     compare_CMP     *Compares the CMP op codes
endCMP      BRA     compare_BCLR    *Compares the BCLR without immidate op code
endBCLR
            BSR     mask15to12      *Masks D2 to first 4 bits
            BRA     compare_MOVE    *Compares the MOVE op codes
endMOVE     BRA     compare_shift   *Compares LSL,LSR, ASL, and ASR
endshift
                                    *if we get here, the operation is unknown
            MOVE.W  D0,D2           *Restores D2 to default
            BSR     outaddress      *Data unknown, just print the address
            BSR     isData          *And then the data
endOP       RTS                     *Returns to caller

*Comparison subroutines, broken up by Operation
compare_NOP
            CMP.W   #nop_code,D2    *Compares to NOP
            BEQ     isNOP           *Skips the return if it is NOP
            BRA     endNOP

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

compare_MOVEM
            CMP.W   #movemr2m_code,D2 *Compares to MOVEM Register to memory
            BEQ     isMOVEM
            CMP.W   #movemm2r_code,D2 *Compares to MOVEM memory to register
            BEQ     isMOVEM
            BRA     endMOVEM

compare_MOVEA
            CMP.W   #moveaw_code,D2 *Compares to MOVEA word operation
            BEQ     isMOVEA
            CMP.W   #moveal_code,D2 *Compares to MOVEA long operation
            BEQ     isMOVEA
            BRA     endMOVEA

compare_MOVE
            CMP.W   #moveb_code,D2  *Compares to MOVE byte operation
            BEQ     isMOVE
            CMP.W   #movew_code,D2  *Compares to MOVE word operation
            BEQ     isMOVE
            CMP.W   #movel_code,D2  *Compares to MOVE long operation
            BEQ     isMOVE
            BRA     endMOVE

compare_SUB
            CMP.W   #subbDn_code,D2 *Compares to SUB.B -> Dn
            BEQ     isSUB
            CMP.W   #subwDn_code,D2 *Compares to SUB.W -> Dn
            BEQ     isSUB
            CMP.W   #sublDn_code,D2 *Compares to SUB.L -> Dn
            BEQ     isSUB
            CMP.W   #subbEA_code,D2 *Compares to SUB.B -> EA
            BEQ     isSUB
            CMP.W   #subwEA_code,D2 *Compares to SUB.W -> EA
            BEQ     isSUB
            CMP.W   #sublEA_code,D2 *Compares to SUB.L -> EA
            BEQ     isSUB
            BRA     endSUB

compare_SUBQ
            CMP.W   #subqb_code,D2   *Compares to SUBQ.B
            BEQ     isSUBQ
            CMP.W   #subqw_code,D2   *Compares to SUBQ.W
            BEQ     isSUBQ
            CMP.W   #subql_code,D2   *Compares to SUBQ.L
            BEQ     isSUBQ
            BRA     endSUBQ

compare_MULSL
            CMP.W   #mulsl_code,D2  *Compares to MULS.L
            BEQ     isMULS
            BRA     endMULSL

compare_DIVSL
            CMP.W   #divsl_code,D2  *Compares to DIVS.L
            BEQ     isDIVS
            BRA     endDIVSL
 
compare_MULSW
            CMP.W   #mulsw_code,D2  *Compares to MULS.W
            BEQ     isMULS
            BRA     endMULSW

compare_DIVSW
            CMP.W   #divsw_code,D2  *Compares to DIVS.W
            BEQ     isDIVS
            BRA     endDIVSW

compare_CMP
            CMP.W   #cmpb_code,D2   *Compares to CMP.B
            BEQ     isCMP
            CMP.W   #cmpw_code,D2   *Compares to CMP.W
            BEQ     isCMP
            CMP.W   #cmpl_code,D2   *Compares to CMP.L
            BEQ     isCMP
            BRA     endCMP

compare_CMPI
            CMP.W   #cmpi_code,D2   *Compares to CMPI
            BEQ     isCMPI
            BRA     endCMPI

compare_shift
            BSR     maskShift        *Masks to shift type and direction
            CMP.W   #lsr_code,D2    *Compares to LSR
            BEQ     isLSR
            CMP.W   #lsl_code,D2    *Compares to LSL
            BEQ     isLSL
            CMP.W   #asr_code,D2    *Compares to ASR
            BEQ     isASR
            CMP.W   #asl_code,D2    *Compares to ASL
            BEQ     isASL
            CMP.W   #ror_code,D2    *Compares to ROR
            BEQ     isROR
            CMP.W   #rol_code,D2    *Compares to ROL
            BEQ     isROL
            BSR     mask15to12      *Returns the 15to12 mask
            BRA     endshift

compare_BCLRI
            CMP.W   #bclri_code,D2  *Compares to BCLR with an immidiate
            BEQ     isBCLR
            BRA     endBCLRI

compare_BCLR
            CMP.W   #bclr_code,D2   *Compares to BCLR
            BEQ     isBCLR
            BRA     endBCLR

compare_Bcc
            CMP.W   #bcs_code,D2    *Compares to BCS
            BEQ     isBCS
            CMP.W   #bge_code,D2    *Compares to BGE
            BEQ     isBGE
            CMP.W   #blt_code,D2    *Compares to BLT
            BEQ     isBLT
            CMP.W   #bvc_code,D2    *Compares to BVC
            BEQ     isBVC
            CMP.W   #bra_code,D2    *Compares to BRA
            BEQ     isBRA
            BRA     endBcc

compare_JSR
            CMP.W   #jsr_code,D2    *Compares to JSR
            BEQ     isJSR
            BRA     endJSR

compare_RTS
            CMP.W   #rts_code,D2    *Compares to RTS
            BEQ     isRTS
            BRA     endRTS

*If compare is successful, we go to one of the isX
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
isMOVEM     BSR     outaddress      *prints current address
            LEA     MOVEMstring,A1  *Loads MOVEMstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isMOVEA     BSR     outaddress      *prints current address
            LEA     MOVEAstring,A1  *Loads MOVEAstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isMOVE      BSR     outaddress      *prints current address
            LEA     MOVEstring,A1   *Loads MOVEstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isSUB       BSR     outaddress      *prints current address
            LEA     SUBstring,A1    *Loads SUBstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isSUBQ      BSR     outaddress      *prints current address
            LEA     SUBQstring,A1   *Loads SUBQstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isMULS      BSR     outaddress      *prints current address
            LEA     MULSstring,A1   *Loads MULSstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isDIVS      BSR     outaddress      *prints current address
            LEA     DIVSstring,A1   *Loads DIVSstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isCMP       BSR     outaddress      *prints current address
            LEA     CMPstring,A1    *Loads CMPstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isCMPI      BSR     outaddress      *prints current address
            LEA     CMPIstring,A1   *Loads CMPIstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isLSR       BSR     outaddress      *prints current address
            LEA     LSRstring,A1    *Loads LSRstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isLSL       BSR     outaddress      *prints current address
            LEA     LSLstring,A1    *Loads LSLstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isASR       BSR     outaddress      *prints current address
            LEA     ASRstring,A1    *Loads ASRstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP 
isASL       BSR     outaddress      *prints current address
            LEA     ASLstring,A1    *Loads ASLstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isROR       BSR     outaddress      *prints current address
            LEA     RORstring,A1    *Loads RORstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isROL       BSR     outaddress      *prints current address
            LEA     ROLstring,A1    *Loads ROLstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isBCLR      BSR     outaddress      *prints current address
            LEA     BCLRstring,A1   *Loads BCLRstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isBCS       BSR     outaddress      *prints current address
            LEA     BCSstring,A1    *Loads BCSstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isBGE       BSR     outaddress      *prints current address
            LEA     BGEstring,A1    *Loads BGEstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isBLT       BSR     outaddress      *prints current address
            LEA     BLTstring,A1    *Loads BLTstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isBVC       BSR     outaddress      *prints current address
            LEA     BVCstring,A1    *Loads BVCstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isBRA       BSR     outaddress      *prints current address
            LEA     BRAstring,A1    *Loads BRAstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isJSR       BSR     outaddress      *prints current address
            LEA     JSRstring,A1    *Loads JSRstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP
isRTS       BSR     outaddress      *prints current address
            LEA     RTSstring,A1    *Loads RTSstring for printing
            MOVE.B  #13,D0          *Sets up trap
            TRAP    #15
            BRA     endOP


*Masks to make comparisons easier
compMask    MOVE.W  D0,D2           *Gets fresh copy of D0
            ANDI.W  #opMask,D2      *Masks D2 for rest of comparisons
            RTS
mask15to8   MOVE.W  D0,D2               *Gets fresh copy of D0
            ANDI.W  #BitMask15to8,D2    *Masks D2 for the first byte
            RTS
mask15to12  MOVE.W  D0,D2               *Gets fresh copy of D0
            ANDI.W  #BitMask15to12,D2   *Masks first bit
            RTS
mask15to7   MOVE.W  D0,D2               *Gets fresh copy of D0
            ANDI.W  #BitMask15to7,D2    *Masks D2
            RTS
mask15to6   MOVE.W  D0,D2               *Gets fresh copy of D0
            ANDI.W  #BitMask15to6,D2    *Masks D2
            RTS
maskMulDivl MOVE.W  D0,D2               *Gets fresh copy of D0
            ANDI.W  #BitMaskMulDivl,D2  *Masks D2
            RTS
maskShift   MOVE.W  D0,D2               *Gets a fresh copy of D0
            ANDI.W  #BitMaskShifts,D2   *Masks D2
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

*Strings for I/O
datastring  DC.B    'DATA ',0   *Data string
NOPstring   DC.B    'NOP',0     *NOP string
EORstring   DC.B    'EOR',0     *EOR string
ORIstring   DC.B    'ORI',0     *ORI string
ORstring    DC.B    'OR',0      *OR string
ADDstring   DC.B    'ADD',0     *ADD string
ADDAstring  DC.B    'ADDA',0     *ADDA string
MOVEMstring DC.B    'MOVEM',0   *MOVEM string
MOVEAstring DC.B    'MOVEA',0   *MOVEA string
MOVEstring  DC.B    'MOVE',0    *MOVE string
SUBstring   DC.B    'SUB',0     *SUB string
SUBQstring  DC.B    'SUB',0     *SUBQ string
MULSstring  DC.B    'MULS',0    *MULS string
DIVSstring  DC.B    'DIVS',0    *DIVS string
CMPstring   DC.B    'CMP',0     *CMP string
CMPIstring  DC.B    'CMPI',0    *CMPI string
LSLstring   DC.B    'LSL',0     *LSL string
LSRstring   DC.B    'LSR',0     *LSR string
ASLstring   DC.B    'ASL',0     *ASL string
ASRstring   DC.B    'ASR',0     *ASR string
ROLstring   DC.B    'ROL',0     *ROL string
RORstring   DC.B    'ROR',0     *ROR string
BCLRstring  DC.B    'BCLR',0    *BCLR string
BCSstring   DC.B    'BCS',0     *BCS string
BGEstring   DC.B    'BGE',0     *BGE string
BLTstring   DC.B    'BLT',0     *BLT string
BVCstring   DC.B    'BVC',0     *BVC string
BRAstring   DC.B    'BRA',0     *BRA string
JSRstring   DC.B    'JSR',0     *JSR string
RTSstring   DC.B    'RTS',0     *RTS strin


*Bit Masks

BitMask15to12 EQU   $F000       *Mask for first byte
BitMaskMulDivl EQU  %1000101111000000  *Mask for MULS and DIVS Long
BitMask15to6 EQU    $FFC0       *Mask for showing bits 15 through 6 (BCLR immidiate)
BitMask15to7 EQU    $FF80       *Mask for showing bits 15 through 7 (MOVEM)
BitMask15to8 EQU    $FF00       *Mask for showing first two bytes, 0'ing last 2
opMask      EQU     $F1C0       *Masks word so first byte and OP mode are visible
                                *The rest of the word are 0's
BitMaskShifts EQU   %1111000100011000   *Masks for the shift op codes

*Masked Op codes
nop_code    EQU     $4E71       *Hex for NOP
eorb_code   EQU     %1011000100000000   *Binary of EOR.B, masked
eorw_code   EQU     %1011000101000000   *Binary of EOR.W, masked
eorl_code   EQU     %1011000110000000   *Binary of EOR.L, masked
ori_code    EQU     $00               *Hex of first two bytes of ORI
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
movemr2m_code EQU   %0100100010000000   *Binary of MOVEM from register to memory
movemm2r_code EQU   %0100110010000000   *Binary of MOVEM from memory to register
moveaw_code EQU     %0011000001000000   *Binary of MOVEA Word
moveal_code EQU     %0010000001000000   *Binary of MOVEA long
moveb_code  EQU     %0001000000000000   *Binary of MOVE byte
movew_code  EQU     %0011000000000000   *Binary of MOVE word
movel_code  EQU     %0010000000000000   *Binary of Move long
subbDn_code EQU     %1001000000000000   *Binary of SUB.B -> Dn
subwDn_code EQU     %1001000001000000   *Binary of SUB.W -> Dn
sublDn_code EQU     %1001000010000000   *Binary of SUB.L -> Dn
subbEA_code EQU     %1001000100000000   *Binary of SUB.B -> EA
subwEA_code EQU     %1001000101000000   *Binary of SUB.W -> EA
sublEA_code EQU     %1001000110000000   *Binary of SUB.L -> EA
subqb_code  EQU     %0101000100000000   *Binary of SUBQ byte
subqw_code  EQU     %0101000101000000   *Binary of SUBQ word
subql_code  EQU     %0101000110000000   *Binary of SUBQ long
mulsl_code  EQU     %0000100000000000   *Binary of MULS.L
divsl_code  EQU     %0000100001000000   *Binary of DIVS.L
mulsw_code  EQU     %1100000111000000   *Binary of MULS.W
divsw_code  EQU     %1000000111000000   *Binary of DIVS.W
cmpb_code   EQU     %1011000000000000   *Binary of CMP.B
cmpw_code   EQU     %1011000001000000   *Binary of CMP.W
cmpl_code   EQU     %1011000010000000   *Binary of CMP.L
cmpi_code   EQU     %0000110000000000   *Binary of CMPI
lsl_code    EQU     %1110000100001000   *Binary of LSL
lsr_code    EQU     %1110000000001000   *Binary of LSR
asl_code    EQU     %1110000100000000   *Binary of ASL
asr_code    EQU     %1110000000000000   *Binary of ASR
rol_code    EQU     %1110000100011000   *Binary of ROL
ror_code    EQU     %1110000000011000   *Binary of ROR
bclri_code  EQU     %0000100010000000   *Binary of BCLR with an immidiate
bclr_code   EQU     %0000000110000000   *Binary of BCLR
bcs_code    EQU     %0110010100000000   *Binary of BCS
bge_code    EQU     %0110110000000000   *Binary of BGE
blt_code    EQU     %0110110100000000   *Binary of BLT
bvc_code    EQU     %0110100000000000   *Binary of BVC
bra_code    EQU     %0110000000000000   *Binary of BRA
jsr_code    EQU     %0100111010000000   *Binary of JSR
rts_code    EQU     %0100111001110101   *Binary of RTS

    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
