
settings_difficulty_returnAddress   0

settings_difficulty                 cp clearScreen_color backgroundColor 
                                    call clearScreen clearScreen_returnAddress

                                    cp drawString_stringAddress difficultyMenuTitle
                                    cp drawString_startX difficultyMenuTitleXOffset
                                    cp drawString_startY difficultyMenuTitleYOffset
                                    call drawString drawString_returnAddress



                                    cp drawString_stringAddress difficultyMenuStatusStr
                                    cp drawString_startX difficultyMenuStatusXOffset
                                    cp drawString_startY difficultyMenuStatusYOffset
                                    call drawString drawString_returnAddress

                                    be settings_difficulty_load_easy difficulty CONST_ZERO
                                    be settings_difficulty_load_medium difficulty CONST_ONE


settings_difficulty_load_rest       cp drawString_stringAddress difficultyMenuEasyStr
                                    cp drawString_startX difficultyMenuEasyXOffset
                                    cp drawString_startY difficultyMenuEasyYOffset
                                    call drawString drawString_returnAddress

                                    cp drawString_stringAddress difficultyMenuMedStr
                                    cp drawString_startX difficultyMenuMedXOffset
                                    cp drawString_startY difficultyMenuMedYOffset
                                    call drawString drawString_returnAddress


                                    cp drawString_stringAddress returnToSettingsStr
                                    cp drawString_startX returnSettingsXOffset
                                    cp drawString_startY returnSettingsYOffset
                                    call drawString drawString_returnAddress


                                    ret settings_difficulty_returnAddress 


settings_difficulty_load_easy       cp drawString_stringAddress difficultyMenuStatusEasyStr
                                    cp drawString_startX difficultyMenuStatusEM_XOffset
                                    cp drawString_startY difficultyMenuStatusEM_YOffset
                                    call drawString drawString_returnAddress

                                    be settings_difficulty_load_rest CONST_ZERO CONST_ZERO


settings_difficulty_load_medium     cp drawString_stringAddress difficultyMenuStatusMediumStr
                                    cp drawString_startX difficultyMenuStatusEM_XOffset
                                    cp drawString_startY difficultyMenuStatusEM_YOffset
                                    call drawString drawString_returnAddress
                                    
                                    be settings_difficulty_load_rest CONST_ZERO CONST_ZERO