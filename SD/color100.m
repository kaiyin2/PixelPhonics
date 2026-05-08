% Convert standard-format (e.g., 24-bit true color) image file to a
% list (in row-major order) of E100 pixel colors (red in bits 23-19,
% green in bits 15-11, blue in bits 7-3).
%
% Written by John Dydo and Peter Chen.

function color100(filename)
    disp('==== E100 Color Image Converter ====');
    
    image_rgb = imread(filename);

    height = size(image_rgb,1);
    width = size(image_rgb,2);
    info = imfinfo(filename);
    % disp(info);

    if (info.BitDepth ~= 24 || ~strcmp(info.ColorType, 'truecolor') || size(image_rgb,3) ~= 3)
        disp(['ERROR: image format must be 24-bit true color']);
        return;
    end

    disp(['Input: ' filename ' width=' int2str(width) ' height=' int2str(height)]);

    % zero out the least-significant 3 bits of each R, G, B value
    image_rgb = bitand(image_rgb, 248);		% 248 = 0xf8
    imshow(image_rgb);

    % convert each R, G, B value to a 32-bit integer
    % red: bits 23:16
    % green: bits 15:8
    % blue: bits 7:0
    image_rgb32 = uint32(image_rgb);
    image_e100 = bitshift(image_rgb32(:,:,1),16) + bitshift(image_rgb32(:,:,2),8) + image_rgb32(:,:,3);

    % Output the E100 color values for the image to a binary data file
    % (suitable for the SD card) and to a .e file.  It outputs pixels in
    % the following order: start at the upper left, sweep across a row,
    % then go to the next row, eventually ending at the lower right corner
    % of the image.

    disp(['Writing binary and assembly files for this image.  This may take a few minutes...']);

    binfile = strcat(filename, '.bin' );
    binfid = fopen(binfile, 'w', 'l');    % 'l' specifies little endian byte order

    efile = strcat(filename, '.e');
    efid = fopen(efile, 'w');

    for y = 1 : height
        for x = 1 : width
            fwrite(binfid, image_e100(y,x) , 'uint32');
            fprintf(efid, '\t0x%x\n', image_e100(y,x));
        end
    end

    fclose(binfid);
    fclose(efid);

    disp(['Output: ' binfile ' and ' efile]);
end
