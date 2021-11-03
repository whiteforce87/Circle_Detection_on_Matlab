%%Reading File
a = 40; b=70; 
I = imread('coins.png');
imshow(I);
Ig = rgb2gray(I);
Ie = edge(Ig, 'canny'); 
imshow(Ie);
[j, i] = size(Ie);

%%Accumulator
Acc = zeros(j+2*b, i+2*b, b - a + 1);
AccSize = size(Acc);

%All possible r values from general circle formula
[Edge_y, Edge_x] = find(Ie); 
[x, y] = meshgrid(0:b*2, 0:b*2); 
r = round(sqrt((x - b).^2 + (y - b).^2)); 
r(r<a | r>b) = 0; 
[Center_y, Center_x, R] = find(r);

%%Voting  
for k = 1 : length(Edge_x) 
Votes = sub2ind(AccSize, Center_y+Edge_y(k) - 1, Center_x+Edge_x(k) - 1, R-a + 1);
 Acc(Votes) = Acc(Votes)+1; 
end

%%Finding Peaks
FindCircles = zeros(0,6);    
for rad = a : b 
  Peaks = Acc(:,:,rad-a + 1);  
  d = 2* pi * rad * 0.5;% 0,5 for the threshold 
  Peaks(Peaks<d) = 0;  
  [Y, X, all_rads] = find(Peaks); 
  FindCircles = [FindCircles; [(X - b), (Y - b), (rad*ones(length(X),1)), (all_rads/d)]]; 
end

%%Draw circles
for k=1:size(FindCircles,1)
    X = FindCircles(k,1)-FindCircles(k,3);
    Y = FindCircles(k,2)-FindCircles(k,3);
    R2 = 2*FindCircles(k,3);
    rectangle('Position', [X Y R2 R2], 'EdgeColor', 'blue', 'Curvature', [1,1]);
end
