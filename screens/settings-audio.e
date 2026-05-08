
settings_audio_returnAddress    0

settings_audio                  cp clearScreen_color backgroundColor
                                call clearScreen clearScreen_returnAddress

                                cp drawString_stringAddress audioMenuTitle
                                cp drawString_startX audioMenuTitleXOffset
                                cp drawString_startY audioMenuTitleYOffset
                                call drawString drawString_returnAddress



                                cp drawString_stringAddress audioMenuStatusStr
                                cp drawString_startX audioMenuStatusStrXOffset
                                cp drawString_startY audioMenuStatusStrYOffset
                                call drawString drawString_returnAddress

                                be settings_audio_load_on audio CONST_ONE
                                be settings_audio_load_off audio CONST_ZERO


settings_audio_load_rest        cp drawString_stringAddress audioMenuOnStr
                                cp drawString_startX audioMenuOnStrXOffset
                                cp drawString_startY audioMenuOnStrYOffset
                                call drawString drawString_returnAddress 

                                cp drawString_stringAddress audioMenuOffStr
                                cp drawString_startX audioMenuOffStrXOffset
                                cp drawString_startY audioMenuOffStrYOffset
                                call drawString drawString_returnAddress



                                cp drawString_stringAddress returnToSettingsStr
                                cp drawString_startX returnSettingsXOffset
                                cp drawString_startY returnSettingsYOffset
                                call drawString drawString_returnAddress


                                ret settings_audio_returnAddress


settings_audio_load_on          cp drawString_stringAddress audioMenuStatusOnStr
                                cp drawString_startX audioMenuStatusOffOnXOffset
                                cp drawString_startY audioMenuStatusOffOnYOffset
                                call drawString drawString_returnAddress

                                be settings_audio_load_rest CONST_ZERO CONST_ZERO


settings_audio_load_off         cp drawString_stringAddress audioMenuStatusOffStr
                                cp drawString_startX audioMenuStatusOffOnXOffset
                                cp drawString_startY audioMenuStatusOffOnYOffset
                                call drawString drawString_returnAddress

                                be settings_audio_load_rest CONST_ZERO CONST_ZERO