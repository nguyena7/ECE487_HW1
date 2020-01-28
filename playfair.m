clear all; close all; clc;

keyword = input("Enter the KEYWORD: ", 's');
keyword = convertCharsToStrings(keyword);
%keyword = "CINCINNATI"
message = "A TEST TO ENCRYPT USING PLAYFAIR CIPHER";

% Prepare message for encryption
nospace = no_space(message);
nodups = check_dups(nospace);
split = get_pairs(nodups)';
nodup = remove_dup(keyword);

% Create matrix
mat = make_matrix(nodup);

% Encrypt message
encrypted_message = encrypt(mat, split);

% Prepare for message decryption
enc_splitted = get_pairs(encrypted_message)';

% Decrypt message
decrypted_message = decrypt(mat, enc_splitted);
decrypted_message = erase(decrypted_message, "X"); % Remove X in message

% Display output
disp("Playfair Matrix:");
disp(mat);

disp("Original Message:");
disp(message);

disp("Encrypted Message:");
disp(encrypted_message);

disp("Decrypted Message:");
disp(decrypted_message);

%% Break string into pairs
function split_txt = get_pairs(plain_txt)
    split_txt = "";
    for i = 1:strlength(plain_txt)
        if i == 1
            split_txt = append(split_txt, plain_txt{1}(i));
        elseif mod(i-1, 2) ~= 0
            split_txt = append(split_txt, plain_txt{1}(i));
        else
            split_txt = append(split_txt, ' ');
            split_txt = append(split_txt, plain_txt{1}(i));
        end
    end 
    split_txt = split(split_txt);
end

%% Removing spaces from a string
function str = no_space(message)
    str = regexprep(message, '\s+', '');
end

%% Add X's for duplicates or odd numbered strings
function padded = check_dups(message)
    padded = "";
    for i = 1:strlength(message)
        if i == strlength(message)
            curr_char = message{1}(i);
            padded = append(padded, curr_char);   
            if mod(strlength(padded), 2 )~= 0
                padded = append(padded, 'X');
            end
        elseif i ~= strlength(message)
            curr_char = message{1}(i);
            next_char = message{1}(i+1);

            if(curr_char == next_char)
                padded = append(padded, curr_char);
                padded = append(padded, 'X');
            else
                padded = append(padded, curr_char);
            end
        end
    end
end

%% Remove duplicate characters from keyword
function uniq_str = remove_dup(str)
    uniq_str = "";
    for i = 1:strlength(str)
        if contains(uniq_str, str{1}(i)) == 0
            uniq_str = append(uniq_str, str{1}(i));
        end
    end
end

%% Making the 5x5 matrix
function matrix = make_matrix(kw)
    mat_str = kw; 
    alph = 'A':'Z';
    alph(find(alph == 'J')) = []; % Remove J from alphabet

    % combining the keyword and the alphabet to insert into matrix
    for i = 1:strlength(alph)
        if contains(kw, alph(i)) == 0
            mat_str = append(mat_str, alph(i));
        end
    end
    
    matrix = strings(5);
    index = 1;
    for row = 1:5   
        for col = 1:5
            %matrix(row, col) = str2arr(index);
            matrix(row, col) = mat_str{1}(index);
            index = index + 1;
        end
    end
end

%% Encrypting the message
function enc_message = encrypt(matrix, plaintext)
    enc_message = "";
    for i = 1:length(plaintext)
        char1 = plaintext{i}(1);
        char2 = plaintext{i}(2);
        
        if char1 == "J"
            char1 = "I";
        elseif char2 == "J"
            char2 = "I";
        end
        
        [row1, col1] = find(matrix == char1);
        [row2, col2] = find(matrix == char2);
        
         if row1 == row2
            enc_message = append(enc_message, matrix(row1, mod(col1, 5) + 1));
            enc_message = append(enc_message, matrix(row2, mod(col2, 5) + 1));
         elseif col1 == col2
            enc_message = append(enc_message, matrix(mod(row1, 5) + 1, col1));
            enc_message = append(enc_message, matrix(mod(row2, 5) + 1, col2));
         else
            enc_message = append(enc_message, matrix(row1, col2));
            enc_message = append(enc_message, matrix(row2, col1));
         end
    end
end

%% Decrypting the message
function denc_message = decrypt(matrix, message)
    denc_message = "";
    for i = 1:length(message)
        char1 = message{i}(1);
        char2 = message{i}(2);
        
        if char1 == "J"
            char1 = "I";
        elseif char2 == "J"
            char2 = "I";
        end
        
        [row1, col1] = find(matrix == char1);
        [row2, col2] = find(matrix == char2);
        
         if row1 == row2
            a = mod(col1 - 1, 5);
            if a == 0
                a = 5;
            end
            b = mod(col2 - 1, 5);
            if b == 0
                b = 5;
            end
            
            denc_message = append(denc_message, matrix(row1, a));
            denc_message = append(denc_message, matrix(row2, b));
         elseif col1 == col2
            a = mod(row1 - 1, 5);
            if a == 0
                a = 5;
            end
            b = mod(row2 - 1, 5);
            if b == 0
                b = 5;
            end
            denc_message = append(denc_message, matrix(a, col1));
            denc_message = append(denc_message, matrix(b, col2));
         else
            denc_message = append(denc_message, matrix(row1, col2));
            denc_message = append(denc_message, matrix(row2, col1));
         end
    end
end
