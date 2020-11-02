function [I_raw, I_demosaic, I_preview] = extract_RAW_via_dcraw(path, filename, sensor_alignment, save_externally, calculate_preview, show_preview)

    % Wrapper to extract RAW images using dcraw with minimal processing;    
    % intended usage is to extract camera sensor data rather than images
    
    % Tested to work with dcraw v9.27
    % Tested on .CR2 and .CRW formats
    
    % OUTPUTS:
        % I_raw:            grayscale image of totally raw sensor data
        % I_demosaic:       16-bit color image after demosaic
        % I_preview:        8-bit color image with presumed value scaling
        
    % INPUTS:
        % path:             location of RAW file, e.g. 'C:\Users\jsmith\Desktop'
        % filename:         name of RAW file, e.g. 'CRW_1001.CRW'
        % sensor_alignment: Bayer filter pattern, one of one of: {'gbrg','grbg','bggr','rggb'}; see "demosaic" documentation for more
        % save_externally:  set to 1 to leave the .PGM as created by dcraw; by default it is deleted after it is read
        % show_result:      set to 1 to show I_preview
        
    % Daniel W. Dichter 2020-11-02
    % daniel.w.dichter@gmail.com
    
    %%

%     clear
%     clc
    
    %% Provide dummy inputs

%     path             = 'C:\Users\Daniel\Desktop\hyperspectral_imaging\photos';
%     filename         = 'CRW_4524.CRW';
%     sensor_alignment = 'rggb'; % one of: {'gbrg', 'grbg', 'bggr', 'rggb'}
%     save_externally  = 1; % set to 1 to create a .PGM image file
%     show_result      = 1;
    
    %% List of dcraw v9.27 modifiers
    
    % -v        Print verbose messages
    % -c        Write image data to standard output
    % -e        Extract embedded thumbnail image
    % -i        Identify files without decoding them
    % -i -v     Identify files and show metadata
    % -z        Change file dates to camera timestamp
    % -w        Use camera white balance, if possible
    % -a        Average the whole image for white balance
    % -A <x y w h> Average a grey box for white balance
    % -r <r g b g> Set custom white balance
    % +M/-M     Use/don't use an embedded color matrix
    % -C <r b>  Correct chromatic aberration
    % -P <file> Fix the dead pixels listed in this file
    % -K <file> Subtract dark frame (16-bit raw PGM)
    % -k <num>  Set the darkness level
    % -S <num>  Set the saturation level
    % -n <num>  Set threshold for wavelet denoising
    % -H [0-9]  Highlight mode (0=clip, 1=unclip, 2=blend, 3+=rebuild)
    % -t [0-7]  Flip image (0=none, 3=180, 5=90CCW, 6=90CW)
    % -o [0-6]  Output colorspace (raw,sRGB,Adobe,Wide,ProPhoto,XYZ,ACES)
    % -d        Document mode (no color, no interpolation)
    % -D        Document mode without scaling (totally raw)
    % -j        Don't stretch or rotate raw pixels
    % -W        Don't automatically brighten the image
    % -b <num>  Adjust brightness (default = 1.0)
    % -g <p ts> Set custom gamma curve (default = 2.222 4.5)
    % -q [0-3]  Set the interpolation quality
    % -h        Half-size color image (twice as fast as "-q 0")
    % -f        Interpolate RGGB as four colors
    % -m <num>  Apply a 3x3 median filter to R-G and B-G
    % -s [0..N-1] Select one raw image or "all" from each file
    % -6        Write 16-bit instead of 8-bit
    % -4        Linear 16-bit, same as "-6 -W -g 1 1"
    % -T        Write TIFF instead of PPM
    
    %% Initialize outputs
    
    %% Extract raw image
    
    [status,cmdout] = system(['dcraw -v -D -4 ' path '\' filename]);
    
    fn_temp = regexprep(filename, '\..+' ,'.pgm');
    I_raw = imread([path '\' fn_temp]);
    I_demosaic = demosaic(I_raw, sensor_alignment);
    
    if ~save_externally
        delete([path '\' fn_temp])
    end
    
    %% Calculate preview
    
    if ~calculate_preview
        I_preview = [];
        return
    end
    
    I_preview = double(I_demosaic);
    I_preview = I_preview ./ max(I_preview(:)); % 0 to 1
    
    % Calculate CDF to determine which portion of value range is actually in use
    I_gray = rgb2gray(I_preview);
    bin.edges = linspace(0, 1, 256);
    bin.width = abs(diff(bin.edges(1:2)));
    [bin.pop, ~, bin.ID] = histcounts(I_gray, bin.edges);
    bin.PDF = bin.pop ./ sum(bin.pop);
    bin.CDF = cumsum(bin.PDF);

    frac_sat_lo    = 0.01;
    frac_sat_hi    = 0.01;
    value_range(1) = 0.05;
    value_range(2) = 0.95;

    bin.ind_active = intersect(find(bin.CDF>frac_sat_lo), find(bin.CDF<(1-frac_sat_hi)));
    val_lim_active = [bin.edges(min(bin.ind_active)), bin.edges(max(bin.ind_active))] + bin.width/2;

    % Normalize values
    gamma = 1.0;
    I_preview = imadjust(I_preview, val_lim_active, value_range, gamma);
    
    I_preview = uint8(I_preview .* 255);
    I_preview(I_preview < 0) = 0;
    I_preview(I_preview > 255) = 255;
    
    %% Show preview
    
    if ~show_preview
        return
    end
    
    figure(33)
        clf
        set(gcf,'color','white')
        image(I_preview)
        axis equal
        axis tight
        drawnow

% end



















































