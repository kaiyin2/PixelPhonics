
titleScreen_returnAddress   0

titleScreen                 cp clearScreen_color backgroundColor
                            call clearScreen clearScreen_returnAddress

                            cp drawString_stringAddress logo
                            cp drawString_startX logoXOffset
                            cp drawString_startY logoYOffset
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress playStr
                            cp drawString_startX playXOffset
                            cp drawString_startY playYOffset
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress settingsStr
                            cp drawString_startX settingsXOffset
                            cp drawString_startY settingsYOffset
                            call drawString drawString_returnAddress

                            cp drawString_stringAddress descriptionStr
                            cp drawString_startX descriptionXOffset
                            cp drawString_startY descriptionYOffset
                            call drawString drawString_returnAddress

                            ret titleScreen_returnAddress