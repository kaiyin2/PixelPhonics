                            // give the non-blocking function somewhere to return to initially
                            // in case we want to put anything up here, this will prevent it from
                            // going to nonsense @ address 0
                            cp nonBlock_returnAddress ML_MINUS_1
                            add nonBlock_returnAddress nonBlock_returnAddress CONST_ONE



// initalizes game (loading screen then main screen)
initGame                    call loading_screen loading_screen_returnAddress            // displays the loading screen while other tasks perform
                            cp current_entered_index CONST_ZERO


                            be skipKeyboardStart 0x80000020 CONST_ONE 
                            cp 0x80000020 CONST_ONE                                     // issues start command to keyboard

                            // this is for if you hit play again
skipKeyboardStart           bne loadGame sdAlreadyLoaded CONST_ZERO
                            call loadSDToRam loadSDToRam_returnAddress                  // copies information from SD card to SDRAM
                            cp sdAlreadyLoaded CONST_ONE


loadGame                    cp points CONST_ZERO                                        // resets points to 0
                            cp longestStreak CONST_ZERO                                 // resets longest streak to 0

                            call titleScreen titleScreen_returnAddress                  // displays the main screen

startLoopJump               be startLoop CONST_ZERO CONST_ZERO                          // unconditionally branches to title screen + settings



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// all settings and settings sub menus are handled in settings-logic.e in pixelPhonics folder /////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// TO-DO: implement the main game logic

mainLoop                    call generateGameScreen generateGameScreen_returnAddress


// this loop handles all the keyboard input
// only will break out if user exits of presses enter or 9 (the exit character)
mainKeyboardLoop            call keyboard_START keyboard_RETURN
                            be mainKeyboardLoop keyboard_ready CONST_ZERO

                            be initEndScreen keyboard_ASCII CONST_NINE_KEYBOARD                 // handles if user wants to exit

                            be validateInput keyboard_ASCII CONST_ENTER_KEYBOARD_VER_1          // handles checking if user presses enter
                            be validateInput keyboard_ASCII CONST_ENTER_KEYBOARD_VER_2          // two different ways of handling enter/return

                            be mainKeyboardLoop_backspace keyboard_ASCII CONST_BACKSPACE_KEYBOARD   // if the user presses backspace


                            // checks for the validity of the input
mainKeyboardLoop_check      call VI_LETTERS_START VI_LETTERS_RETURN                             // call function to check letters
                            be mainKeyboardLoop VI_LETTERS_RESULT CONST_ZERO                    // if input was not valid, loop back to mainKeyboardLoop                                      

                            be mainKeyboardLoop current_entered_index VI_word_length

                            // valid input, put into array
mainKeyboardLoop_char       cpta keyboard_ASCII VI_entered_word current_entered_index                   // copies the entered character into VI_entered_word at index current_entered_index    

                            // draw start
                            // since we r subtracting later, i'll just subtract here instead of rewriting the other stuff 

                            sub drawLetter_letter keyboard_ASCII ASCII_CAPITAL_OFFSET
                            cp drawLetter_startY ENTERED_LETTER_Y_OFFSET
                            cp drawLetter_startX drawLines_baseX

// yes this is copy pasted from the other function but it won't cause any problems (i hope)
                            div drawLines_compensateAmnt drawLines_separation CONST_TWO
                            mult drawLines_compensateLength drawLines_numLines drawLines_compensateAmnt

                            sub drawLetter_startX drawLetter_startX drawLines_compensateLength

                            mult SEPARATION_MULT drawLines_separation current_entered_index
                            add drawLetter_startX drawLetter_startX SEPARATION_MULT

                            add drawLetter_startX drawLetter_startX CENTER_LETTER_BLANK

                            call drawLetter drawLetter_returnAddress
                            // draw end
                            add current_entered_index current_entered_index CONST_ONE                           // adds the current index   
                            be mainKeyboardLoop CONST_ZERO CONST_ZERO                           // unconditionally branch back to check for keyboard input                    

mainKeyboardLoop_backspace  be mainKeyboardLoop current_entered_index CONST_ZERO                  // ignore backspace if the user hasn't entered any input
                            sub current_entered_index current_entered_index CONST_ONE                           // subtracts the current index                              

                            // drawing rectangle

                            cp writeRect_color backgroundColor

                            cp writeRect_xStart drawLines_baseX 

                            div drawLines_compensateAmnt drawLines_separation CONST_TWO
                            mult drawLines_compensateLength drawLines_numLines drawLines_compensateAmnt

                            sub writeRect_xStart writeRect_xStart drawLines_compensateLength

                            mult SEPARATION_MULT drawLines_separation current_entered_index
                            add writeRect_xStart writeRect_xStart SEPARATION_MULT

                            add writeRect_xStart writeRect_xStart CENTER_LETTER_BLANK

                            cp writeRect_yStart ENTERED_LETTER_Y_OFFSET
                            add writeRect_yEnd writeRect_yStart BOX_HEIGHT
                            add writeRect_xEnd writeRect_xStart BOX_WIDTH


                            call writeRect writeRect_returnAddress

                            // end draw rectangle

                            cpta CONST_ZERO VI_entered_word current_entered_index                       // replaces last entered character of VI_entered_word with '0' 
                            be mainKeyboardLoop CONST_ZERO CONST_ZERO                          // unconditionally branch back to check for keyboard input


validateInput               call VI_START VI_RETURN
                            
                            // correct
                            bne incorrectAnswer VI_failed_word CONST_ZERO

                            cp writeRect_xStart CORRECT_TEXT_OFFSET_X
                            cp writeRect_yStart CORRECT_TEXT_OFFSET_Y
                            add writeRect_xEnd writeRect_xStart INCORRECT_COVER_X
                            add writeRect_yEnd writeRect_yStart INCORRECT_COVER_Y
                            cp writeRect_color backgroundColor
                            call writeRect writeRect_returnAddress

                            cp drawString_stringAddress gameScreenCorrectText
                            cp drawString_startX CORRECT_TEXT_OFFSET_X
                            cp drawString_startY CORRECT_TEXT_OFFSET_Y
                            call drawString drawString_returnAddress

                            add points points CONST_ONE
                            add longestStreak longestStreak CONST_ONE
                             
                            call getTime getTime_returnAddress
                            cp timeDelayStart getTime_time 
                            add timeDelayEnd timeDelayStart halfSecond

                            be blockingTimeCorrect audio CONST_ZERO               // if audio is off, skip play audio
                            call start_corsfx start_corsfx_ra

                            // blocking loop to wait for time to advance 0.5 seconds
blockingTimeCorrect         blt returnToMainAfterTime timeDelayEnd getTime_time
                            call update_sfx update_sfx_ra
                            call getTime getTime_returnAddress

                            be blockingTimeCorrect 0 0

returnToMainAfterTime       be mainLoop 0 0

                            // incorrect (cover previous stuff first)
incorrectAnswer             cp writeRect_xStart CORRECT_TEXT_OFFSET_X
                            cp writeRect_yStart CORRECT_TEXT_OFFSET_Y
                            add writeRect_xEnd writeRect_xStart INCORRECT_COVER_X
                            add writeRect_yEnd writeRect_yStart INCORRECT_COVER_Y
                            cp writeRect_color backgroundColor

                            cp longestStreak CONST_ZERO

                            call writeRect writeRect_returnAddress


                            ///////////////////
                            call start_incsfx start_incsfx_ra

  //                          call getTime getTime_returnAddress
//                            cp timeDelayStart getTime_time 
   //                         add timeDelayEnd timeDelayStart halfSecond

                            // blocking loop to wait for time to advance 0.5 seconds
//blockingTimeIncorrect       blt incRetAftTime timeDelayEnd getTime_time
     //                       call update_sfx update_sfx_ra
       //                     call getTime getTime_returnAddress

         //                   be blockingTimeIncorrect 0 0
                            ///////////////////

incRetAftTime              cp drawString_stringAddress gameScreenIncorrectText
                            cp drawString_startX CORRECT_TEXT_OFFSET_X
                            cp drawString_startY CORRECT_TEXT_OFFSET_Y
                            cp current_toDelete_index current_entered_index
                            call drawString drawString_returnAddress

                            // delete all letters
                            cp incorrectFor_i CONST_ZERO

incorrectFor                be endIncorrectFor incorrectFor_i VI_word_length
                            cpta CONST_ZERO VI_entered_word incorrectFor_i



                            cp writeRect_color backgroundColor

                            cp writeRect_xStart drawLines_baseX 

                            div drawLines_compensateAmnt drawLines_separation CONST_TWO
                            mult drawLines_compensateLength drawLines_numLines drawLines_compensateAmnt

                            sub writeRect_xStart writeRect_xStart drawLines_compensateLength

                            mult SEPARATION_MULT drawLines_separation incorrectFor_i
                            add writeRect_xStart writeRect_xStart SEPARATION_MULT

                            add writeRect_xStart writeRect_xStart CENTER_LETTER_BLANK

                            cp writeRect_yStart ENTERED_LETTER_Y_OFFSET
                            add writeRect_yEnd writeRect_yStart BOX_HEIGHT
                            add writeRect_xEnd writeRect_xStart BOX_WIDTH


                            call writeRect writeRect_returnAddress

                            add incorrectFor_i incorrectFor_i CONST_ONE

                            be incorrectFor 0 0



endIncorrectFor             cp current_entered_index CONST_ZERO
                            // 

returnToMainAfterIncorrect  be mainKeyboardLoop 0 0

validateInput_after_incorrect  call VI_START VI_RETURN

current_entered_index               0

current_toDelete_index              0


//////////////////////////


// NOTE:     "be initEndScreen X X" to move to end screen. it automatically handles the calculations for points and everything



//                          call nonBlock nonBlock_returnAddress

mainLoopReturn              be mainLoop 0 0 


incorrectFor_i 0


/////////////////////////////////////////////////////////////////////////////////
// SETTINGS MODES
///////////////////////////////////////////////////////////////////////////////// 
difficulty                  1 // 0 = easy, 1 = medium
audio                       1 // 0 = off, 1 = on

// 0 = title, 1 = settings, 2 = game
currentScreen               0
/////////////////////////////////////////////////////////////////////////////////

sdAlreadyLoaded             0
timeDelayStart              0
timeDelayEnd                0
halfSecond                  8000



/////////////////////////////////////////////////////////////////////////////////
// GAME STATISTICS
/////////////////////////////////////////////////////////////////////////////////
points                      0
longestStreak               0
/////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////
// KEYBOARD RESULTS
/////////////////////////////////////////////////////////////////////////////////
// VI_correct_word: parameter for the CORRECT WORD
correctWordStringLoc correctWordStringLoc
VI_correct_word             'h'
                            'a'
                            'p'
                            'p'
                            'y'
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0

                            0
// VI_entered_word: parameter for the ENTERED WORD
enteredWordStringLoc enteredWordStringLoc
VI_entered_word             0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            0
                            
                            0

// VI_word_length: parameter for the LENGTH OF CORRECT WORD
VI_word_length              0
/////////////////////////////////////////////////////////////////////////////////


// details for drawing letter to screen

ENTERED_LETTER_Y_OFFSET 360
SEPARATION_MULT 0 // temp variable
BOX_HEIGHT 27
BOX_WIDTH 80
CENTER_LETTER_BLANK 10 // center letter in blank


// end details for draw letter


/////////////////////////////////////////////////////////////////////////////////
// INCLUDES
/////////////////////////////////////////////////////////////////////////////////

// Strings and Constant Variables
#include strings/loading.e
#include strings/title-and-settings.e
#include strings/settings-audio.e
#include strings/settings-difficulty.e
#include strings/gameScreen.e
#include strings/endScreen.e

#include constant_variables.e

// VGA driver
#include vga/vga_driver.e

// SD driver and SDRAM driver
#include SD/sd_driver.e
#include SD/sdram_driver.e
#include SD/sdRetriever.e
#include SD/useSDRAM.e

// Keyboard driver
#include keyboard/keyboard_driver.e

#include nonBlocking.e
#include clock.e
#include validate_input.e

// Screens
#include screens/loading.e
#include screens/titleScreen.e
#include screens/settings.e
#include screens/settings-audio.e
#include screens/settings-difficulty.e
#include screens/gameScreen.e
#include screens/endScreen.e

// Screen Logic
#include settings-logic.e
#include endScreen-logic.e
#include mod.e

#include sfx_nonblocking.e
