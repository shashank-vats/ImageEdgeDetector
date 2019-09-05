% Companion matlab script with Sobel.s

% Part of the script is to be run before running Sobel.s
% and the other part after after running Sobel.s

% To be run before Sobel.s %
M = imread('butterfly.jpg');   % Change img.jpg with the image name
M = rgb2gray(M);         % This step is required only when image is not rgb.
fileId = fopen('input.txt', 'w'); % opens input.txt in write mode
sz = size(M);
l = sz(1);
b = sz(2);
fprintf(fileId, '%d %d\n', l, b);     % prints length and breadth of matrix in the file
fprintf(fileId, [repmat('%d\t', 1, size(M, 2)) '\n'], M'); % prints the matrix into the file
fclose(fileId);

% To be run after running Sobel.s %
% im = load('output.txt');  % loads the matrix in output.txt
% imshow(im, [0 255])       % shows the image

