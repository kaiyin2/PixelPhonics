
settings_returnAddress      0

settings                    cp clearScreen_color backgroundColor 
                            call clearScreen clearScreen_returnAddress

                            cp drawString_stringAddress settingsMenuTitle
                            cp drawString_startX settingsTitleXOffset
                            cp drawString_startY settingsTitleYOffset
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress changeAudioStr
                            cp drawString_startX changeAudioXO
                            cp drawString_startY changeAudioYO
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress changeDifficultyStr
                            cp drawString_startX changeDifficultyXO
                            cp drawString_startY changeDifficultyYO
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress settingsReturnStr
                            cp drawString_startX returnMainMenuXO
                            cp drawString_startY returnMainMenuYO
                            call drawString drawString_returnAddress

                            ret settings_returnAddress