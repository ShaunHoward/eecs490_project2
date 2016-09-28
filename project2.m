% read in unregistered image
unregistered = imread('pics/cantilever1_1.jpg');
%figure, imshow(unregistered)

% read in reference image
reference = imread('pics/cantilever_layout1.bmp');
%figure, imshow(reference)
 
%invoke MATLAB two image selection tool
%[movingPoints,fixedPoints] = cpselect(unregistered(:,:,1),reference, 'Wait', true);

ptsOriginal  = detectSURFFeatures(reference);
ptsDistorted = detectSURFFeatures(unregistered);
[featuresOriginal,validPtsOriginal] = extractFeatures(reference,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(unregistered,ptsDistorted);

index_pairs = matchFeatures(featuresOriginal,featuresDistorted);
matchedPtsOriginal  = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));
figure;
showMatchedFeatures(original,unregistered,matchedPtsOriginal,matchedPtsDistorted);
title('Matched SURF points,including outliers');

[tform,inlierPtsDistorted,inlierPtsOriginal] = ...
    estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,...
    'similarity');
figure;

showMatchedFeatures(reference,unregistered,...
    inlierPtsOriginal,inlierPtsDistorted);
title('Matched inlier points');

% % create affine transform from unregistered image to reference image
% tform = fitgeotrans(movingPoints,fixedPoints,'projective');
% 
% % apply affine transform on unregistered image to warp image
% warped = imwarp(unregistered, tform, 'OutputView', imref2d(size(reference)));
% 
% % compute MSE between the two
% [optimizer,metric] = imregconfig('multimodal');
% moving = rgb2gray(warped);
% fixed = rgb2gray(reference);
% 
% % attempt to register warper image with reference image using multimodal
% % registration optimization and similarity metric
% registered = imregister(moving, fixed, 'similarity', optimizer, metric);
% figure;
% imshowpair(registered,reference);

%determine transformation matrix between images
%mytform = cp2tform(input_points,base_points,'projective');

%transform images to match
%registered = imtransform(unregistered,mytform);

% use inverse mapping to transform image X into image U
% = tforminv(T,reference);