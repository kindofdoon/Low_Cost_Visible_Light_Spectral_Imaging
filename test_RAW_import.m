% function test_RAW_import

    %%
    
    clear
    clc
    
    %%

    path     = 'C:\Users\Admin\Desktop\hyperspectral_imaging\spectral_sensitivity\data_photos';
    filename = 'IMG_3548.CR2';
    
    offset = 2048; % level corresponding to black; subtracted from raw counts
    
    %%
    
    [I_raw, I_demosaic, ~] = extract_RAW_via_dcraw(path, filename, 'rggb', '-D -4 -j -t 0', 0, 0, 0);
    
    %%
    
    I_demosaic = I_demosaic - offset;%min(I_demosaic(:)); % pull all curves to zero
    length(find(I_demosaic<0))
    I_demosaic(I_demosaic<0) = 0;
    
    edges = linspace(0, double(max(I_demosaic(:))), 256);
    
    figure(1)
        clf
        hold on
        set(gcf,'color','white')
    
    for cc = 1 : 3

        CC = I_demosaic(:,:,cc);
        [counts, ~] = histcounts(CC(:), edges);
        centers = edges(1:end-1) + abs(diff(edges(1:2)))/2;

        measurement = dot(counts, centers) / sum(counts);

        switch cc
            case 1
                col = 'r';
            case 2
                col = 'g';
            case 3
                col = 'b';
        end

        plot(centers, counts, [col '-'])

    end
    
    set(gca, 'YScale', 'log')
    grid on
    grid minor
    title(regexprep(filename, '_','\\_'))
    xlim([0 max(xlim)])


% end



















































