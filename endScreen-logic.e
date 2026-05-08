
initEndScreen               add tempVar_Points points ASCII_conversion
                            cpta tempVar_Points totalPointsNum CONST_ONE

                            add tempVar_longestStreak longestStreak ASCII_conversion
                            cpta tempVar_longestStreak longestStreakNum CONST_ONE

                            call endScreen endScreen_returnAddress                              // paints the end screen
                            

endScreenLoop               call keyboard_START keyboard_RETURN                                 // call the keyboard function
                            be endScreenLoop keyboard_ready CONST_ZERO                          // if keyboard isn't ready for an option, branch back to endScreenLoop

                            be initGame keyboard_ASCII CONST_ONE_KEYBOARD                       // branches to loadGame if 1 (play again) is pressed
                            be endScreenEnd keyboard_ASCII CONST_TWO_KEYBOARD                   // branches to endScreenEnd if 2 (exit) is pressed

                            be endScreenLoop CONST_ZERO CONST_ZERO                              // unconditionally loops back to endScreenLoop


endScreenEnd                halt



tempVar_Points              0
tempVar_longestStreak       0
ASCII_conversion            48
