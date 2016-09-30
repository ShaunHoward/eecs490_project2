function [sift_fixed,sift_moving,registered,gray_error,rgb_error,mse,r,xcorr]=...
    sift_flow(moving,fixed,patchsize,gridspacing,SIFTflow_params,mse_fn)
    % utilizes the Image Alignment Toolbox (IAT) to perform SIFT Flow
    % works best when images are of the same size
    % Returns SIFT fixed and moving images, registered image, gray and rgb
    % error images, mean-squared error of registration, the correlation
    % coefficient of registration and the normalized cross-correlation 
    % matrix of the image registration.

    % convert images to grayscale
    fixed = rgb2gray(fixed);
    moving = rgb2gray(moving);
    
    % perform sift on both fixed and moving images and convert to rgb
    sift_fixed=iat_dense_sift(im2double(fixed),patchsize,gridspacing);
    sift_fixed=iat_sift2rgb(sift_fixed);
    sift_moving=iat_dense_sift(im2double(moving),patchsize,gridspacing); 
    sift_moving=iat_sift2rgb(sift_moving);

    % perform sift flow to determine transform between both images
    [vx, vy, ~]=iat_SIFTflow(sift_fixed,sift_moving,SIFTflow_params);

    % apply pixel warp transformation using obtained transform points from SIFT
    % flow
    moving_rounded = moving(patchsize/2+1:end-patchsize/2, patchsize/2+1:end-patchsize/2);
    [registered, support]=iat_pixel_warping(moving_rounded, vx, vy);
    fixed_rounded=fixed(patchsize/2+1:end-patchsize/2, patchsize/2+1:end-patchsize/2);

    % get gray and color error images
    [~, gray_error] = iat_error2gray(fixed_rounded,registered,support);
    rgb_error=iat_error2rgb(uint8(fixed_rounded),uint8(registered));
    
    % correct formatting on registered and gray error images
    gray_error=uint8(gray_error);
    registered=uint8(registered);
    
    % calculate mse
    mse=mse_fn(fixed_rounded,registered);
    % calculate correlation coefficient
    r=corr2(fixed_rounded,registered);
    % calculate normalized cross-correlation
    xcorr=normxcorr2_general(fixed_rounded,registered);
end