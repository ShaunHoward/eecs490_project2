function [sift_fixed,sift_moving,gray_error,rgb_error]=sift_flow(moving, fixed, patchsize, gridspacing, SIFTflow_params)
% utilizes the Image Alignment Toolbox (IAT) to perform SIFT Flow

% convert images to grayscale and display sizes
fixed = rgb2gray(fixed);
size(fixed)
moving = rgb2gray(moving);
size(moving)

% perform sift on both fixed and moving images and convert to rgb
sift_fixed=iat_dense_sift(im2double(fixed),patchsize,gridspacing);
sift_fixed=iat_sift2rgb(sift_fixed);
sift_moving=iat_dense_sift(im2double(moving),patchsize,gridspacing); 
sift_moving=iat_sift2rgb(sift_moving);

% perform sift flow to determine transform between both images
[vx, vy, ~]=iat_SIFTflow(sift_fixed,sift_moving,SIFTflow_params);

% apply pixel warp transformation using obtained transform points from SIFT
% flow
moving_new = moving(patchsize/2+1:end-patchsize/2, patchsize/2+1:end-patchsize/2);
[warped_moving, support]=iat_pixel_warping(moving_new, vx, vy);
fixed_new=fixed(patchsize/2+1:end-patchsize/2, patchsize/2+1:end-patchsize/2);

% get gray and color error images
[~, gray_error] = iat_error2gray(fixed_new,warped_moving,support);
rgb_error=iat_error2rgb(uint8(fixed_new),uint8(warped_moving));

end