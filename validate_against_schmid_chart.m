% function validate_against_schmid_chart

    %%
    
    % Run hyperspectral_image_GUI.m first
    % Make sure:
        % IMG_2501.JPG
        % D65 Illuminant
        % Wavelength Resolution = 10 nm
        % Preview Resolution = 1500 px
        % Gamma = 1.00
    
    % Bring up the image
    % User clicks a spot
    % Plot estimated SPD and color at that spot
    % Prompt user to select the corresponding reflectance curve from the Schmid dataset
    % Convert reflectance to SPD using illuminant
    % Plot measured SPD and color
    % Repeat...
    
    %%
    
    lw = 2; % line width
    
    %%
    
    figure(201)
        clf
        set(gcf,'color','white')
            image(Image.RGB)
            aspect_ratio = [size(Image.RGB,2), size(Image.RGB,1)];
            pos = get(gcf,'position');
            set(gcf,'position',[pos(1:2) 1.*aspect_ratio])
            set(gca,'position',[0 0 1 1])
            axis tight
            axis equal
            axis off
            
    %%
    
    addpath('C:\Users\Daniel\Desktop\PAINTERS_COPILOT\')
    load('Schmid_validation_position','POS_CENTROID','POS_MIDTONE')
    
    % Define acceptable x/y positions for alignment snapping
    x_center_vals = linspace(min(POS_CENTROID(:,1))+5,  max(POS_CENTROID(:,1))-5, 12);
    y_center_vals = linspace(min(POS_CENTROID(:,2))+10, max(POS_CENTROID(:,2))-5, 9);
    
    s = return_data_indices;
    [Observer, Illuminant, Paints] = prepare_studio(0);
    
    click_type = 1; % left-click
    click_count = 1;

%     ind_schmid = 1 : size(Paints.data,1);
    
%     POS_CENTROID = zeros(length(ind_schmid),2);
%     POS_MIDTONE  = zeros(length(ind_schmid),2);
    
    miniplot_size         = [1/19 1/12]; % ~
    
    % Add descriptive title to top
    text(mean(xlim), min(ylim), ' \bfValidation of SPD Estimation Using Schmid Color Chart. \rmPlots compare measured vs. estimated (solid vs. dotted) SPD, normalized 0-1, over domain of 400-700 nm, corresponding to each swatch. CIE 1931 2° XYZ Observer, D65 Illuminant. ', 'HorizontalAlignment','center','VerticalAlignment','top','BackgroundColor','w')
    
    max_SPD = max(SPD(:));
    
    CALIB = ones(size(SPD,3), size(POS_CENTROID,1));
    
    for i_s = 1 : size(POS_CENTROID,1) % ind_schmid
        
        x_midtone = POS_MIDTONE(i_s,1);
        y_midtone = POS_MIDTONE(i_s,2);
        
        x_center = POS_CENTROID(i_s,1);
        y_center = POS_CENTROID(i_s,2);
        
        % Snap for alignment
        [~, ind] = min(abs(x_center - x_center_vals));
        x_center = x_center_vals(ind);
        [~, ind] = min(abs(y_center - y_center_vals));
        y_center = y_center_vals(ind);
        
%         % Left-click color midtone & geometry center, OR right-click color midtone
%         [x_midtone, y_midtone, click_type] = ginput_custom(1);
%         x_midtone = round(x_midtone);
%         y_midtone = round(y_midtone);
        
%         if click_type == 1 % left-click
%             x_center = x_midtone;
%             y_center = y_midtone;
%         else
%             % Midtone and center are not coincident (due to glare, etc.) - resample
%             [x_center, y_center, ~] = ginput_custom(1);
%         end
        
        col_chart = squeeze(Image.RGB(y_midtone,x_midtone,:));
        if dot(Observer.grayscale_weights, col_chart) > 0.25
            text_col = 'k';
        else
            text_col = 'w';
        end
        
        axes('Position',[
                            x_center/size(Image.RGB,2)-miniplot_size(1)/2,...
                            1-(y_center/size(Image.RGB,1)+miniplot_size(2)/2),...
                            miniplot_size(1),...
                            miniplot_size(2),...
                        ],'Color','none')
        set(gca,'xtick', [])
        set(gca,'ytick', [])
        set(gca,'XColor',text_col, 'YColor',text_col)
                    
        hold on
        
        a = Observer.lambda;
        b = Paints.data{i_s,s.R} .* Illuminant.power;
        
        c = Wavelength;
        d = squeeze(SPD(y_midtone,x_midtone,:));
        
%         d = d .* interp1([400 700],[0.4 1.2],c');
        
        plot(a,b,'LineWidth',1.5,'Color',text_col)
        plot(c, d, ':','LineWidth',2,'Color',text_col)
        axis([min(Wavelength) max(Wavelength) 0 1])
            
        err = d ./ interp1(a, b, Wavelength)';
        CALIB(:,i_s) = 1 ./ err;
            
        text(min(xlim), max(ylim), [' ' num2str(i_s)], 'HorizontalAlignment','left','VerticalAlignment','top','FontSize',8,'Color',text_col)
            
%         POS_CENTROID(i_s, :) = [x_center,  y_center];
%         POS_MIDTONE(i_s, :)  = [x_midtone, y_midtone];

%         drawnow

    end
    
    CALIB = mean(CALIB,2);
    
    figure(202)
        clf
        set(gcf,'color','white')
        plot(Wavelength, CALIB', 'k')
        xlabel('Wavelength, nm')
        ylabel('SPD Gain, ~')
        title('Sensor Calibration Curve per Schmid Chart')
        grid on
        grid minor
        ylim([0 max(ylim)])
        
        pos = get(gcf,'position');
        set(gcf,'position',[pos(1:2) round([560 400] .* 0.75)])
    
%     save('Schmid_validation_position','POS_CENTROID','POS_MIDTONE')

% end





































