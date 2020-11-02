% function resize_images

    clear
    clc
    
    %%
    
    max_dim = 2000; % px

    path = 'C:\Users\Daniel\Desktop\hyperspectral_imaging\photos';
    fn = {
        'IMG_2307.JPG'
%             'IMG_2500.JPG'
%             'IMG_2577.JPG'
%             'IMG_2468.JPG'
%             'IMG_2406.JPG'
%             'IMG_2595.JPG'
%             'IMG_2454.JPG'
%             'IMG_2620.JPG'
%             'IMG_2589.JPG'
%             'IMG_2564.JPG'
%             'IMG_2719.JPG'
%             'IMG_2740.JPG'
%             'IMG_2763.JPG'
         };
     
    %%
     
    for p = 1 : length(fn)
        
        disp(fn{p})
        
        I = imread([path '\' fn{p}]);
        
        scale = max_dim / max(size(I));
        
        if scale > 1
            continue
        else
            I_ = imresize(I, scale);
            fn_export = regexprep(fn{p}, '\.', ['_resized_' num2str(max_dim) '_px.']);
            imwrite(I_, [path '\' fn_export])
        end
        
    end

% end