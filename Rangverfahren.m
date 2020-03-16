function [InputPicture,SobelMatrix, GradientenMatrix] = Rangverfahren(input_file, index, threshold_rang, threshold_sobel)
%clear;
%close all;

%index = input("Wähle eine Umgebung aus:\n [1] 3x3\n [2] 5x5\n [3] 7x7\n\n");

%while not(index>=1 && index<=3)
%    disp("Auswahl falsch. Eingaben von 1 bis 3 zulässig.");
%    index = input("Wähle eine Umgebung aus:\n [1] 3x3\n [2] 5x5\n [3] 7x7\n\n");
%end

if index == '1'
    stepwith = 2;
    %threshold = 5;
elseif index == '2'
    stepwith = 4;
    %threshold = 14;
else
    stepwith = 6;
    %threshold = 25;
end


%InputPicture = imread('Testbild_Kreis_100x100.png');
%InputPicture = imread('Testbild_Fuchs.png');
%[X,Y] = meshgrid([-2:0.01:2],[-2:0.01:2]);
%C = sqrt(X.*X + Y.*Y);
%E = 255./(1+exp((C-1)/0.05));
%InputPicture = (1+ 0.9*X).*E;
%InputPicture = imread('SternPic.png');
%InputPicture = imread('6EckPic.png');
%InputPicture = imread('Xpic600px.png');
%InputPicture = imread('PicTest600px.png');
%InputPicture = imread('ManyForms200px.png');
%InputPicture = imread('ManyForms600px.png');
%InputPicture = imread('Kreisfarbverlauf800px.png');
%InputPicture = imread('Kreisfarbverlauf2_800px.png');
%InputPicture = imread('SelbstmalKreis800px.png');
%InputPicture = imread('Kreis_NoSmooth20px.png');
%InputPicture = imread('GimpPicture.png');
%InputPicture = imread('ZugPic.png');
%InputPicture = imread('Gimp2.png');
InputPicture = imread(input_file);
[~, ~, dim3] = size(InputPicture);

if dim3 == 3
    InputPicture = rgb2gray(InputPicture);
end
%fone = figure(1);
%subplot(1, 2, 1);
%imshow(InputPicture, 'InitialMagnification', 'fit'); truesize; colormap gray; title('Original');
InputPicture = double(InputPicture);
%I = [ 1 8 4 10; 16 16 16 44; 3 2 2 13; 22 23 99 55;];
%I = [1 8 4; 15 16 12; 5 2 9;];

Sobel = fspecial('sobel');
SX = imfilter(InputPicture,Sobel);
SY = imfilter(InputPicture',Sobel)';
I = sqrt(SX.*SX + SY.*SY);
SobelMatrix = (I > threshold_sobel);
%imwrite(SobelMatrix, 'PictureResultSobel.png');
%fthree = figure(3);
%imshow(I); truesize; colormap gray; title('Sobel');
I2 = I;
GradientenMatrix = I;
%I

[r, c] = size(I);

for q1=1:(r-stepwith)
    for p1=1:(c-stepwith)
        I = I2(q1:(q1+stepwith), p1:(p1+stepwith)); % 3x3 Umgebung %
        %I
        LinVektor = reshape(I,1,[]);
        SortedVektor = sort(LinVektor);
        for i=1:length(SortedVektor)
            foundIndex = find(LinVektor == SortedVektor(i));
            if length(foundIndex) > 1
                foundIndexOfSortedVektor = find(SortedVektor == SortedVektor(i));
                middlePosition = fix((foundIndexOfSortedVektor(1) + foundIndexOfSortedVektor(end)) / 2);
                I(foundIndex) = middlePosition;
            else
            I(foundIndex) = i;
            end
        end
        GradientenMatrix(q1:(q1+stepwith), p1:(p1+stepwith)) = I;
    end
end
GradientenMatrix = (GradientenMatrix >= threshold_rang);
%two = figure(2);
%subplot(1, 2, 2);
%imshow(GradientenMatrix, 'InitialMagnification', 'fit'); truesize; colormap gray; title('Bild nach Rangverfahren');
%imwrite(GradientenMatrix, 'PictureResultRang.png');
end