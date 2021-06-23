% function RAW_import_test_2

    % Function to test importing RAW images via imread
    
    % Daniel W. Dichter 2021-01-10
    
    %%
    
    clear
    clc
    
    %% User inputs
    
%     filename = 'IMG_3542.CR2';
%     filename = 'IMG_3543.CR2';
%     filename = 'IMG_3544.CR2';
%     filename = 'IMG_3545.CR2';
%     filename = 'IMG_3546.CR2';
%     filename = 'IMG_3547.CR2';
    filename = 'IMG_3548.CR2';

%     filename = 'IMG_3570_daylight.CR2';
%     filename = 'IMG_3571_tungsten.CR2';
    path = 'C:\Users\Admin\Desktop\hyperspectral_imaging\spectral_sensitivity\data_photos';
    modifiers = '-D -4 -j -t 0';
%     modifiers = '-D -4 -j';
        
    %% Load photos
    
    figure(4)
        clf
        set(gcf,'color','white')
        hold on

        RAW = imread([path '\' filename], 1); % 8-bit
%         RAW = imread([path '\' filename], 3); % 16-bit

        for cc = 1 : 3
           
            CC = RAW(:,:,cc);
            [counts, edges] = histcounts(CC(:), 100);
            centers = edges(1:end-1) + abs(diff(edges(1:2)))/2;
            
            % Suppress count at edges
            counts(1) = NaN;
            counts(end) = NaN;
            
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
        
        xlim([0 255])
%         xlim([2000 2600])
        grid on
        grid minor
        title(['\rm\fontsize{9}Histogram: ' regexprep(filename,'\_','\\_')])
    
% end


















































