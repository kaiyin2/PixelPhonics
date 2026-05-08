#include <cctype>
#include <fstream>
#include <iostream>
#include <string>
#include "letters.hpp"
#include <cmath>
#include <cassert>

const int TRANSPARENT = -1;
const int PIXELS_PER_WORD = 8;
const int CHARACTER_COUNT = 26;
const int BITS_PER_PIXEL = 32 / PIXELS_PER_WORD;

const unsigned int ALPHA_MASK = 0xFF000000;
const unsigned int RED_MASK = 0x00FF0000;
const unsigned int BLUE_MASK = 0x0000FF00;
const unsigned int GREEN_MASK = 0x000000FF;

const unsigned int MAX = 0xFFFFFFFF;

const int IMAGE_WIDTH = 384;
const int IMAGE_HEIGHT = 216;

// 6 of each difficulty
std::string names[] = {
    // easy
    "ice", "sled", "drum", "ruler", 
    "snake", "grapes",  
    //medium
    "airplane", "elephant", "newspaper", 
    "scissors", "strawberry", "umbrella"
};
// bottle not used

const bool SD = true;

int main(int argc, char** argv){
    if (!SD && argc != 3) {
        std::cout << "give a file AND a name for a output\n";
        return 1;
    }

    if (SD && argc != 2){
        std::cout << "trying to generate sd card data. specify output name.\n";
        return 1;
    }


    std::string inName;
    std::string outName;

    if (SD) {
        outName = argv[1];
    }else{
        outName = argv[2];
        inName = argv[1]; 
    }

    if (SD){
        auto data = consumeAllImages();

        genSDCardImage(outName + ".bin", data);

        return 0;
    }

    std::ifstream ppmFile(inName);

    std::string del;
    std::size_t width;
    std::size_t height;

    ppmFile >> del >> width >> height >> del;

    std::cout << "original width: " << width << '\n';
    std::cout << "original height: " << height << '\n';

    Data img{width, height, nullptr};
    img.data = new int[width * height];


    for (std::size_t i = 0; i < width; ++i){
        for (std::size_t j = 0; j < height; ++j){
        Pixel p = extractNextPixel(ppmFile);

            unsigned int value = transformPixelIntoInt(p);

            img.data[i * height + j] = value;

/*            int cutoff = 100;

            if (p.r > cutoff && p.g > cutoff && p.b > cutoff) {
                int colorValue = TRANSPARENT;


                img.data[i * height + j] = colorValue;
            }else {

                img.data[i * height + j] = 0;
            }*/

            //this is row major cuz the file format is row major
        }
    }

    auto trimmed = trimArray(&img);
    
    genE100Array(trimmed->width, trimmed->height, trimmed->data, outName, true);

    destroyData(trimmed);
    delete[] img.data;
}

ImageArray consumeAllImages(){
    ImageArray imageArray;

    int numImages = sizeof(names) / sizeof(std::string);
    std::cout << "Num images: " << numImages << std::endl;
    imageArray.numImages = numImages;
    imageArray.images = new Image[numImages];

    for (int i = 0; i < numImages; ++i){
        const std::string& name = names[i];

        std::ifstream in("images/" + name + "_crop.ppm");

        if (!in.is_open()) {
            std::cout << "File failed to open: " << name << '\n'; 
            continue;
        }else{
            std::cout << "opened " + name + "\n";
        }

        std::string del;
        int width;
        int height;

        in >> del >> width >> height >> del;


        assert(width == IMAGE_WIDTH);
        assert(height == IMAGE_HEIGHT);

        Image image = {nullptr, width, height, name};
        image.data = new unsigned int[width * height];


        for (int i = 0; i < width; ++i){
            for (int j = 0; j < height; ++j){
                Pixel p = extractNextPixel(in);

                auto val = transformPixelIntoInt(p);
                image.data[i * height + j] = val;
            }
        }

        imageArray.images[i] = image;
//        std::string tName = name + "testOut.ppm";
//        genPPM(width,height, tName, image.data);
    }

    return imageArray;
}

void genSDCardImage(const std::string& outName, ImageArray data){
    std::ofstream out(outName, std::ofstream::binary);

    /*
        FORMAT:   
        [1 word, integer use] [32 words, char use]           [384 * 216 words, color (int) use]
        wordStringLength      wordStringCharacterArray       imageData
    
        starts address 0, repeats every 1 + 32 + 384 * 216 words 
        (82,977 words long, meaning last word is on 82976)
        (331,908 bytes) = 332 KB

        the number of spelling words (units) will likely be hardcoded
        in the e100 asm for simplicity
     */


    const int UNIT_SIZE_WORDS = 1 + 32 + IMAGE_HEIGHT * IMAGE_WIDTH;
    const int UNIT_SIZE_BYTES = UNIT_SIZE_WORDS * 4;

    std::size_t dataLocationWORD = 0; // just for verification 

    auto outData = new unsigned int[data.numImages * UNIT_SIZE_WORDS];

    for (std::size_t i = 0; i < data.numImages; ++i){
        Image image = data.images[i]; 
        const char* name = image.name.c_str();
        unsigned int nameCopy[32];
        int nameLength = image.name.size();

        for (int i = 0; i < nameLength; ++i){
            nameCopy[i] = std::toupper(name[i]);
        }
        for (int i = nameLength; i < 32; ++i){
            nameCopy[i] = 'Z'; // see 'Z' = no good
        }

        out.write(reinterpret_cast<char*>(&nameLength), 
                    sizeof(unsigned int));
        ++dataLocationWORD;

        out.write(reinterpret_cast<char*>(nameCopy),
                sizeof(unsigned int) * 32);
        dataLocationWORD += 32;

        out.write(reinterpret_cast<char*>(image.data),
                sizeof(unsigned int) * IMAGE_HEIGHT * IMAGE_WIDTH);

        dataLocationWORD += IMAGE_HEIGHT * IMAGE_WIDTH;
        
        assert(dataLocationWORD % 82977 == 0);
    }

    out.close();

    delete[] outData;

    for (std::size_t i = 0; i < data.numImages; ++i){
        delete[] data.images[i].data;
    }
    delete[] data.images;
}

// first two numbers are width and height
void genE100Array(int width, int height, int* data, std::string name, bool isBlackWhite){
    std::ofstream e100(name);

    if (!isBlackWhite){
        for (int j = 0; j < height; ++j){
            for (int i = 0; i < width; ++i){
                
                int num = data[j * width + i];

                e100 << ' ' << num << '\n';
            }
        }
    } else {
        // requires width is multiple of PIXELS_PER_WORD
       
/* "                // fills side with transparent to remedy this 
                // filling bottom would be terrible cuz this row major " */
               
        // currently doesn't fill gotta do that later (maybe never)
        int needFilled = width % PIXELS_PER_WORD;
        if (needFilled != 0) std::cout << "non-8 multiple width\n";

        for (int j = 0; j < height; ++j){
            for (int i = 0; i < width / PIXELS_PER_WORD; ++i){
                int word = 0; 

                for (int k = 0; k < PIXELS_PER_WORD; ++k){
                    int num = data[i * PIXELS_PER_WORD + k + j * width];

                    if (num != MAX ){
                        num = calculateMagnitude(num, false);

                        // 8 bit to 4 bit
                        num /= 16;
                        num &= 0xF;

                        num <<= k * BITS_PER_PIXEL;
                    }else{
                        // important: for black and white, 0xF == transparent. 
                        // meaning bright things wont show up properly but this is probably
                        // irrelevant for this project

                        num = 0xF;

                        num <<= k * BITS_PER_PIXEL;
                    }

                    word |= num;
                }

                e100 << ' ' << word << '\n';
            }
        }
    }

}

unsigned int calculateMagnitude(unsigned int pixel, bool considerAlpha){
    unsigned int total = + pixel & RED_MASK + pixel& BLUE_MASK + pixel & GREEN_MASK;

    if (considerAlpha)
        return static_cast<double>(ALPHA_MASK) / 255.0 * total / 3;

    return total / 3;
}

void genPPM(int width, int height, std::string name, unsigned int* data){
    std::cout << "generating file with name " << name << std::endl;

    std::ofstream ppm(name);

    if (!ppm.is_open()) std::cout << "PPM FAILED TO OPEN: " << name << std::endl;

    ppm << "P3" << '\n' << width << ' ' << height << '\n' << 255 << '\n';

    for (std::size_t i = 0; i < width; ++i){
        for (std::size_t j = 0; j < height; ++j){
            int value = data[i * height + j];
            ppm << ((value & RED_MASK)>> 16) << ' ' << ((value & BLUE_MASK) >> 8) <<  ' ' << (value & GREEN_MASK) << ' ';
        }

        ppm << '\n';
    }
}


Pixel extractNextPixel(std::istream& f){
    int r,g,b;

    Pixel p;
    f >> p.r >> p.g >> p.b;
    if (f.eof()) return BAD_PIXEL;

    return p;
}

std::ostream& operator<<(std::ostream& o, Pixel& p){
    o << "Red: " << p.r << ", Green: " << p.g << ", Blue: " << p.b;

    return o;
}

Data* trimArray(Data* img){
    int xStart = -1;
    int yStart = -1;
    int xEnd = 0;
    int yEnd = 0;

    std::size_t height = img->height;
    std::size_t width = img->width;
    int* data = img->data;

    // ignores last rows so there is roughly an equal 
    // space on bottom/top so that things align 
    // i got 44 lines directly from the ppm
    // whole thing commented cuz i cropped it so it's
    // mutlple of 26
/*    for (std::size_t i = 0; i < height - 44; ++i){
        if (!rowIsEmpty(width, height, i, data)){
            if (yStart == -1) yStart = i;
            yEnd = i;
        }
        
    }*/
    yStart = 0;
    yEnd = height;

    for (std::size_t i = 0; i < width; ++i){
        if (!columnIsEmpty(width, height, i, data)) {
            if (xStart == -1) xStart = i;
            xEnd = i;
        }
    }

    std::size_t newWidth = xEnd - xStart;
    std::size_t newHeight = yEnd - yStart;

    int totalLength = newWidth * newHeight;
    auto newData = new int[totalLength]; 

    for (std::size_t i = 0; i < newWidth; ++i){
        for (std::size_t j = 0; j < newHeight; ++j){
            int newIndex = j * newWidth + i;
            int oldIndex = (j + yStart) * width + i + xStart;
            newData[newIndex] = data[oldIndex];
        }
    }


    std::cout << "newWidth: " << 
        newWidth << '\n' << 
        "newHeight: " << newHeight << '\n';

    if (newHeight % 36 != 0) std::cout << "Non 36 multiple height";

    auto D = new Data{newWidth, newHeight, newData};

    return D;
}

void destroyData(Data* d){
    delete[] d->data;
    delete d;
}

bool rowIsEmpty(int width, int height, int rowNum, int* data){
    for (std::size_t i = 0; i < width; ++i){
        if (data[rowNum * width + i] != TRANSPARENT)
            return false; 
    }

    return true;
}


bool columnIsEmpty(int width, int height, int colNum, int* data){
    for (std::size_t i = 0; i < height; ++i){
        if (data[colNum + i * width] != TRANSPARENT)
            return false; 
    }

    return true;
}

unsigned int transformPixelIntoInt(Pixel& p){
    unsigned int alpha = 0xFF << 24;
    int red = p.r << 16;
    int green = p.g << 8;
    int blue = p.b;

    return alpha + red + green + blue;
}
