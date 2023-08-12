%input: imgtest.bmp
%This will calculate the angle between the edge and horizontal axis (assume
%turn right)
I = imread('testcorner.png');
I = I(170:210,140:195,:);
%I = flip(I,2);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 0.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 255.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

BW = sliderBW;
%find edge
BW = edge(BW,"canny");
%find line
[H, theta, rho] = hough(BW);
P = houghpeaks(H, 2, 'Threshold',ceil(0.05*max(H(:)))); %detect 2 lines maximum

lines = houghlines(BW,theta, rho, P);

%get angle
l = abs(lines(1).point2(2)-lines(1).point1(2));
d = sqrt((lines(1).point1(1)-lines(1).point2(1))^2+(lines(1).point1(2)-lines(1).point2(2))^2);
theta = acos(l/d);
if lines(1).point1(1) < lines(1).point2(1)
    theta = -theta;
end
%imshow(BW);

%plot line
figure, imshow(BW), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end

%find corner
%points = detectHarrisFeatures(BW);
%imshow(I); hold on;
%plot(points.selectStrongest(4));
