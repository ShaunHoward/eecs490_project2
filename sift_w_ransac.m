function [ transform ] = sift_w_ransac(img1,img2,nn2_nn1_ratio, ransac_coeff)
% NOTE: img1 should be smaller that img2

img1 = single(img1);
img2 = single(img2);

[F1 D1] = vl_sift(img1);
[F2 D2] = vl_sift(img2);

% Where 1.5 = ratio between euclidean distance of NN2/NN1
[matches score] = vl_ubcmatch(D1,D2,nn2_nn1_ratio); 
X1 = F1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
X2 = F2(1:2,matches(2,:)) ; X2(3,:) = 1 ;

subplot(1,2,1);
imshow(uint8(img1));
hold on;
plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'b*');

subplot(1,2,2);
imshow(uint8(img2));
hold on;
plot(F2(1,matches(2,:)),F2(2,matches(2,:)),'r*');


% add SIFT and RANSAC helper functions to path
addpath('./sift_w_ransac/');

% % use SIFT to find corresponding points
% [matchLoc1 matchLoc2] = siftMatch(img1, img2);
% 
% % use RANSAC to find homography matrix
[H corrPtIdx] = findHomography(X1',X2',ransac_coeff);
H  %#ok
transform = maketform('projective',H');

