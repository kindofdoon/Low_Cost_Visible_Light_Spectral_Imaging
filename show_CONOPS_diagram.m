% function show_CONOPS_diagram

    % Must run hyperspectral_image_GUI.m > Preview Image first

    %%
    
    clc
    
    %%
    
    width.plot  = 0.15;
    width.photo = 0.25;
    
    %%
    
    addpath('C:\Users\Daniel\Desktop\hyperspectral_imaging\photos')
    addpath('C:\Users\Daniel\Desktop\hyperspectral_imaging\blog')
    
    prefix = regexprep(Photos.filename_first, '[0-9]+.+','');
    number = regexp(Photos.filename_first,'([0-9]+)','tokens');
    number = str2double(number{1}{1});
    extens = regexprep(Photos.filename_first, '.+\.','');

    I_regular = imread([prefix num2str(number-1) '.' extens]);
    
    [I_camera, ~, I_camera_alpha] = imread('canon_650d_transparent.png');
    
    fig_size = [1600 600];
    
    figure(123)
        clf
        set(gcf,'color','white')
        pos = get(gcf,'position');
        set(gcf,'position',[pos(1:2) fig_size])
        
        % Scene
        axes('Position',[-0.04 0.50-width.photo/2 width.photo width.photo],'Color','none')
        image(I_regular)
        axis tight
        axis equal
        text(mean(xlim), max(ylim), '\bfArbitrary Scene', 'HorizontalAlignment','center','VerticalAlignment','top')
        axis off
        
        % Camera
        width.camera = 0.20;
        a = 0.225;
        b = 0.40;
        axes('Position',[a b width.camera width.camera],'Color','none')
        image(I_camera, 'AlphaData', I_camera_alpha)
        axis tight
        axis equal
        text(mean(xlim), max(ylim)-20, {'\bfCommodity Camera','\rmCanon 650D'},'VerticalAlignment','top','HorizontalAlignment','center')
        axis off
        
        % Camera Sensitivity
        x.sens = 0.245;
        y.sens = b + width.camera + 0.08;
        axes('Position',[x.sens, y.sens, width.plot, width.plot])
        hold on
        for cc = 1 : 3
            col = [0 0 0];
            col(cc) = 1;
            plot(Wavelength, Camera.RGB_observer(:,cc),'Color', col,'LineWidth',2)
        end
        axis square
        xlim([min(Wavelength) max(Wavelength)])
        axis square
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        text(mean(xlim), min(ylim), 'Camera Sensitivity','HorizontalAlignment','center','VerticalAlignment','top')
        
        % Filters
        th = linspace(0, 2*pi, 360);
        height = linspace(0.80, 0.20, Filters.qty);
        r = 0.12;
        for f = 1 : Filters.qty
            
            % Filter Color
            a = 0.215-r/2;
            b = height(f)-r/2;
            c = r;
            d = r;
            axes('Position', [a b c d],'Color','none')
            hold on
            axis equal
            axis off
            fill(cos(th)*r, sin(th)*r, Filters.RGB(f,:), 'EdgeColor', zeros(1,3)+0.10,'LineWidth',4)
            
            % Filter Transmission
            axes('Position', [a+0.02 b+0.02 c-0.04 d-0.04],'Color','none')
            plot(Wavelength, Filters.T(:,f), 'k','LineWidth',2)
            set(gca,'color','none')
            axis square
            xlim([min(Wavelength) max(Wavelength)])
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            
        end
        text(mean(xlim), min(ylim)-0.50, {'\bfBandpass Filter Set','\rmMidOpt FS100'}, 'HorizontalAlignment','center','VerticalAlignment','top')
        
        % Filtered Photos
        height = linspace(0.8, 0.2, Filters.qty);
        r = 0.13;
        for f = 1 : Filters.qty
            axes('Position', [0.375 height(f)-r/2 r r])
            image(Photos.RGB{f})
            axis equal
            axis tight
            axis off
        end
        text(mean(xlim), max(ylim), '\bfFiltered Photos', 'HorizontalAlignment','center','VerticalAlignment','top')
        
        % Sensor Sensitivity
        y.sens = 0.80;
        x.sensor = 0.52;
        axes('Position',[x.sensor, y.sens, width.plot, width.plot])
        plot(Wavelength, Sensor.sensitivity, 'k', 'LineWidth',2)
        axis square
        xlim([min(Wavelength) max(Wavelength)])
        axis square
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        text(mean(xlim), min(ylim), '\bfSensor Sensitivity','HorizontalAlignment','center','VerticalAlignment','top')
        
        % Illuminant
        x.illum = x.sensor + 0.075;
        y.illum = 0.85;
        axes('Position',[x.illum, y.sens, width.plot, width.plot],'Color','none')
        plot(Wavelength, Illuminant.power, 'k','LineWidth',2)
        axis square
        xlim([min(Wavelength) max(Wavelength)])
        ylim([0 max(ylim)])
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        text(mean(xlim), min(ylim), {'\bfIlluminant','\rmCIE D65'},'HorizontalAlignment','center','VerticalAlignment','top')
        
        % Calibration
        x.calib = x.illum + 0.075;
        axes('Position',[x.calib, y.sens, width.plot, width.plot],'Color','none')
        plot(Wavelength, Sensor.calibration_gain,'k','LineWidth',2)
        axis square
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        xlim([min(Wavelength) max(Wavelength)])
        ylim([0 max(ylim)])
        text(mean(xlim), min(ylim), '\bfCalibration','HorizontalAlignment','center','VerticalAlignment','top')
        
        % SPDD
        lambda_vs_RGB = wavelength_vs_color(Wavelength); % get wavelength vs. color data
        pos = [0.61 0.435];
        dp  = [-0.008 -0.010] .* [1 2];
        dims = [width.photo width.photo];
        for w = 1 : length(Wavelength)
            col = lambda_vs_RGB(w,:);
            col = reshape(col,[1,1,3]);
            col = repmat(col, [Photos.res, 1]);
            I = SPD(:,:,w);
            I = repmat(I,[1,1,3]) ./ max(SPD(:));
            I = I .* col;
            axes('Position',[pos dims])
            image(I)
            axis tight
            axis equal
            axis off
            pos = pos + dp;
        end
        text(mean(xlim), max(ylim), '\bfHyperspectral Datacube','HorizontalAlignment','center','VerticalAlignment','top')
        text(max(xlim)+150, mean(ylim)+75, '\bfWavelength Index \rightarrow','Rotation',45)
        
        % Observer
        axes('Position',[0.835, y.sens, width.plot, width.plot],'Color','none')
        cla
        hold on
        for cc = 1 : 3
            col = [0 0 0];
            col(cc) = 1;
            plot(Wavelength, Observer.sensitivity(:,cc),'Color',col,'LineWidth',2)
        end
        axis square
        xlim([min(Wavelength) max(Wavelength)])
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        text(mean(xlim), min(ylim), {'\bfObserver Functions','\rmCIE 1931 2° XYZ'},'HorizontalAlignment','center','VerticalAlignment','top')
        
        % Reconstructed Image
        axes('Position',[0.79, 0.5-width.photo/2, width.photo, width.photo])
        image(Image.RGB)
        axis equal
        axis tight
        axis off
        text(mean(xlim), max(ylim), '\bfReconstructed Image','HorizontalAlignment','center','VerticalAlignment','top')
        
% end




















































