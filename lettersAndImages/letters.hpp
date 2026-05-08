#pragma once
#include <fstream>

struct Pixel {
    int r;
    int g;
    int b;
};

struct Data {
    std::size_t width;
    std::size_t height;
    int* data;
};

struct Image{
    unsigned int* data;
    int width;
    int height;
    std::string name;
};

struct ImageArray{
    std::size_t numImages;
    Image* images;
};


const Pixel BAD_PIXEL = {-19348, 0, 0};


Pixel extractNextPixel(std::istream& f);


std::ostream& operator<<(std::ostream& o, Pixel& p);

void genPPM(int width, int height, std::string name, unsigned int* data);

void genE100Array(int width, int height, int* data, std::string name, bool isBlackWhite);


bool columnIsEmpty(int width, int height, int colNum, int* data);
bool rowIsEmpty(int width, int height, int rowNum, int* data);

Data* trimArray(Data* img);
void destroyData(Data* d);
unsigned int calculateMagnitude(unsigned int pixel, bool considerAlpha);
unsigned int transformPixelIntoInt(Pixel& p);
void genSDCardImage(const std::string& outName, ImageArray data);
ImageArray consumeAllImages();
