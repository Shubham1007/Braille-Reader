clear all
clc
%A = imread(filename, fmt ) reads a greyscale or color image from the file specified by the string filename

%I = rgb2gray(RGB) converts the truecolor image RGB to the grayscale intensity image I. newmap = rgb2gray(map) returns a grayscale colormap equivalent to map.

I = rgb2gray(imread('braille301.jpg'));

%I = imrotate(I, -90);

%imshow(I)

%J = imadjust(I) maps the intensity values in grayscale image I to new values in J.
I2 = imadjust(I);

%figure
%imshow(I2)
%J = imcomplement(I) computes the complement of the image I.
%BW = imbinarize(I) creates a binary image from image I by replacing all values above a globally determined threshold with 1s and setting all other values to 0s.
bw = imcomplement(imbinarize(I2));

%bw = bwareaopen(bw, 50);
figure
%To display image data
imshow(bw)
%CC = bwconncomp(BW) returns the connected components CC found in the binary image BW. bwconncomp uses a default connectivity of 8 for two dimensions, 26 for three dimensions, and conndef(ndims(BW),'maximal') for higher dimensions.
cc = bwconncomp(bw);
%This MATLAB function creates a label matrix, L, from the connected components structure CC returned by bwconncomp.

labeled = labelmatrix(cc);
%size find size of labled 
[my, mx] = size(labeled);

figure
%display the image 
imshow(I)
A = labeled;
C = A;
%This MATLAB function returns measurements for the set of properties specified by properties for each 8-connected component (object) in the binary image, BW.
graindata = regionprops(cc,'basic');
%Extract the X field from the structure and examine the format of the returned values. All values have the same numeric data type ( double ),
areas = extractfield(graindata, 'Area');
%mean of areas
area = mean(areas);
%sqrt of area/pi
radius = sqrt(area/pi);

ap = [];
bp = [];

lastRow = 0;
currRow = 0;
count = 0;
ar = {};
arn = 1;
ar2 = [];
for i = 1:my
    currRow = 0;
    for j = 1:mx
        cell = A(i, j);
        if cell ~= 0
            currRow = 1;
            flag = 0;
            for k = 1:length(ar2)
                if ar2(k) == cell
                    flag = 1;
                    break;
                end
            end
            if flag == 0
                ar2 = [ar2, cell];
            end
            C(i, j) = 1;
        else
            C(i, j) = 0;
        end
    end
    
    if (currRow == 1) && (lastRow == 0)
        line([0 mx], [i+radius i+radius])
        count = count+1;
        ar{arn} = ar2;
        arn = arn+1;
        ar2 = [];
        ap = [ap, uint64(i+radius)];
    end
    lastRow = currRow;
end
% transpose of matrix A
B = transpose(A);

lastRow = 0;
currRow = 0;
count = 0;
br = {};
brn = 1;
br2 = [];
for i = 1:mx
    currRow = 0;
    for j = 1:my
        cell = B(i, j);
        if cell ~= 0
            currRow = 1;
            flag = 0;
            for k = 1:length(br2)
                if br2(k) == cell
                    flag = 1;
                    break;
                end
            end
            if flag == 0
                br2 = [br2, cell];
            end
        end
    end
    
    if (currRow == 1) && (lastRow == 0)
        line([i+radius i+radius], [0 my])
        count = count+1;
        br{brn} = br2;
        brn = brn+1;
        br2 = [];
        bp = [bp, uint64(i+radius)];
    end
    lastRow = currRow;
end

count2 = 0;
for i = 1:length(ar)
    for j = 1:length(ar{i})
        count2 = count2 + 1;
        k = ar{i}(j);
        
    end
end
%C(ap, bp(5))
String = '';
flag = 0;
for i=1:3:size(ap, 2)-3
    for j=1:2:size(bp, 2)-2
        k = getBraille(C(ap(i), bp(j)), C(ap(i+1), bp(j)), C(ap(i+2), bp(j)), C(ap(i), bp(j+1)), C(ap(i+1), bp(j+1)), C(ap(i+2), bp(j+1)));
        if k == 2
            flag = 1;
        elseif k == 3
            flag = 2;
        elseif flag == 1
            String = strcat(String, upper(k));
            flag = 0;
        else
            String = [String k];
        end
    end
    String = [String char(13)];
end
disp(String)