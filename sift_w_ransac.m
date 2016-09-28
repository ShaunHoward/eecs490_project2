function [ transform ] = sift_w_ransac(img1,img2,ransac_coeff)
% NOTE: img1 should be smaller that img2

% add SIFT and RANSAC helper functions to path
addpath('./sift_w_ransac/');

% use SIFT to find corresponding points
[matchLoc1 matchLoc2] = siftMatch(img1, img2);

% use RANSAC to find homography matrix
[H corrPtIdx] = findHomography(matchLoc2',matchLoc1',ransac_coeff);
H  %#ok
transform = maketform('projective',H');

