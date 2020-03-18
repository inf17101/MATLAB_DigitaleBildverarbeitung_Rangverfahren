function [InputPicture,SobelMatrix, GradientenMatrix] = Rangverfahren(input_file, index, threshold_rang, threshold_sobel, auto_threshold_activated)

if index == '1'
    stepwith = 2;
    padding = [1 1]; % inserting 1 line of zeros around matrix
elseif index == '2'
    stepwith = 4;
    padding = [2 2]; % inserting 2 lines of zeros around matrix
else
    stepwith = 6;
    padding = [3 3]; % inserting 3 lines of zeros around matrix
end

if auto_threshold_activated == 1
    nxn_dim = stepwith + 1;
    threshold_rang = 0.5 * (nxn_dim * nxn_dim + 1);
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
InputPicture = padarray(InputPicture, padding, 0); % insert padding of zeros around the matrix
InputPicture = double(InputPicture);

Sobel = fspecial('sobel');
SX = imfilter(InputPicture,Sobel);
SY = imfilter(InputPicture',Sobel)';
I = sqrt(SX.*SX + SY.*SY);
SobelMatrix = (I > threshold_sobel);
I2 = I;
GradientenMatrix = I;

[r, c] = size(I);

for q1=1:(r-stepwith)
    for p1=1:(c-stepwith)
        I = I2(q1:(q1+stepwith), p1:(p1+stepwith)); % nxn Umgebung %
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
n = padding(1);
GradientenMatrix = GradientenMatrix(n+1:end-n, n+1:end-n); % remove padding of zeros
GradientenMatrix = (GradientenMatrix >= threshold_rang);
end