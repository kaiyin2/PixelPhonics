
endScreen_returnAddress            0

endScreen                           cp clearScreen_color backgroundColor 
                                    call clearScreen clearScreen_returnAddress

                                    cp drawString_stringAddress gameOverText
                                    cp drawString_startX gameOverTextXOffset
                                    cp drawString_startY gameOverTextYOffset
                                    call drawString drawString_returnAddress

                                    cp drawString_stringAddress totalPointsText
                                    cp drawString_startX totalPointsTextXOffset
                                    cp drawString_startY totalPointsTextYOffset
                                    call drawString drawString_returnAddress

                                    cp drawString_stringAddress longestStreakText
                                    cp drawString_startX longestStreakTextXOffset
                                    cp drawString_startY longestStreakTextYOffset
                                    call drawString drawString_returnAddress


                                    cp drawString_stringAddress totalPointsNum
                                    cp drawString_startX totalPointsNumXOffset
                                    cp drawString_startY totalPointsNumYOffset
                                    call drawString drawString_returnAddress

                                    cp drawString_stringAddress longestStreakNum
                                    cp drawString_startX longestStreakNumXOffset
                                    cp drawString_startY longestStreakNumYOffset
                                    call drawString drawString_returnAddress


                                    cp drawString_stringAddress playAgainText
                                    cp drawString_startX playAgainTextXOffset
                                    cp drawString_startY playAgainTextYOffset
                                    call drawString drawString_returnAddress

                                    cp drawString_stringAddress exitText
                                    cp drawString_startX exitTextXOffset
                                    cp drawString_startY exitTextYOffset
                                    call drawString drawString_returnAddress

                                    ret endScreen_returnAddress