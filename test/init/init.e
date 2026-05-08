
init_returnAddress          0

init                        call loadSDToRam loadSDToRam_returnAddress

// * remove this once we have real logic, this is to be called each
// time that the user needs to be shown a new word to spell 

  //                          cp useSDRAM_imageX IMAGE_OFFSET_X
 //                           cp useSDRAM_imageY IMAGE_OFFSET_Y
//                            call useSDRAM useSDRAM_returnAddress

                            ret init_returnAddress
