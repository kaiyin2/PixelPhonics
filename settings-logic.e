



ML_MINUS_1 ML_MINUS_1

// loads the main menu
startLoop                   call keyboard_START keyboard_RETURN                          // call the keyboard function
                            be startLoop keyboard_ready CONST_ZERO                       // if keyboard isn't ready for new letter, branch to mainLoop to perform other tasks

                            be mainLoop keyboard_ASCII CONST_ONE_KEYBOARD               // branches to mainLoop if 1 (play button) is pressed
                            be initSettingsScreen keyboard_ASCII CONST_TWO_KEYBOARD     // branches to initSettingsScreen if 2 (settings menu) is pressed

                            be startLoop CONST_ZERO CONST_ZERO                          // unconditionally loops back to startLoop



// loads the settings menu
initSettingsScreen          cp currentScreen CONST_ONE                                  // updates currentScreen to 1     
                            call settings settings_returnAddress                        // paints the settings screen

settingsLoop                call keyboard_START keyboard_RETURN                         // call the keyboard function
                            be settingsLoop keyboard_ready CONST_ZERO                   // if keyboard isn't ready for an option, branch back to settingsLoop


                            // TO-DO: implement the audio and difficulty screens
                            be initAudioLoop keyboard_ASCII CONST_ONE_KEYBOARD          // branches to initAudioLoop if 1 (toggle audio) is pressed
                            be initDifficultyLoop keyboard_ASCII CONST_TWO_KEYBOARD     // branches to initDifficultyLoop if 2 (toggle difficulty) is pressed

                            be backToMainScreen keyboard_ASCII CONST_THREE_KEYBOARD     // branches back to startLoop if 3 (return to main menu) is pressed

                            be settingsLoop CONST_ZERO CONST_ZERO                       // unconditionally loops back to settingsLoop


// goes back to main menu
backToMainScreen            call titleScreen titleScreen_returnAddress
                            cp currentScreen CONST_ZERO
                            be startLoop CONST_ZERO CONST_ZERO


// loads the settings (audio) menu
initAudioLoop               call settings_audio settings_audio_returnAddress            // paints the settings (audio) screen

audioLoop                   call keyboard_START keyboard_RETURN                         // calls the keyboard function
                            be audioLoop keyboard_ready CONST_ZERO                      // if keyboard isn't ready for an option, branch back to audioLoop

                            be audioOn keyboard_ASCII CONST_ONE_KEYBOARD                // turns audio on if user presses 1 (audio on)
                            be audioOff keyboard_ASCII CONST_TWO_KEYBOARD               // turns audio off if user presses 2 (audio off)
                            be backToSettings keyboard_ASCII CONST_THREE_KEYBOARD       // returns to settings menu

                            be audioLoop CONST_ZERO CONST_ZERO                          // unconditionally loops back to audioLoop

audioOn                     cp audio CONST_ONE                                          // turns audio on
                            call settings_audio settings_audio_returnAddress            // repaints the screen
                            be audioLoop CONST_ZERO CONST_ZERO                          // unconditionally branches back to audioLoop

audioOff                    cp audio CONST_ZERO                                         // turns audio off
                            call settings_audio settings_audio_returnAddress            // repaints the screen
                            be audioLoop CONST_ZERO CONST_ZERO                          // unconditionally branches back to audioLoop



// loads the settings (difficulty) menu
initDifficultyLoop          call settings_difficulty settings_difficulty_returnAddress  // paints the settings (difficulty) screen

difficultyLoop              call keyboard_START keyboard_RETURN                         // calls the keyboard function
                            be difficultyLoop keyboard_ready CONST_ZERO                 // if keyboard isn't ready for an option, branch back to difficultyLoop

                            be difficultyEasy keyboard_ASCII CONST_ONE_KEYBOARD         // sets difficulty to easy if user pressed 1 (difficulty easy)
                            be difficultyMedium keyboard_ASCII CONST_TWO_KEYBOARD       // sets difficulty to medium if user pressed 2 (difficulty medium)
                            be backToSettings keyboard_ASCII CONST_THREE_KEYBOARD       // returns to settings menu

                            be difficultyLoop CONST_ZERO CONST_ZERO                     // unconditionally branches to difficultyLoop

difficultyEasy              cp difficulty CONST_ZERO                                    // sets difficulty to easy
                            call settings_difficulty settings_difficulty_returnAddress  // repaints the screen
                            be difficultyLoop CONST_ZERO CONST_ZERO                     // unconditionally branches back to difficultyLoop

difficultyMedium            cp difficulty CONST_ONE                                     // sets difficulty to medium
                            call settings_difficulty settings_difficulty_returnAddress  // repaints the screen
                            be difficultyLoop CONST_ZERO CONST_ZERO                     // unconditionally branches back to difficultyLoop

backToSettings              be initSettingsScreen CONST_ZERO CONST_ZERO                 // unconditionally branches to settings menu