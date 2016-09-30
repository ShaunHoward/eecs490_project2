function [mse]=mse_fn(image1,image2)
    % calculate mean squared error (mse) between two grayscale images
    difference = single(image1) - single(image2);
    squared_error = difference .^ 2;
    mse = sum(squared_error(:)) / numel(image1);
end