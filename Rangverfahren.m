function [InputPicture,SobelMatrix, RangMatrix] = Rangverfahren(input_file, index, threshold_rang, threshold_sobel, auto_threshold_activated, padding_type)

InputPicture = imread(input_file);
[~, ~, dim3] = size(InputPicture);

if dim3 == 3
    InputPicture = rgb2gray(InputPicture);
end

InputPicture = double(InputPicture); % cast to double matrix


Sobel = fspecial('sobel');
SX = imfilter(InputPicture,Sobel);
SY = imfilter(InputPicture',Sobel)';
GradientenMatrix = sqrt(SX.*SX + SY.*SY);
SobelMatrix = (GradientenMatrix > threshold_sobel);

if padding_type == 1
    [r, c] = size(GradientenMatrix);
    I_Periodic = [GradientenMatrix GradientenMatrix GradientenMatrix; GradientenMatrix GradientenMatrix GradientenMatrix; GradientenMatrix GradientenMatrix GradientenMatrix;]; % periodic continous picture
    [rPeriodic, cPeriodic] = size(I_Periodic);
end

if index == '1' % 3x3 surrounding
    stepwith = 2;
    padding = [1 1]; % 1 line to remove after periodic continous with 3x3
    if padding_type == 1
        GradientenMatrix = I_Periodic(r:rPeriodic-r+1,c:cPeriodic-c+1);
    end
elseif index == '2' %5x5 surrounding
    stepwith = 4;
    padding = [2 2]; % 2 lines to remove after periodic continous with 5x5
    if padding_type == 1
        GradientenMatrix = I_Periodic(r-1:rPeriodic-r+2,c-1:cPeriodic-c+2);
    end
else % 7x7 surrounding
    stepwith = 6;
    padding = [3 3]; % 3 lines to remove after periodic continous with 7x7
    if padding_type == 1
        GradientenMatrix = I_Periodic(r-2:rPeriodic-r+3,c-2:cPeriodic-c+3);
    end
end

if padding_type == 0
    GradientenMatrix = padarray(GradientenMatrix, padding, 0); % insert padding of zeros around the matrix
end

if auto_threshold_activated == 1
    nxn_dim = stepwith + 1;
    threshold_rang = 0.5 * (nxn_dim * nxn_dim + 1) + 1; % add 1 to optimal threshold value to prevent showing disturbing edges
end

I2 = GradientenMatrix;
RangMatrix = GradientenMatrix;
[r, c] = size(GradientenMatrix);
for q1=1:(r-stepwith)
    for p1=1:(c-stepwith)
        GradientenMatrix = I2(q1:(q1+stepwith), p1:(p1+stepwith)); % nxn Umgebung %
        LinVektor = reshape(GradientenMatrix,1,[]);
        SortedVektor = sort(LinVektor);
        for i=1:length(SortedVektor)
            foundIndex = find(LinVektor == SortedVektor(i));
            if length(foundIndex) > 1
                foundIndexOfSortedVektor = find(SortedVektor == SortedVektor(i));
                middlePosition = fix((foundIndexOfSortedVektor(1) + foundIndexOfSortedVektor(end)) / 2);
                GradientenMatrix(foundIndex) = middlePosition;
            else
            GradientenMatrix(foundIndex) = i;
            end
        end
        RangMatrix(q1:(q1+stepwith), p1:(p1+stepwith)) = GradientenMatrix;
    end
end
RangMatrix = RangMatrix(padding(1)+1:end-padding(1), padding(1)+1:end-padding(1)); % remove padding
RangMatrix = (RangMatrix >= threshold_rang);
end