// only upper 5 bits are taken into consideration in color_write (and it goes RGB where R is upper, etc)
// vga_write = 1 to write; read if 0

// this files contains letters, images, and basic drawing 

backgroundColor 0xe8e8e0

// > VGA read pixel function <=====================================================================================<//

// params
readPixel_x 0
readPixel_y 0

// returns
readPixel_result 0
readPixel_returnAddress 0

// variables


//writeRect       call writeRectDelay writeRectDelay_returnAddress

// Likely won't be used so I probably won't make it non-blocking    

// body
readPixel       call vgaBusyWait vgaBusyWait_returnAddress

                cpta readPixel_x 0 VGA_X_START_ADDRESS
                cpta readPixel_y 0 VGA_Y_START_ADDRESS 

                cpta VGA_ZERO 0 VGA_WRITE_ADDRESS 
                cpta VGA_ONE 0 VGA_TURN_ADDRESS

                call vgaBusyWait vgaBusyWait_returnAddress

                cpfa readPixel_result 0 VGA_COLOR_IN_ADDRESS

                ret readPixel_returnAddress

// > END VGA read pixel function <=====================================================================================<//





// > VGA string function <================================================================================< // 
// null terminated

// PARAMS
drawString_stringAddress 0
drawString_returnAddress 0
drawString_startX 0
drawString_startY 0

// VARIABLES
drawString_index 1
drawString_rawIndex 0
drawString_null 0
drawString_x_off 0


drawString      cp drawString_index drawString_stringAddress
                add drawString_index drawString_index VGA_ONE

                
dsWhile         cpfa drawLetter_letter 0 drawString_index
                be drawString_end drawString_null drawLetter_letter

                // Put the letter 3 pixels past the end of the last letter
                // this means that if a different function calls drawLetter during the execution of 
                // this one, then this function gets cooked
                add drawLetter_startX VGA_SIX drawLetter_rightFilledPixel
                //

                cp drawLetter_startY drawString_startY 

                sub drawString_rawIndex drawString_index drawString_stringAddress
                sub drawString_rawIndex drawString_rawIndex VGA_ONE
                bne drawString_call drawString_rawIndex VGA_ZERO

                // if index == 0, put in proper location
                cp drawLetter_startX drawString_startX
                //


drawString_call call drawLetter drawLetter_returnAddress

                add drawString_index drawString_index VGA_ONE
                be dsWhile 0 0

drawString_end  ret drawString_returnAddress
// > End VGA string function <================================================================================< // 


// > VGA draw letter function <===============================================================================< // 

// ASCII 'A' is at 65; 'Z' is at 90
// 'a' is 97; 'z' is 122
// checks if letter is out of bounds and ignores if so (so we can use any character for spaces)


// all the letters n->z are offset up by one pixel..

// PARAMS
drawLetter_letter 0 // ascii; not 0 indexed
drawLetter_startX 0
drawLetter_startY 0
drawLetter_size 0 // unused ...
drawLetter_returnAddress 0
drawLetter_manualOffset 0

// VARIABLES
drawLetter_AOffset 65
drawLetter_ZOffset 90
drawLetter_0Offset 48
drawLetter_9Offset 57
//drawLetter_aOffset 97
drawLetter_height 45 // this is the height, which Im hardcoding, which isn't ideal
drawLetter_index 0
drawLetter_smallOffset 0 // account for minor error
drawLetter_indexOffset 0
// account for numbers being weird
drawLetter_numOffset 0

// RETURNS
drawLetter_rightFilledPixel 0


// BODY
//drawLetter      add drawLetterCallCount drawLetterCallCount VGA_ONE
drawLetter      be dl_letterCheck 0 0

                // checking letter bounds
dl_letterCheck  blt dl_numberCheck drawLetter_letter drawLetter_AOffset
                blt dl_numberCheck drawLetter_ZOffset drawLetter_letter
                be dl_letterAdjust 0 0

                // checking number bounds   
dl_numberCheck  blt drawLetter_earlyEnd drawLetter_letter drawLetter_0Offset
                blt drawLetter_earlyEnd drawLetter_9Offset drawLetter_letter
                be dl_numberAdjust 0 0

dl_letterAdjust sub drawLetter_index drawLetter_letter drawLetter_AOffset 
                cp drawLetter_numOffset VGA_ZERO

                // retrieve manual offsets
                cpfa drawLetter_manualOffset letterOffsetArray drawLetter_index
                //

                be VGA_dwLet_cont 0 0

dl_numberAdjust sub drawLetter_index drawLetter_letter drawLetter_0Offset
                mult drawLetter_numOffset drawLetter_index VGA_SEVEN
                div drawLetter_numOffset drawLetter_numOffset VGA_TWO

                // retrieve manual offsets
                cpfa drawLetter_manualOffset numberOffsetArray drawLetter_index
                //

                add drawLetter_index drawLetter_index VGA_TWENTY_SIX


VGA_dwLet_cont  cp drawLetter_smallOffset drawLetter_index
                mult drawLetter_smallOffset drawLetter_smallOffset VGA_ONE
                div drawLetter_smallOffset drawLetter_smallOffset VGA_THREE

                sub drawLetter_startY drawLetter_startY drawLetter_manualOffset
                sub drawLetter_startY drawLetter_startY drawLetter_smallOffset

                cp drawLetter_indexOffset drawLetter_index
                sub drawLetter_indexOffset drawLetter_indexOffset drawLetter_numOffset
                mult drawLetter_indexOffset drawLetter_indexOffset VGA_LETTER_ARRAY_WIDTH

                mult drawLetter_index drawLetter_index drawLetter_height
                mult drawLetter_index drawLetter_index VGA_LETTER_ARRAY_WIDTH

                add drawLetter_index drawLetter_index drawLetter_indexOffset

                add drawLetter_index VGA_LETTER_ARRAY_BEGIN drawLetter_index

                cp bwDraw_startAddress drawLetter_index
                cp bwDraw_startX drawLetter_startX
                cp bwDraw_startY drawLetter_startY
                cp bwDraw_arrayWidth VGA_LETTER_ARRAY_WIDTH
                cp bwDraw_arrayHeight drawLetter_height

                call bwDraw bwDraw_returnAddress
                be drawLetter_normalEnd 0 0 

drawLetter_earlyEnd     add drawLetter_rightFilledPixel VGA_SPACE_WIDTH drawLetter_startX
                        be drawLetter_trueEnd 0 0

drawLetter_normalEnd    cp drawLetter_rightFilledPixel bwDraw_rightFilledPixel 

drawLetter_trueEnd      ret drawLetter_returnAddress

// > End VGA draw letter function <===============================================================================< // 




// > VGA Busy Wait Function (Until turn == 0) <=================================================================< // 

// PARAMETERS
vgaBusyWait_returnAddress 0

// VARIABLES
vgaBusyWait_turn 0

// BODY
vgaBusyWait      cpfa vgaBusyWait_turn 0 VGA_TURN_ADDRESS 
                 be vgaBusyWait_done VGA_ZERO vgaBusyWait_turn
                 be vgaBusyWait 0 0

vgaBusyWait_done ret vgaBusyWait_returnAddress

// > End Busy Wait Function (Until turn == 0) <=================================================================< // 


// > VGA NO TRANSPARENCY Write Rectangle Function <============================================================================< // 
// Writes simple rectangle to screen 

// PARAMETERS

writeRect_xStart 0
writeRect_yStart 0
writeRect_xEnd 0
writeRect_yEnd 0
writeRect_color 0
writeRect_returnAddress 0

// BODY
    // assumed that monitor is ready due to logic in non-blocking.e
    // call vgaBusyWait vgaBusyWait_returnAddress
//writeRect       call writeRectDelay writeRectDelay_returnAddress

writeRect       call vgaBusyWait vgaBusyWait_returnAddress

                cpta writeRect_xStart 0 VGA_X_START_ADDRESS
                cpta writeRect_yStart 0 VGA_Y_START_ADDRESS 

                cpta writeRect_xEnd 0 VGA_X_END_ADDRESS 
                cpta writeRect_yEnd 0 VGA_Y_END_ADDRESS 

                cpta writeRect_color 0 VGA_COLOR_OUT_ADDRESS 

                cpta VGA_ONE 0 VGA_WRITE_ADDRESS 
                cpta VGA_ONE 0 VGA_TURN_ADDRESS
                ret writeRect_returnAddress
                
// > End of VGA write rectangle <===============================================================================< // 




// > VGA TRANSPARENCY Write Rectangle Function <============================================================================< // 
// Writes simple rectangle to screen with accounting for alpha bits (most significant 8)

// PARAMETERS

writeRectA_xStart 0
writeRectA_yStart 0
writeRectA_xEnd 0
writeRectA_yEnd 0
writeRectA_color 0
writeRectA_returnAddress 0

// BODY
//writeRectA       call writeRectADelay writeRectADelay_returnAddress



                // since this function will likely only be called with single pixels,
                // this just retrieves the value of the bottom-right pixel

                // NOTE: since this might never get used,
                // i'm not making it non-blocking quite yet

writeRectA      cp readPixel_x writeRectA_xEnd
                cp readPixel_y writeRectA_yEnd
                call readPixel readPixel_returnAddress

                cp colorMult_B readPixel_result
                cp colorMult_A writeRectA_color
                call colorMult colorMult_returnAddress
                cp writeRectA_color colorMult_result

                cpta writeRectA_xStart 0 VGA_X_START_ADDRESS
                cpta writeRectA_yStart 0 VGA_Y_START_ADDRESS 

                cpta writeRectA_xEnd 0 VGA_X_END_ADDRESS 
                cpta writeRectA_yEnd 0 VGA_Y_END_ADDRESS 

                cpta writeRectA_color 0 VGA_COLOR_OUT_ADDRESS 

                cpta VGA_ONE 0 VGA_WRITE_ADDRESS 
                cpta VGA_ONE 0 VGA_TURN_ADDRESS
                ret writeRectA_returnAddress
                
// > End of VGA write rectangle <===============================================================================< // 


// > VGA color multiply function <=======================================================================< //
// only alpha of A matters!

// params
colorMult_A 0 // uses alpha
colorMult_B 0 // ignores alpha 

// returns
colorMult_result 0
colorMult_returnAddress 0

// variables
colorMult_rA 0
colorMult_gA 0
colorMult_bA 0
colorMult_rB 0
colorMult_gB 0
colorMult_bB 0
colorMult_resR 0
colorMult_resG 0
colorMult_resB 0
colorMult_alpha 0 // [0, 255]
colorMult_alphaSubtract 0 

                // my formula: 
                // alpha * A + (1 - alpha) * B
                // where alpha = [0, 1]


                // to get rid of color bits for alpha variable
colorMult       sr colorMult_alpha colorMult_A VGA_ALPHA_OFFSET
                sl colorMult_alphaSubtract colorMult_alpha VGA_ALPHA_OFFSET

                // to get rid of alpha bits in colorB (just in case it happens to have any)
                sl colorMult_B colorMult_B VGA_EIGHT
                sr colorMult_B colorMult_B VGA_EIGHT

                and colorMult_rA colorMult_A VGA_RED_MASK
                and colorMult_gA colorMult_A VGA_GREEN_MASK
                and colorMult_bA colorMult_A VGA_BLUE_MASK
               
                and colorMult_rB colorMult_B VGA_RED_MASK
                and colorMult_gB colorMult_B VGA_GREEN_MASK
                and colorMult_bB colorMult_B VGA_BLUE_MASK

                // can use the function without shifting down as long as i
                // mask them again 

                cp indivMult_alpha colorMult_alpha

                // r
                cp indivMult_cA colorMult_rA
                cp indivMult_cB colorMult_rB
                call indivMult indivMult_returnAddress
                cp colorMult_resR indivMult_result 
                and colorMult_resR colorMult_resR VGA_RED_MASK

                // g
                cp indivMult_cA colorMult_gA
                cp indivMult_cB colorMult_gB
                call indivMult indivMult_returnAddress
                cp colorMult_resG indivMult_result 
                and colorMult_resG colorMult_resG VGA_GREEN_MASK

                // b
                cp indivMult_cA colorMult_bA
                cp indivMult_cB colorMult_bB
                call indivMult indivMult_returnAddress
                cp colorMult_resB indivMult_result 
                and colorMult_resB colorMult_resB VGA_BLUE_MASK

                add colorMult_result colorMult_resR colorMult_resG
                add colorMult_result colorMult_result colorMult_resB
                add colorMult_result colorMult_result VGA_ALPHA_MASK

                ret colorMult_returnAddress

// > End VGA color multiply function <=======================================================================< //



// > VGA color multiply indiviviual color <====================================================================== < //

// params
indivMult_cA 0 // [0, 255] all    (a * alpha, b * invAlpha)
indivMult_cB 0
indivMult_alpha 0

// vars
indivMult_invAlpha 0

// returns
indivMult_result 0
indivMult_returnAddress 0


indivMult       sub indivMult_invAlpha VGA_2_8M1 indivMult_alpha

                mult indivMult_cA indivMult_cA indivMult_alpha
                mult indivMult_cB indivMult_cB indivMult_invAlpha
 
                div indivMult_cA indivMult_cA VGA_2_8M1
                div indivMult_cB indivMult_cB VGA_2_8M1

                add indivMult_result indivMult_cA indivMult_cB

                ret indivMult_returnAddress

// > ENd VGA color multiply indiviviual color <====================================================================== < //



// > VGA Clear Screen Function <================================================================================< // 
// Clears screen to a single color

// PARAMS

clearScreen_color 0
clearScreen_returnAddress 0

// BODY

clearScreen     cp writeRect_xStart VGA_ZERO
                cp writeRect_yStart VGA_ZERO
                cp writeRect_xEnd VGA_X_MAX 
                cp writeRect_yEnd VGA_Y_MAX
                cp writeRect_color clearScreen_color

                call writeRect writeRect_returnAddress

                ret clearScreen_returnAddress

// > End of VGA clear screen <===============================================================================< // 


// > VGA draw array simple <==============================================================================================< //
// draws array of pixels naively (each pixel is defined individually; wasteful in many situations)
// row-major array cuz ppms are row major

// currently is alpha-less 

// can be fed normal 8 bit pixels bcuz the system of 5 bits per colors being the upper
// 5 bits is smart; it just loses precision without losing correctness


// PARAMS
drawArray_startAddress 0 // n + 1 is true array begin
drawArray_arrayWidth 0
drawArray_arrayHeight 0
drawArray_startX 0
drawArray_startY 0
drawArray_returnAddress 0 

// FUNCTION VARIABLES 
drawArray_x 0
drawArray_y 0

drawArray_index 0 

// BODY

drawArray       add drawArray_startAddress drawArray_startAddress VGA_ONE
                
drawArray_xFor  be drawArray_xEnd drawArray_x drawArray_arrayWidth
                    cp drawArray_y VGA_ZERO // reset inner loop
drawArray_yFor      be drawArray_yEnd drawArray_y drawArray_arrayHeight 

                    add writeRect_xStart drawArray_x drawArray_startX
                    add writeRect_yStart drawArray_y drawArray_startY

                    add writeRect_xEnd writeRect_xStart VGA_ONE
                    add writeRect_yEnd writeRect_yStart VGA_ONE

                    mult drawArray_index drawArray_y drawArray_arrayWidth
                    add drawArray_index drawArray_index drawArray_x
                    add drawArray_index drawArray_index drawArray_startAddress 
                    cpfa writeRect_color 0 drawArray_index

                    call writeRect writeRect_returnAddress

drawArray_yAdd      add drawArray_y drawArray_y VGA_ONE
                    be drawArray_yFor 0 0 
                        
drawArray_xAdd  add drawArray_x drawArray_x VGA_ONE
                be drawArray_xFor 0 0 

drawArray_yEnd  be drawArray_xAdd  0 0
drawArray_xEnd  be drawArrayEnd 0 0
                
drawArrayEnd    cp drawArray_index VGA_ZERO
                cp drawArray_x VGA_ZERO
                cp drawArray_y VGA_ZERO


                ret drawArray_returnAddress


// > End of VGA draw array <===================================================================================< // 

// > Black and White VGA draw array  <=========================================================================< // 
// this is just for my letter rendering 
// format: 4 bit magnitude for brightness (8 pixels/word) 
// slower than plain array

// behold, the triple nested (potentially 4 soon) for loop!

// PARAMS
bwDraw_startAddress 0 // n + 1 is true array begin
bwDraw_arrayWidth 0 // this is totalwidth / 8
bwDraw_arrayHeight 0
bwDraw_startX 0
bwDraw_startY 0
bwDraw_returnAddress 0 

// FUNCTION VARIABLES 
bwDraw_x 0
bwDraw_y 0
bwDraw_n 0 // which pixel its on
bwDraw_dataWord 0 // contains all 8 pixels

bwDraw_index 0 
bwDraw_fMask 0xf
bwDraw_bitShift 0
bwDraw_magnitude 0
bwDraw_PIXELS_PER_WORD 8
bwDraw_BITS_PER_PIXEL 4
bwDraw_totalWidth 0 // width * 8

// RETURNS
bwDraw_rightFilledPixel 0


// BODY

bwDraw         add bwDraw_startAddress bwDraw_startAddress VGA_ONE
               mult bwDraw_totalWidth bwDraw_arrayWidth bwDraw_PIXELS_PER_WORD 
bwDraw_xFor    be bwDraw_xEnd bwDraw_x bwDraw_arrayWidth
                   // y loop reset
                   cp bwDraw_y VGA_ZERO 

bwDraw_yFor        be bwDraw_yEnd bwDraw_y bwDraw_arrayHeight 
                        // n loop reset
                        cp bwDraw_n VGA_ZERO 

// Y BODY                        
                         mult bwDraw_index bwDraw_y bwDraw_arrayWidth // low width for data retrieval
                         add bwDraw_index bwDraw_index bwDraw_x // regular x bcuz 1 x = 8 pixels
                         add bwDraw_index bwDraw_index bwDraw_startAddress 
                         cpfa bwDraw_dataWord 0 bwDraw_index

                         // ok to skip n loop because if it's max then each pixel is also max
                         be bwDraw_yAdd writeRect_color VGA_MAX

// END Y BODY

bwDraw_nFor              be bwDraw_nEnd bwDraw_n bwDraw_PIXELS_PER_WORD
                    
// N BODY
                        
                            mult bwDraw_bitShift bwDraw_n bwDraw_BITS_PER_PIXEL// shift by n * 4
                            sr bwDraw_magnitude bwDraw_dataWord bwDraw_bitShift  
                            and bwDraw_magnitude bwDraw_magnitude bwDraw_fMask 

                            // skip transparent
                            be bwDraw_nAdd bwDraw_magnitude bwDraw_fMask 

                            // call to turn a magnitude into a black/white pixel
                            cp convertMag_n bwDraw_magnitude
                            call convertMag convertMag_returnAddress
                            cp writeRect_color convertMag_result

                            // currently set to regular writeRect for speed since not transparent
                            mult writeRect_xStart bwDraw_x bwDraw_PIXELS_PER_WORD
                            add writeRect_xStart writeRect_xStart bwDraw_startX
                            add writeRect_xStart writeRect_xStart bwDraw_n
                            
                            add writeRect_yStart bwDraw_y bwDraw_startY

                            add writeRect_xEnd writeRect_xStart VGA_ONE
                            add writeRect_yEnd writeRect_yStart VGA_ONE

                            cp bwDraw_rightFilledPixel writeRect_xEnd

                            call writeRect writeRect_returnAddress

// END N BODY

// ADD
bwDraw_nAdd         add bwDraw_n bwDraw_n VGA_ONE
                    be bwDraw_nFor 0 0

bwDraw_yAdd      add bwDraw_y bwDraw_y VGA_ONE
                 be bwDraw_yFor 0 0 
                        
bwDraw_xAdd  add bwDraw_x bwDraw_x VGA_ONE
             be bwDraw_xFor 0 0 

// RESET
bwDraw_nEnd  be bwDraw_yAdd  0 0
bwDraw_yEnd  be bwDraw_xAdd  0 0
bwDraw_xEnd  be bwDrawEnd 0 0
                
bwDrawEnd    cp bwDraw_index VGA_ZERO
             cp bwDraw_x VGA_ZERO
             cp bwDraw_y VGA_ZERO

             ret bwDraw_returnAddress

// > End Black and White VGA draw array  <=========================================================================< // 






// > Convert 4 bit magnitude to e100 color <=============================================================================<//
// put in ALPHA not in color values any more!
// therefore color values are pure black 


// 4 bit magnitude: multiply by 16 to get alpha value
// but subtract from 256 since that would be inverse alpha

// PARAMS
convertMag_returnAddress 0
convertMag_n 0

//RETURNS
convertMag_result 0

// BODY
convertMag      mult convertMag_n convertMag_n VGA_2_4
                sub convertMag_n VGA_2_8M1 convertMag_n
                sl convertMag_result convertMag_n VGA_ALPHA_OFFSET

                ret convertMag_returnAddress
                

// > End Convert magnitude to e100 color <=============================================================================<//




// CONSTANTS 

// numbers
VGA_ONE 1
VGA_ZERO 0
VGA_MAX 0xffffffff 
VGA_TWO 2
VGA_THREE 3
VGA_FOUR 4
VGA_SEVEN 7
VGA_FOURTEEN 14
VGA_THIRTEEN 13
VGA_TWELVE 12
VGA_EIGHT 8
VGA_ELEVEN 11
VGA_FIVE 5
VGA_TWENTY_SIX 26
VGA_SIX 6
// VGA specific details 
VGA_X_MAX 639
VGA_Y_MAX 479
VGA_WIDTH 640
VGA_HEIGHT 480
red 0xff0000
// powers (M1 = minus1)
VGA_2_24 0x1000000
VGA_2_8 0x100
VGA_2_8M1 0xff
VGA_2_4 16

// masks
VGA_ALPHA_MASK 0xff000000
VGA_RED_MASK   0xff0000
VGA_GREEN_MASK 0xff00
VGA_BLUE_MASK  0xff


// driver details
VGA_TURN_ADDRESS 0x80000060
VGA_WRITE_ADDRESS 0x80000061

VGA_X_START_ADDRESS 0x80000062
VGA_Y_START_ADDRESS 0x80000063

VGA_X_END_ADDRESS 0x80000064
VGA_Y_END_ADDRESS 0x80000065

VGA_COLOR_OUT_ADDRESS 0x80000066
VGA_COLOR_IN_ADDRESS 0x80000067

VGA_ALPHA_OFFSET 24 // bits

VGA_BLACK 0

A 'A'
B 'B'
C 'C'
D 'D'
E 'E'
F 'F'
G 'G'
H 'H'
I 'I'
J 'J'
K 'K'
L 'L'
M 'M'
N 'N'
O 'O'
P 'P'
Q 'Q'
R 'R'
S 'S'
T 'T'
U 'U'
V 'V'
W 'W'
X 'X'
Y 'Y'
Z 'Z'

ZERO_CHAR '0'
ONE_CHAR '1'

// due to my imperfect process of making the letter array,
// the letters do not line up perfectly. additionally, i use a 
// fractional ratio  with integer division, which also makes things bumpy
// so to make things look good i made a small manual offset for every letter & number

letterOffsetArray 0 // A
  1 // B
  1 // C
  0 // D
  1 // E
  1 // F
  0 // G
  0 // H
  1 // I
  0 // J
  0 // K
  1 // L
  0 // M
  0 // N
  0 // O
  -1 // P
  -1 // Q
  -1  // R
  -1 // S
  -1 // T
  0 // U
  -1 // V
  -1 // W
  0 // X
  -1 // Y
  -1 // Z


numberOffsetArray 0 // 0
  -1 // 1
  0 // 2
  0 // 3
  0 // 4
  -1 // 5
  0 // 6
  -1 // 7
  0 // 8
  0 // 9



VGA_LETTER_ARRAY_WIDTH 3 // 5
VGA_ACTUAL_LETTER_WIDTH 24 // 40
VGA_SPACE_WIDTH 18


VGA_LETTER_ARRAY_HEIGHT 1620

VGA_LETTER_ARRAY_BEGIN VGA_LETTER_ARRAY_BEGIN
#include lettersAndNumbersOut.e
