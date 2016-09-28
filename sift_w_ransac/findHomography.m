function [H corrPtIdx] = findHomography(pts1,pts2,ransac_coeff)
% [H corrPtIdx] = findHomography(pts1,pts2,ransac_coeff)
%	Find the homography between two planes using a set of corresponding
%	points. PTS1 = [x1,x2,...;y1,y2,...]. RANSAC method is used.
%	corrPtIdx is the indices of inliers.
%   Uses ransac coefficient for running ransac1 algorithm, refer to file for coeff
%   definition.

[H corrPtIdx] = ransac1(pts1,pts2,ransac_coeff,@solveHomo,@calcDist);

end

function d = calcDist(H,pts1,pts2)
%	Project PTS1 to PTS3 using H, then calcultate the distances between
%	PTS2 and PTS3

n = size(pts1,2);
pts1
n
pts2
pts3 = H*[pts1;ones(1,n)];
pts3 = pts3(1:2,:)./repmat(pts3(3,:),2,1);
d = sum((pts2-pts3).^2,1);

end