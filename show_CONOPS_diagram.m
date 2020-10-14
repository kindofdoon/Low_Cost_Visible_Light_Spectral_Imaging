% function show_CONOPS_diagram

    % Must run hyperspectral_image_GUI.m > Preview Image first

    %%
    
    clc
    
    %%
    
    addpath('C:\Users\Daniel\Desktop\hyperspectral_imaging\photos')
    addpath('C:\Users\Daniel\Desktop\hyperspectral_imaging\blog')
    
    prefix = regexprep(Photos.filename_first, '[0-9]+.+','');
    number = regexp(Photos.filename_first,'([0-9]+)','tokens');
    number = str2double(number{1}{1});
    extens = regexprep(Photos.filename_first, '.+\.','');

    I_regular = imread([prefix num2str(number-1) '.' extens]);
    
    [I_camera, ~, I_camera_alpha] = imread('canon_650d_transparent.png');
    
    fig_size = [1200 600];
    
    figure(123)
        clf
        set(gcf,'color','white')
        pos = get(gcf,'position');
        set(gcf,'position',[pos(1:2) fig_size])
        
        % Show regular scene
        axes('Position',[0.02 0.40 0.20 0.20],'Color','none')
        image(I_regular)
        axis tight
        axis equal
        text(mean(xlim), max(ylim), 'Scene of Interest', 'HorizontalAlignment','center','VerticalAlignment','top')
        axis off
        
        % Show camera
        a = 0.30;
        b = 0.40;
        c = 0.20;
        d = 0.20;
        axes('Position',[a b c d],'Color','none')
        image(I_camera, 'AlphaData', I_camera_alpha)
        axis tight
        axis equal
        text(mean(xlim), max(ylim), 'Commodity Camera','VerticalAlignment','top','HorizontalAlignment','center')
        axis off
        axes('Position',[a b+d*1.1 c d])
        hold on
        for cc = 1 : 3
            col = [0 0 0];
            col(cc) = 1;
            plot(Wavelength, Camera.RGB_observer(:,cc),'Color', col,'LineWidth',2)
        end
        xlim([min(Wavelength) max(Wavelength)])
        axis square
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        
        th = linspace(0, 2*pi, 360);
        y = linspace(0.75, 0.25, Filters.qty);
        r = 0.11;
        for f = 1 : Filters.qty
            
            % Filter color
            a = 0.25-r/2;
            b = y(f)-r/2;
            c = r;
            d = r;
            axes('Position', [a b c d],'Color','none')
            hold on
            axis equal
            axis off
            fill(cos(th)*r, sin(th)*r, Filters.RGB(f,:), 'EdgeColor', zeros(1,3)+0.10,'LineWidth',4)
            
            % Filter transmission
            axes('Position', [a+0.03 b+0.03 c-0.06 d-0.06],'Color','none')
            plot(Wavelength, Filters.T(:,f), 'k','LineWidth',2)
            set(gca,'color','none')
            axis square
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            
        end
        
        text(mean(xlim), min(ylim)-0.60, 'Color Bandpass Filters', 'HorizontalAlignment','center','VerticalAlignment','top')
        
        y = linspace(0.8, 0.2, Filters.qty);

        r = 0.13;
        
        for f = 1 : Filters.qty
            
            axes('Position', [0.50 y(f)-r/2 r r])
            image(Photos.RGB{f})
            axis equal
            axis tight
            axis off
            
        end
        
        text(mean(xlim), max(ylim), 'Filtered Photos', 'HorizontalAlignment','center','VerticalAlignment','top')
        
        % Show wavelengths
        lambda_vs_RGB = wavelength_vs_color(Wavelength); % get wavelength vs. color data
        pos = [0.70 0.70];
        dp  = [-0.010 -0.010] .* [1 2];
        dims = [0.15 0.15];
        for w = 1 : length(Wavelength)
            col = lambda_vs_RGB(w,:);
            col = reshape(col,[1,1,3]);
            col = repmat(col, [Photos.res, 1]);
            I = SPD(:,:,w);
            I = I + 0.25;
            I = I ./ max(I(:));
            I = repmat(I,[1,1,3]) ./ max(SPD(:));
            I = I .* col;
            axes('Position',[pos dims])
            image(I)
            axis tight
            axis equal
            axis off
            pos = pos + dp;
        end
        
        % Show hyperspectral image
        
        axes('Position',[0.78 0.35 0.20 0.30])
        image(Image.RGB)
        axis equal
        axis tight
        axis off
        text(mean(xlim), max(ylim), 'Hyperspectral Image','HorizontalAlignment','center','VerticalAlignment','top')
        
% end




















































