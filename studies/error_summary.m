% function error_summary

    clear
    clc
    
    %%
    
    dE        = [1.78550000000000;2.17390000000000;1.69700000000000;2.25450000000000;3.50880000000000;1.83910000000000;1.97650000000000;2.25010000000000;2.07450000000000;2.71280000000000;0.971000000000000;2.62960000000000;1.84530000000000;1.22500000000000;2.18780000000000;1.03630000000000;1.02840000000000;1.31440000000000;4.09630000000000;2.35080000000000;1.68230000000000;0.791600000000000;0.998100000000000;1.44400000000000];
    thresh    = 0.90;
    bin_width = 0.25; % Delta_E
    
    %%
    
    qty = length(dE);
    ind_last = ceil(qty .* thresh);
    dE_thresh = sort(dE);
    dE_thresh = dE_thresh(1:ind_last);
    
    val_mid = (max(dE_thresh)+min(dE_thresh))/2;
    val_low = min(dE_thresh);
    disp([num2str(thresh*100) '% of samples are within ' num2str(val_mid) ' ± ' num2str(val_mid-min(dE_thresh)) ' Delta_E'])
    
    %%
    
    bin_edges = 0 : bin_width : ceil(max(dE)/bin_width)*bin_width;
    bin_centers = bin_edges(1:end-1) + bin_width/2;
    bin_counts = histcounts(dE, bin_edges);
    
    figure(29)
    clf
    set(gcf,'color','white')
    bar(bin_centers, bin_counts, 'FaceColor', zeros(1,3)+0.5, 'EdgeColor', 'none')
    grid on
    
    xlabel('Color Error, \DeltaE_{00}')
    ylabel('Number of Samples, ~')
    set(gca,'FontSize',12)
    
    set(gca,'ytick',0:ceil(max(ylim)))
%     set(gca,'xtick',bin_centers)
    
    pos = get(gcf,'position');
    size = [560 370];
    set(gcf,'position',[pos(1:2) size])

% end


















































