clear all; close all; clc;
%% This program will embed 4 bits of the message into each pixel of the picture
%% You will need Communications Toolbox to run this program...sry

lena = imread('lena.png');
height = size(lena, 1);
width = size(lena, 2);
figure, imshow(lena);

msg = '101451472';

% Split msg digits 
split = num2cell(msg);
for i = 1 : size(split,2)
    temp = split{i}(1);
    new = str2num(temp);
    ID_arr(i) = new;
end

%% Embedding message in picture
disp("Message:");
disp(msg);
disp("Embedding the message into the picture");
ID_len = length(ID_arr);
output = lena;
pixel_count = 1;
for h = 1 : height
    for w = 1 : width
        if pixel_count <= ID_len
            % Get pixel's decimal value...
            dec = lena(h,w);
            % ... Convert to binary
            bin_pix = de2bi(dec,9);

            % Get ID digit
            temp = ID_arr(pixel_count);
            % Convert digit to binary
            bin_temp = de2bi(temp,4);

            % Embed into pixel
            bin_pix(1:4) = bin_temp;
            embedded = bin_pix;
            
            % Convert the binary to decimal
            embedded = bi2de(embedded);

            % Embed the new value into the output
            output(h, w) = embedded;

            % Increment pixel_cout
            pixel_count = pixel_count + 1;
        end
    end
end
figure, imshow(output);

%% Extracting message from output
disp("Extracting message");
decrypted_ID = zeros(1,9);
pixel_count = 1;
for h2 = 1 : height
    for w2 = 1 : width
        if pixel_count <= ID_len
            % Create new array to store extracted bits
            first_four = zeros(1,4);
            
            % Extracting pixel ...
            pix_dec = output(h2, w2);
            % ... Convert to binary
            bin_pix = de2bi(pix_dec,9);
            
            % Extract first 4 bits from pixel
            for pix_idx = 1:4 
                first_four(pix_idx) = bin_pix(pix_idx);
            end

            % Convert binary to string 
            first_four = num2str(first_four);
            first_four(isspace(first_four)) = '';
            
            % Flip the bits
            first_four = flip(first_four);
            
            % Convert the string binary to decimal
            decimal = bin2dec(first_four);
            
            % Store in array
            decrypted_ID(pixel_count) = decimal;
            
            % Increment pixel_cout
            pixel_count = pixel_count + 1;
        end
    end
end

disp("Extracted Message:");
disp(decrypted_ID);
