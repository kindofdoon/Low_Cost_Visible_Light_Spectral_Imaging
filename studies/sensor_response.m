% function sensor_response

    clear
    clc
    
    %%
    
    Photo.path = 'C:\Users\Admin\Desktop\hyperspectral_imaging\linearity';
    
    %%
    
    % NOTE: extract_center is [y, x] in px
    %       extract_window is px

    % Vary shutter speed
    Photo.filename_first = 'IMG_5336.CR2';
    Photo.qty = 30;
    extract_center = [2227 1817];
    extract_window = 100;
    
%     % Vary ISO
%     Photo.filename_first = 'IMG_5387.CR2';
%     Photo.qty = 8;
%     extract_center = [2227 1817];
%     extract_window = 100;
    
    %% Prepare sequential filenames
    
    Photo.extension = regexprep(Photo.filename_first, '[^\.]+\.','');
    fn_without_extension = regexprep(Photo.filename_first, Photo.extension, '');
    Photo.base_num = str2double(regexprep(fn_without_extension, '[^0-9]+', ''));
    Photo.prefix = regexprep(Photo.filename_first, '[0-9]+.+','');
    Photo.filenames{1} = Photo.filename_first;
    for f = 2 : Photo.qty
        Photo.filenames{f} = [Photo.prefix num2str(Photo.base_num-1+f) '.' Photo.extension];
    end
    
    %% Show preview of extraction region
    
    [~, ~, I_preview] = extract_RAW_via_dcraw(Photo.path, Photo.filenames{round(Photo.qty/2)}, 'rggb', '-D -4 -j -t 0', 0, 1, 0);
    
    extract_x = round(extract_center(2) + [-1/2 1/2].*extract_window);
    extract_y = round(extract_center(1) + [-1/2 1/2].*extract_window);
    extract_x = min(extract_x) : max(extract_x);
    extract_y = min(extract_y) : max(extract_y);
    
    figure(92)
        clf
        set(gcf,'color','white')
        image(I_preview)
        axis equal
        axis tight
        hold on
        set(gca,'YDir','reverse')
        plot(extract_center(2)+(extract_window/2).*[1 1 -1 -1 1], extract_center(1)+(extract_window/2).*[-1 1 1 -1 -1], 'k',  'LineWidth', 1.5)
        plot(extract_center(2)+(extract_window/2).*[1 1 -1 -1 1], extract_center(1)+(extract_window/2).*[-1 1 1 -1 -1], 'w:', 'LineWidth', 1.5)
        title('Preview of Extraction Region (Dashed)')
        pos = get(gcf,'position');
        set(gcf,'position', [pos(1) 150 [560 420].*2])
        set(gca,'position',[0.05 0.05 0.9 0.9])
        answer = questdlg('Proceed with remainder of photo stack?','','Yes','No','Yes');
        if strcmp(answer,'No')
            return
        end
    
    %% Initialize
    
    shutter_duration = nan(Photo.qty,1);
    ISO              = nan(Photo.qty,1);
    f_number         = nan(Photo.qty,1);
    
    tic
    h = waitbar(0,'');
    
    %% Load data from files
    
    for p = 1 : Photo.qty
        
        info = imfinfo([Photo.path '\' Photo.filenames{p}]);
        metadata = info.DigitalCamera;
        shutter_duration(p) = metadata.ExposureTime;
        ISO(p) = metadata.ISOSpeedRatings;
        f_number(p) = metadata.FNumber;
        
        if p > 1
            if f_number(p) ~= f_number(1)
                error('Inconsistent f-number in photo metadata')
            end
        end

        % Update waitbar
        status = p / (Photo.qty+1);
        waitbar(status,h,['Loading ' regexprep(Photo.filenames{p},'\_','\\_') '...'])

        [~, RGB_calc, ~] = extract_RAW_via_dcraw(Photo.path, Photo.filenames{p}, 'rggb', '-D -4 -j -t 0', 0, 0, 0);
        qty_neg = length(find(RGB_calc<0));
        if qty_neg > 0
            warning([Photo.filenames{p} ' contains ' num2str(qty_neg) ' negative pixels after black level offset'])
        end

        if p == 1 % First image in the stack sets the standard width and height
            Photo.res_orig = [size(RGB_calc,1), size(RGB_calc,2)];
        end

        Photo.RGB_calc{p} = RGB_calc;

    end
    
    close(h)
    
    %% Extract data from photos
    
    Value = nan(Photo.qty,3);
    
    for p = 1 : Photo.qty
        
        RGB = Photo.RGB_calc{p};
        
        for cc = 1 : 3
            target = RGB(extract_y, extract_x, cc);
            Value(p,cc) = mode(target(:));
        end
        
    end
    
    %% Show data
    
    ind_show = 1 : Photo.qty;
    
    figure(34)
    clf
    hold on
    set(gcf,'color','white')
    pos = get(gcf,'position');
    set(gcf,'position',[pos(1) 150 560 420])
    for cc = 1 : 3
        col = [0 0 0];
        col(cc) = 1;
        plot(shutter_duration(ind_show) .* ISO(ind_show), Value(ind_show,cc),'-o','Color', col)
    end
    ylim([0 max(ylim)])
    grid on
    grid minor
    xlabel('(Shutter Duration, sec) * (ISO, ~)')
    ylabel('RAW Value, Reported, ~')
%     title('Canon 650D Sensor Response')
    
    %% Normalize curves
    
    figure(103)
        clf
        hold on
        set(gcf,'color','white')
        
    figure(104)
        clf
        hold on
        set(gcf,'color','white')
    
    val_min = 2048;%min(Value(:));
    val_max = 12000;%max(Value(:));
    
    for cc = 1 : 3
        
        x = shutter_duration .* ISO;
        y = Value(:,cc);
        
        ind_last = max(find(y < val_max));
        x = x(1:ind_last);
        y = y(1:ind_last);
        
        x_final = interp1(y, x, val_max, 'linear', 'extrap');
        x_init  = 0;
        y_init  = 2048;
        y_final = val_max;
        x = [x_init; x; x_final];
        y = [y_init; y; y_final];
        
        col = [0 0 0];
        col(cc) = 1;
        figure(103)
            plot(x(1:end-1), y(1:end-1), 'k-o', 'Color', col)
            xlabel('(Shutter Duration, sec) * (ISO, ~)')
            ylabel('RAW Value, Reported ~')
        
        domain = (x-min(x)) ./ (max(x)-min(x)) * (val_max-val_min) + val_min;
        
        figure(104)
            plot(y, domain, 'k-o', 'Color', col)
            xlabel('RAW Value, Reported, ~')
            ylabel('RAW Value, Idealized, \propto (Shutter Duration * ISO), ~')
%             title('RAW Linear Correction Curves')
        
    end
    
    figure(104)
        plot(domain, domain, 'k:', 'LineWidth', 1.5)
    
    for f = 103:104
        figure(f)
        grid on
        grid minor
        ylim([0 max(ylim)])
        set(gca,'FontSize',12)
    end

% end













































