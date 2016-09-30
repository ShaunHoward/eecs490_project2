function [warped,registered,gray_error,rgb_error,mse,moving_points,fixed_points,r,xcorr]=...
    manual_registration(moving,fixed,mse_fn)
    % Registers two images using both a geometric and intensity-based
    % transformation.
    % Allows user to manually select points on both input images,
    % then determines an affine transform between the two images.
    % Proceeding, it warps the moving image with the transform
    % and utilizes a multimodal imregconfig to register the moving and fixed
    % images using imregister's intensity-based "Similarity" metric.
    % Outputs warped, registered,gray and rgb error images, mean-squared error
    % of registration,selected points in moving image, selected points in 
    % fixed image, the correlation coefficient of registration and
    % the normalized cross-correlation matrix of registration results.
    % author: Shaun Howard (smh150@case.edu)

    %invoke MATLAB two image selection tool
    [moving_points,fixed_points] = cpselect(moving(:,:,1),fixed, 'Wait', true);

    % create affine transform from unregistered image to reference image
    tform = fitgeotrans(moving_points,fixed_points,'affine');

    % apply affine transform on unregistered image to warp image
    warped = imwarp(moving, tform, 'OutputView', imref2d(size(fixed)));

    [optimizer,metric] = imregconfig('Multimodal');

    % convert images from rgb to grayscale for registration
    moving = rgb2gray(warped);
    fixed = rgb2gray(fixed);

    % attempt to register warped image with reference image using multimodal
    % registration optimization and similarity metric (not always
    % necessary)
    registered = imregister(moving, fixed, 'Similarity', optimizer, metric);
    
    % get gray and color error images
    [~, gray_error] = iat_error2gray(fixed,registered);
    rgb_error=iat_error2rgb(fixed,registered);
    
    % correct gray error format
    gray_error=uint8(gray_error);
    
    % calculate mse
    mse=mse_fn(fixed,registered);
    % calculate correlation coefficient
    r=corr2(fixed,registered);
    % calculate normalized cross-correlation coefficient
    xcorr=normxcorr2_general(fixed,registered);
end