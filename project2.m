% read in unregistered image
unregistered = imread('pics/cantilever1_1.jpg');
%figure, imshow(unregistered)

% read in reference image
reference = imread('pics/cantilever_layout1.bmp');
%figure, imshow(reference)
 
%invoke MATLAB two image selection tool
[movingPoints,fixedPoints] = cpselect(unregistered(:,:,1),reference, 'Wait', true);

% create affine transform from unregistered image to reference image
tform = fitgeotrans(movingPoints,fixedPoints,'affine');

% apply affine transform on unregistered image to warp image
warped = imwarp(unregistered, tform, 'OutputView', imref2d(size(reference)));

[optimizer,metric] = imregconfig('Multimodal');
moving = rgb2gray(warped);
fixed = rgb2gray(reference);
% attempt to register warper image with reference image using multimodal
% registration optimization and similarity metric
registered = imregister(moving, fixed, 'Similarity', optimizer, metric);
figure;
imshowpair(registered,reference);

%determine transformation matrix between images
%mytform = cp2tform(input_points,base_points,'projective');

%transform images to match
%registered = imtransform(unregistered,mytform);

% use inverse mapping to transform image X into image U
% = tforminv(T,reference);