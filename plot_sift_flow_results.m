function plot_sift_flow_results(fixed,moving,sift_fixed,sift_moving,registered,gray_error,rgb_error,xcorr,counter)
    % plot results with subplot tight without spaces between images
    % author: Shaun Howard (smh150@case.edu)

    margins=[0 0];
    figure('name', sprintf('SIFTFlow Trial %d Results with Error', counter));
    subplot_tight(2,4,1,margins);
    imshow(fixed);
    subplot_tight(2,4,2,margins);
    imshow(moving);
    subplot_tight(2,4,3,margins);
    imshow(sift_fixed);
    subplot_tight(2,4,4,margins);
    imshow(sift_moving);
    subplot_tight(2,4,5,margins);
    imshow(registered);
    subplot_tight(2,4,6,margins);
    imshow(gray_error);
    subplot_tight(2,4,7,margins);
    imshow(rgb_error);
    
    % export subplot figure as bmp image
    output_path = sprintf('output/sift_flow_trial_%d.bmp', counter);
    export_fig(output_path);
    
    % plot normalized xcorr
    xcorr_size=size(xcorr);
    len=xcorr_size(1);
    width=xcorr_size(2);
    xcorr_title='Normalized Cross-Correlation between Images';
    figure('name', xcorr_title);
    [xx,yy]=meshgrid(1:len,1:width);
    m=mesh(xx,yy,xcorr);
    colorbar
    title(xcorr_title);
    
    % export the normalized cross-correlation
    output_path = sprintf('output/sift_flow_trial_%d_xcorr.bmp', counter);
    export_fig(output_path);
end