                // clear screen call
start           cp clearScreen_color backgroundColor
                call clearScreen clearScreen_returnAddress

     //           cp writeRectA_xStart three
    //            cp writeRectA_yStart three
   //             cp writeRectA_xEnd hund
  //              cp writeRectA_yEnd hund
 //               cp writeRectA_color testBlendValue
//                call writeRectA writeRectA_returnAddress

                cp drawString_stringAddress drawStringArray
                cp drawString_startX zero
                cp drawString_startY one
                call drawString drawString_returnAddress

//                cp drawString_stringAddress secondStringHalf
                cp drawString_startX zero
                cp drawString_startY sixtyFour
//                call drawString drawString_returnAddress

                cp drawString_stringAddress secondHalf
                cp drawString_startX zero
                cp drawString_startY oneTwentyEight
                call drawString drawString_returnAddress


//                cp writeRect_xStart oneTwentyEight
 //               cp writeRect_yStart sixtyFour
     //           cp writeRect_xEnd fiveTwelve
   //             cp writeRect_yEnd twoEighty
       //         cp writeRect_color black
         //       call writeRect writeRect_returnAddress

                
end             halt



drawStringArray drawStringArray
 'A'
 'B'
 'C'
 'D'
 'E'
 'F'
 'G'
 'H'
 'I'
 'J'
 'K'
 'L'
 'M'
 'N'
 'O'
 'P'
 'Q'
 'R'
 'S'
 'T'
 'U'
 'V'
 'W'
 'X'
 'Y'
 'Z'
  0

secondHalf secondHalf
 '0'
 '1'
 '2'
 '3'
 '4'
 '5'
 '6'
 '7'
 '8'
 '9'
  0


offset 0
three 3
two 2
four 4
twsix 26
testBlendValue 0x80ff0000
//==================================================
i 0
black 0
red 0xff0000


NOTICEABLE_NAME 0

// assume retrieved color has 0 alpha, since spec doesn't define it
backgroundColor 0xe8e8e0
ten 10
zero 0
hund 100
thirty 30
five 5
one 1
fifteen 0xf
fourtyFive 45
testMagValue -1

sixtyFour 64
oneTwentyEight 128
nintySix 96
fiveSevenSix 576
IMAGE_WIDTH 384
IMAGE_HEIGHT 216
thirtyTwo 32
threeTwoZero 320
threeTwelve 312
fourFourEight 448
twoEighty 280
fiveTwelve 512

#include vga_driver.e
