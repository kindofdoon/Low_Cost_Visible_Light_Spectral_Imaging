% function photo_trichromate_histograms

    clear
    clc
    
    %%
    
%     path = 'C:\Users\Admin\Desktop\hyperspectral_imaging\RAW_limits';
%     filename = 'IMG_4803.CR2'; % white (horizontal)
%     filename = 'IMG_4804.CR2'; % white (vertical)
%     filename = 'IMG_4805.CR2'; % black


    path = 'C:\Users\Admin\Desktop\hyperspectral_imaging\spectral_sensitivity\data_photos';
    filename = 'IMG_3937.CR2';

    bit_depth = 14;
    
    %%
    
    figure(32)
        clf
        set(gcf,'color','white')
        pos = get(gcf,'position');
        set(gcf,'position',[pos(1) 150 1000 600])

    [~, RAW, ~] = extract_RAW_via_dcraw(path, filename, 'rggb', '-D -4 -j -t 0', 0, 0, 0);

    centers = 0 : (2^bit_depth-1);
    edges = -0.5 : (2^bit_depth-0.5);
    
    for cc = 1 : 3
        subplot(3,1,cc)
        cla
        hold on
        counts = histcounts(RAW(:,:,cc), edges);
        col = [0 0 0];
        col(cc) = 1;
        plot(centers, counts, 'Color', col)
        [val, ind] = max(counts);
        scatter(centers(ind), counts(ind), 'k.')
        text(centers(ind), counts(ind), [' value = ' num2str(centers(ind))], 'FontSize', 8, 'HorizontalAlignment','left','VerticalAlignment','middle')
        xlim([min(edges) max(edges)])
        grid on
        grid minor
        set(gca, 'yscale', 'log')

    end
    subplot(3,1,1)
    title(['\rm' regexprep(filename,'\_','\\_')])

%     xlim([0 max_val])
%     title(['\fontsize{9}\bf' num2str(p) ': \rm' regexprep(Photo.filenames{p},'_','\\_')])

%     if p ~= Photo.qty
%         set(gca,'xticklabel','')
%         set(gca,'yticklabel','')
%     end
    

% end



















































