function plot_manual_registration_results(fixed,moving,warped,registered,gray_error,rgb_error,xcorr,counter,write_output)
    % plot results with subplot tight without spaces between images
    % author: Shaun Howard (smh150@case.edu)

    margins=[0 0];
    figure('name', sprintf('Manual Registration Trial %d Results with Error', counter));
    subplot_tight(2,3,1,margins);
    imshow(fixed);
    subplot_tight(2,3,2,margins);
    imshow(moving);
    subplot_tight(2,3,3,margins);
    imshow(warped);
    subplot_tight(2,3,4,margins);
    imshow(registered);
    subplot_tight(2,3,5,margins);
    imshow(gray_error);
    subplot_tight(2,3,6,margins);
    imshowpair(rgb_error,fixed);
    
    if write_output
        % export subplot figure as bmp image
        output_path = sprintf('output/manual_registration_trial_%d.bmp', counter);
        export_fig(output_path);
    end
    
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
    
    if write_output
        % export the normalized cross-correlation
        output_path = sprintf('output/manual_registration_trial_%d_xcorr.bmp', counter);
        export_fig(output_path);
    end
end

