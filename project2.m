% Register two images with SIFTFlow or manual registration, toggled by
% boolean below.
% author: Shaun Howard (smh150@case.edu)

% prompt user to use sift flow algorithm (1) or choose manual registration (0)
use_sift_flow = input('Please enter 1 to utilize SIFTFlow automatic registration or 0 to perform manual registration: ');

% set renderer to OpenGL
set(gcf,'renderer','OpenGL');

if use_sift_flow
    % first, cd to IAT toolbox directory and run the setup utility
    run('~/iat/iat_setup')
end

% add export fig utility to path
addpath('export_fig/');

% set resize dimensions of input images
dim = [256 256];

SIFTflowparams.alpha=0.01;
SIFTflowparams.d=0.1;
SIFTflowparams.gamma=0.001;
SIFTflowparams.nlevels=6;
SIFTflowparams.wsize=3;
SIFTflowparams.topwsize=10;
SIFTflowparams.nIterations=60;
patchsize = 8; % half of the window size for computing SIFT
gridspacing = 1; % sampling step

fixed_moving_fps = containers.Map;
fixed_moving_fps('pics/cantilever_layout1.bmp')={'pics/cantilever1_1.jpg', 'pics/cantilever1_2.jpg'};
fixed_moving_fps('pics/cantilever_layout1e.bmp')={'pics/cantilever1_1.jpg', 'pics/cantilever1_2.jpg'};
fixed_moving_fps('pics/cantilever_layout2.bmp')={'pics/cantilever2_1.jpg', 'pics/cantilever2_2.jpg'};
fixed_moving_fps('pics/cantilever_layout3.bmp')={'pics/cantilever3_1.jpg', 'pics/cantilever3_2.jpg'};
fixed_moving_fps('pics/cantilever_layout4.bmp')={'pics/cantilever4_1.jpg', 'pics/cantilever4_2.jpg'};
fixed_moving_fps('pics/cantilever_layout5.bmp')={'pics/cantilever5.jpg'};
fixed_moving_fps('pics/cantilever_layout6_1.bmp')={'pics/cantilever6.jpg'};
fixed_moving_fps('pics/cantilever_layout6_2.bmp')={'pics/cantilever6.jpg'};
fixed_moving_fps('pics/cantilever_layout7.bmp')={'pics/cantilever7.jpg'};
fixed_moving_fps('pics/corona_layout_1.bmp')={'pics/corona1.jpg'};
fixed_moving_fps('pics/corona_layout_2.bmp')={'pics/corona2.jpg'};

% set the total number of trials to be run
N_TRIALS=16;

counter = 1;
fm_keys = keys(fixed_moving_fps);
[len,~]=size(fm_keys);
error_list=zeros(N_TRIALS,5);
for key = fm_keys
    key = key{1};
    % read in reference image via path used as dictionary key
    fixed = imresize(imread(key), dim);
    unregistered_paths = fixed_moving_fps(key);
    n_unreg = size(unregistered_paths);
    n_unreg = n_unreg(2);
    i = 1;
    rmse=0;
    while i <= n_unreg
        % read in unregistered image from list of paths
        u_path = unregistered_paths{i};
        moving = imresize(imread(u_path), dim);
        display(sprintf('Registering image %d\n', counter));
        
        if use_sift_flow
            % use sift flow registration
            [sift_fixed,sift_moving,registered,gray_error,rgb_error,mse,r,xcorr]=...
                sift_flow(moving,fixed,patchsize,gridspacing,SIFTflowparams,@mse_fn);

            % plot results including registration error and save to files
            plot_sift_flow_results(fixed,moving,sift_fixed,sift_moving,registered,gray_error,rgb_error,xcorr,counter);
        else
            % use manual registration
            [warped,registered,gray_error,rgb_error,mse,moving_points,fixed_points,r,xcorr]=...
                manual_registration(moving,fixed,@mse_fn);
            
            % plot results including registration error and save to files
            plot_manual_registration_results(fixed,moving,warped,registered,gray_error,rgb_error,xcorr,counter);
        end
        % calculate rmse from mse and the coefficient of determination
        rmse = sqrt(mse);
        r2=r^2;
        % print mse, rmse, and correlation coefficient between both images
        display(sprintf('Mean Squared Error (MSE) for trial %d: %f',counter,mse))
        display(sprintf('Root-mean Squared Error (RMSE) for trial %d: %f',counter,rmse))
        display(sprintf('Correlation coefficient, r, for trial %d: %f',counter,r))
        display(sprintf('Coefficient of determination, rxr, for trial %d: %f\n',counter,r2))
        
        % write rmse, mse, correlation coefficient (r) and coefficient of determination (r^2) to list
        error_list(counter,:)=[counter;mse;rmse;r;r2];
                
        % close graphs for speed up
        close all
        
        i = i+1;
        counter = counter+1;
    end
end
error_table = table(error_list(:,1),error_list(:,2),error_list(:,3),error_list(:,4),error_list(:,5));
error_table.Properties.VariableNames={'trial','mse','rmse','r','rxr'};
if use_sift_flow
    err_out = 'sift';
else
    err_out = 'manual';
end
writetable(error_table, sprintf('output/%s_trial_errors.csv',err_out),'Delimiter',',');