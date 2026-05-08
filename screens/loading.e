
loading_screen_returnAddress 0

loading_screen              cp clearScreen_color backgroundColor
                            call clearScreen clearScreen_returnAddress

                            cp drawString_stringAddress welcomeText
                            cp drawString_startX welcomeTextXOffset
                            cp drawString_startY welcomeTextYOffset
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress loadingTitle
                            cp drawString_startX loadingTitleXOffset
                            cp drawString_startY loadingTitleYOffset
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress loadingSubtitle
                            cp drawString_startX loadingSubtitleXOffset
                            cp drawString_startY loadingSubtitleYOffset
                            call drawString drawString_returnAddress

                            ret loading_screen_returnAddress