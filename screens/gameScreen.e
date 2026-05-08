// IMAGE DETAIL
IMAGE_WIDTH                 384
IMAGE_HEIGHT                216
IMAGE_OFFSET_X              128
IMAGE_OFFSET_Y              40


POINTS_GS_OFFSET_X 260
POINTS_GS_OFFSET_Y 278

POINTS_NUM_GS_OFFSET_X 390
POINTS_NUM_GS_OFFSET_Y 278


pastWord -1


// > GENERATE GAME SCREEN FUNCTION <========================================================================< //

generateGameScreen_returnAddress 0

generateGameScreen      cp clearScreen_color backgroundColor
                        cp current_entered_index CONST_ZERO
                        call clearScreen clearScreen_returnAddress

                        // displays the exit button on the top right of the screen
                        cp drawString_stringAddress gameScreenExitText
                        cp drawString_startX gameScreenExitXOffset
                        cp drawString_startY gameScreenExitYOffset
                        call drawString drawString_returnAddress

                        cp useSDRAM_imageX IMAGE_OFFSET_X
                        cp useSDRAM_imageY IMAGE_OFFSET_Y


                        ///
randomize               call rand rand_returnAddress
                        cp useSDRAM_index rand_result

                        be skipAdd6 VGA_ZERO difficulty
                        add useSDRAM_index useSDRAM_index CONST_SIX


skipAdd6                be randomize pastWord useSDRAM_index
                        cp pastWord useSDRAM_index
                        call useSDRAM useSDRAM_returnAddress

                        call drawLines drawLines_returnAddress

                        // draw current points
                        cp drawString_stringAddress totalPointsText
                        cp drawString_startX POINTS_GS_OFFSET_X
                        cp drawString_startY POINTS_GS_OFFSET_Y
                        call drawString drawString_returnAddress

                        add drawLetter_letter CONST_ZERO_KEYBOARD points
                        cp drawLetter_startX POINTS_NUM_GS_OFFSET_X
                        cp drawLetter_startY POINTS_NUM_GS_OFFSET_Y
                        call drawLetter drawLetter_returnAddress
                        /// 

                        ret generateGameScreen_returnAddress


// > END GENERATE GAME SCREEN FUNCTION <========================================================================< //



// > DRAW LINES FUNCTION <=================================================================================<//

drawLines_returnAddress 0

drawLines_numLines 0
drawLines_i 0 
drawLines_xOffset 0 
drawLines_baseX 330 // halfway + (separation - length) / 2
drawLines_yOffset 0 
drawLines_baseY 390

drawLines_separation 60
drawLines_length 40
drawLines_height 6

drawLines_compensateLength 0
drawLines_compensateAmnt   10

drawLines           cp drawLines_i CONST_ZERO

                    cp drawLines_numLines VI_word_length

                    cp drawLines_xOffset drawLines_baseX
                    cp drawLines_yOffset drawLines_baseY

                    div drawLines_compensateAmnt drawLines_separation CONST_TWO
                    mult drawLines_compensateLength drawLines_numLines drawLines_compensateAmnt

                    sub drawLines_xOffset drawLines_xOffset drawLines_compensateLength

                    cp writeRect_color zero

drawLines_for       be drawLines_end drawLines_i drawLines_numLines      

                    cp writeRect_xStart drawLines_xOffset
                    add writeRect_xEnd writeRect_xStart drawLines_length

                    cp writeRect_yStart drawLines_yOffset
                    add writeRect_yEnd writeRect_yStart drawLines_height
                    call writeRect writeRect_returnAddress

                    add drawLines_xOffset drawLines_xOffset drawLines_separation

                    add drawLines_i drawLines_i one
                    be drawLines_for 0 0

drawLines_end       ret drawLines_returnAddress
// > END DRAW LINES FUNCTION <=================================================================================<//



// // > TO UPPER FUNCTION <==================================================================================<//
// MOVED TO VALIDATE_INPUT.E

