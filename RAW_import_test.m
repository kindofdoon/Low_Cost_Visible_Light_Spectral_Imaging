% function RAW_import_test

    % Function to test importing RAW images via dcraw
    
    % Daniel W. Dichter 2021-01-10
    
    %%
    
    clear
    clc
    
    %% User inputs
    
    filename = 'IMG_3542.CR2';
%     filename = 'IMG_3543.CR2';
%     filename = 'IMG_3544.CR2';
%     filename = 'IMG_3545.CR2';
%     filename = 'IMG_3546.CR2';
%     filename = 'IMG_3547.CR2';
%     filename = 'IMG_3548.CR2';
    path = 'C:\Users\Admin\Desktop\hyperspectral_imaging\spectral_sensitivity\data_photos';
    modifiers = '-D -4 -j -t 0';
%     modifiers = '-D -4 -j';
        
    %% Load photos
    
    figure(4)
        clf
        set(gcf,'color','white')
        hold on

        [~, RAW, ~] = extract_RAW_via_dcraw(path, filename, 'rggb', modifiers, 0, 0, 0);

%         RAW = double(RAW) ./ (2^14-1);
        
        for cc = 1 : 3
           
            CC = RAW(:,:,cc);
            [counts, edges] = histcounts(CC(:), 100);
            centers = edges(1:end-1) + abs(diff(edges(1:2)))/2;
            
            switch cc
                case 1
                    col = 'r';
                case 2
                    col = 'g';
                case 3
                    col = 'b';
            end
            
            plot(centers, counts, [col '-'])
            drawnow
            
        end 
        
%         xlim([0 1])
        grid on
        grid minor
        title(['\rm\fontsize{9}Histogram: ' regexprep(filename,'\_','\\_')])
    
% end


















































