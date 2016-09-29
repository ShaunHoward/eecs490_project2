% Register two images with SIFTFlow

% first, cd to IAT toolbox directory and add it to path with setup utility
run('~/iat/iat_setup')

% add export fig utility to path
addpath('export_fig/')

% set dimensions of input images to be resized to
dim = [256 256];

SIFTflowparams.alpha=0.01;
SIFTflowparams.d=0.2;
SIFTflowparams.gamma=0.001;
SIFTflowparams.nlevels=4;
SIFTflowparams.wsize=3;
SIFTflowparams.topwsize=10;
SIFTflowparams.nIterations=60;
patchsize = 8; % half of the window size for computing SIFT
gridspacing = 1; % sampling step

fixed_moving_fps = containers.Map;
fixed_moving_fps('pics/cantilever_layout1.bmp')={'pics/cantilever1_1.jpg', 'pics/cantilever1_2.jpg'};
% fixed_moving_fps('pics/cantilever_layout2.bmp')={'pics/cantilever2_1.jpg', 'pics/cantilever2_2.jpg'};
% fixed_moving_fps('pics/cantilever_layout3.bmp')={'pics/cantilever3_1.jpg', 'pics/cantilever3_2.jpg'};
% fixed_moving_fps('pics/cantilever_layout4.bmp')={'pics/cantilever4_1.jpg', 'pics/cantilever4_2.jpg'};
% fixed_moving_fps('pics/cantilever_layout5.bmp')={'pics/cantilever5.jpg'};
% fixed_moving_fps('pics/cantilever_layout6_1.bmp')={'pics/cantilever6.jpg'};
% fixed_moving_fps('pics/cantilever_layout6_2.bmp')={'pics/cantilever6.jpg'};
% fixed_moving_fps('pics/cantilever_layout7.bmp')={'pics/cantilever7.jpg'};
% fixed_moving_fps('pics/corona_layout_1.bmp')={'pics/corona1.jpg'};
% fixed_moving_fps('pics/corona_layout_2.bmp')={'pics/corona2.jpg'};

counter = 1;
fm_keys = keys(fixed_moving_fps);
for key = fm_keys
    key = key{1};
    % read in reference image via path used as dictionary key
    fixed = imresize(imread(key), dim);
    unregistered_paths = fixed_moving_fps(key);
    n_unreg = size(unregistered_paths);
    n_unreg = n_unreg(2);
    i = 1;
    while i <= n_unreg
        % read in unregistered image from list of paths
        u_path = unregistered_paths{i};
        moving = imresize(imread(u_path), dim);
        
        % run sift flow
        [sift_fixed,sift_moving,gray_error,rgb_error]=...
            sift_flow(moving,fixed,patchsize,gridspacing,SIFTflowparams);
        
        % plot results including registration error and save to files
        plot_sift_flow_results(sift_fixed,sift_moving,gray_error,rgb_error, counter);
        
        i = i+1;
        counter = counter+1;
    end
end