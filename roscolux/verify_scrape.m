% function verify_scrape

    %%
    
    clear
    clc
    
    %%

    load('roscolux_filter_transmissions','T','files','lambda')
    
    x = min(lambda) : 2 : max(lambda);

    T = round(T);
    
    for f = 1 : length(files)
        
        figure(1)
            clf
            set(gcf,'color','white')
            I = imread(files{f});
            image(I)
            axis equal
            axis tight
            drawnow
        
        figure(2)
            clf
            set(gcf,'color','white')
            plot(x, spline(lambda,T(:,f),x), 'k')
            grid on
            grid minor
            ylim([0 100])
            drawnow
            
        figure(3)
            clf
            set(gcf,'color','white')
            image(I(940:end,:,:))
            axis equal
            axis tight
            set(gca,'position',[0 0 1 1])
            drawnow
        
        clc
        disp(num2str(T(:,f)'))
            
        pause
        
    end
    
% end



















































