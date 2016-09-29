 function plot_sift_flow_results(sift_fixed,sift_moving,gray_error,rgb_error, counter)
    % plot results with subplot tight without spaces between images
    margins=[0 0];
    f=figure('name', sprintf('SIFTFlow Trial %d Results with Error', counter));
    subplot_tight(2,2,1,margins);
    imshow(sift_fixed);
    subplot_tight(2,2,2,margins);
    imshow(sift_moving);
    subplot_tight(2,2,3,margins);
    imshow(gray_error,[0 255]);
    subplot_tight(2,2,4,margins);
    imshow(rgb_error);
    % export subplot figure as bmp image
    output_path = sprintf('output/sift_flow_trial_%d.bmp', counter);
    export_fig(output_path);
end