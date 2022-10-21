function [ret] = ReadImage(filename)
    %scanner parameters
    f0 = 7.2;
    FOV = 5;
    decimation = floor(FOV)/2;

    im = rf_elegra(filename, 0,0,f0,decimation,4);

    % compute B-mode
    ret = log(10+abs(hilbert(im)));
    
    % downsample in axial direction
    ret = resample(ret,1,6);
end

