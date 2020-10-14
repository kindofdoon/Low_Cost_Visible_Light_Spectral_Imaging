% function [Observer, Filters, Camera, DC, I_RGB, fn_export] = generate_hyperspectral_image

    % This version attempts to avoid linear algebra due to
    % the ill-posed nature of the problem, and instead attempts to build a
    % power spectrum for each pixel as linear combinations of filter
    % tranmission spectra.

    clear
    clc
    
    %% Inputs
    
    res_limit = 1000; % px, Inf: full resolution
    lambda = (400 : 10 : 700)'; % nm, the standard wavelength domain to be used throughout
    
    % Toggle outputs
    show_camera_curves = 1;
    show_sensitivities = 0;
    show_GIF           = 1;
    show_spectra       = 1;
    show_illuminant    = 1;
    
    % Output properties
    GIF_fps = 10; % frames per second
    points_per_horizontal_dim = 10;
    
    smoothing = 0; % 1=on, 0=off
    
    Photos.pathdir = 'C:\Users\Daniel\Desktop\hyperspectral_imaging\photos';
    
    % First photo in the stack - sequential filenames are automatically generated
    % Lone Tree
%     Photos.filename_first = 'IMG_1490.jpg'; % Sunny hill
%     Photos.filename_first = 'IMG_1531.jpg'; % Bramble

    % Misc.
%     Photos.filename_first = 'IMG_4513.jpg'; % Bookshelf

    % Mt. Auburn Cemetery
%     Photos.filename_first = 'IMG_1644.jpg'; % Sphinx
%     Photos.filename_first = 'IMG_1553.jpg'; % Gentian Path 1
%     Photos.filename_first = 'IMG_1605.jpg'; % Auburn chapel
%     Photos.filename_first = 'IMG_1616.jpg'; % Gentian Path 2
%     Photos.filename_first = 'IMG_1663.jpg'; % Auburn sunset
%     Photos.filename_first = 'IMG_1678.jpg'; % Boston skyline 1
%     Photos.filename_first = 'IMG_1688.jpg'; % Boston skyline 2
%     Photos.filename_first = 'IMG_1699.jpg'; % Boston skyline 3

    % Rock Meadow
%     Photos.filename_first = 'IMG_1780.jpg'; % Entrance
%     Photos.filename_first = 'IMG_1792.jpg'; % Grapevine 1
%     Photos.filename_first = 'IMG_1802.jpg'; % Bush
%     Photos.filename_first = 'IMG_1823.jpg'; % Orange flowers
    Photos.filename_first = 'IMG_1836.jpg'; % Blue chair
%     Photos.filename_first = 'IMG_1847.jpg'; % Tree
%     Photos.filename_first = 'IMG_1858.jpg'; % Narrow path
%     Photos.filename_first = 'IMG_1868.jpg'; % Signpost
%     Photos.filename_first = 'IMG_1881.jpg'; % Purple flowers
%     Photos.filename_first = 'IMG_1893.jpg'; % Rocks
%     Photos.filename_first = 'IMG_1905.jpg'; % Vine
%     Photos.filename_first = 'IMG_1918.jpg'; % Purple vine
%     Photos.filename_first = 'IMG_1931.jpg'; % Grapevine 2
    
    % Value scaling
    sat_thresh = 0.01;
    value_range = [0.10, 0.90];
    
    % Camera settings
    Camera.ID = 'Canon 600D';
    Camera.RGB_sen_gains = [0.50, 1.00, 0.75];
    Camera.lambda = 400 : 10 : 720;
    Camera.RGB_observer = [ % Canon 600D
                    0.0018383, 0.0034546, 0.0065563, 0.0064237, 0.003663, 0.0032176, 0.0045901, 0.0075219, 0.015409, 0.022585, 0.033511, 0.053847, 0.066262, 0.082616, 0.10166, 0.15313, 0.2023, 0.29541, 0.4398, 0.53074, 0.51692, 0.50521, 0.38884, 0.34276, 0.26434, 0.22089, 0.1637, 0.13044, 0.072591, 0.021389, 0.003813, 0.00089247, 0.00023267
                    0.0027522, 0.0063568, 0.025923, 0.055392, 0.079072, 0.098383, 0.13411, 0.28424, 0.53216, 0.67504, 0.78346, 0.91032, 0.89359, 1, 0.88185, 0.85526, 0.76181, 0.71016, 0.56299, 0.44008, 0.27856, 0.16213, 0.078769, 0.052859, 0.035122, 0.026057, 0.018983, 0.01922, 0.014806, 0.005949, 0.0013347, 0.00034954, 0.00012156
                    0.010963, 0.047664, 0.25927, 0.6278, 0.69721, 0.78211, 0.8035, 0.78122, 0.75824, 0.64609, 0.513, 0.38666, 0.22351, 0.15669, 0.10477, 0.078029, 0.050767, 0.040953, 0.034064, 0.027857, 0.019411, 0.013821, 0.0088981, 0.0081423, 0.007593, 0.0084223, 0.008274, 0.0083911, 0.0053867, 0.0018156, 0.00036101, 0.00011979, 7.6506e-05
                 ]';
    
    %% Constants
    
    XYZ_lims = [0, 1.0888]; % absolute limits of the color space
    
    %% Smooth camera sensitivity
    
    if smoothing
    
        % Smoothing parameters
        pad_qty = 9; % ~
        sample_spacing = 2;

        dl = abs(diff(Camera.lambda(1:2)));
        pad = 0 : dl : dl * (pad_qty-1);
        lam_pad = [pad+min(Camera.lambda)-(dl*(pad_qty+1)), Camera.lambda, pad+max(Camera.lambda)+dl];
        sen_pad = [zeros(pad_qty,3); Camera.RGB_observer; zeros(pad_qty,3)];
        ind = 1 : sample_spacing : length(lam_pad);

        S_orig = Camera.RGB_observer; % preserve original data

        for cc = 1 : 3
            Camera.RGB_observer(:,cc) = spline(lam_pad(ind), sen_pad(ind,cc), Camera.lambda);
        end
        Camera.RGB_observer(Camera.RGB_observer<0) = 0;
        Camera.RGB_observer(Camera.RGB_observer>1) = 1;

        figure(51)
            clf
            hold on
            set(gcf,'color','white')
            for cc = 1 : 3
                col = [0 0 0];
                col(cc) = 1;
                plot(Camera.lambda, S_orig(:,cc), '--', 'Color', col)
                plot(Camera.lambda, Camera.RGB_observer(:,cc), 'Color', col)
            end
            xlabel('Wavelength, nm')
            ylabel('Spectral Sensitivity, ~')
            title('Camera Spectral Sensitivity Before/After Spline Filtering')
            grid on
            grid minor

    end

	%% Load external data

    [Observer, Illuminant, Filters] = prepare_filters(lambda, smoothing, 0);
    qty_lam = length(Observer.lambda); % number of wavelength indices
    
    % Generate sequential filenames for photo stack
    Photos.filenames = cell(Filters.qty, 1);
    base_num = str2double(regexprep(Photos.filename_first, '[^0-9]+', ''));
    extension = regexprep(Photos.filename_first, '[^\.]+\.','');
    prefix = regexprep(Photos.filename_first, '[0-9]+.+','');
    Photos.filenames{1} = Photos.filename_first;
    for f = 2 : Filters.qty
        Photos.filenames{f} = [prefix num2str(base_num-1+f) '.' extension];
    end
    
    %% Check inputs
    
    Photos.qty = length(Photos.filenames);
    
    if Filters.qty ~= Photos.qty
        error('Quantity of filters and photos must be equal')
    end

    %% Load inputs
    
    % Get size of first image
    RGB = imread([Photos.pathdir '\' Photos.filenames{1}]);
    Photos.scale = res_limit / max(size(RGB));
    if Photos.scale < 1 % image must be downsampled
        Photos.res = ceil( [size(RGB,1), size(RGB,2)] .* Photos.scale);
    else
        Photos.res = [size(RGB,1), size(RGB,2)];
    end
    
    status_old = 0;
    tic
    msg = 'Loading photos...';
    h = waitbar(0,msg);
    
    Photos.RGB = cell(Photos.qty, 1);
    Photos.Gray = zeros(Photos.res(1), Photos.res(2), length(Photos.filenames));
    
    for p = 1 : Photos.qty
        
        RGB = imread([Photos.pathdir '\' Photos.filenames{p}]);
        if Photos.scale < 1
            RGB = imresize(RGB, Photos.scale);
        end
        RGB = double(RGB) / 255; % 0 to 1
        
        Photos.RGB{p} = RGB;
        
        % Update waitbar
        status_new = round(p/Photos.qty*100);
        if status_new > status_old
            status = status_new/100;
            tr = toc/status*(1-status); % sec, time remaining
            mr = floor(tr/60); % minutes remaining
            sr = floor(tr-mr*60); % sec remaining
            waitbar(status,h,[msg num2str(mr) ':' num2str(sr) ' remaining'])
            status_old = status_new;
        end
        
    end
    
    close(h)
    
    %% Parse inputs
    
    % Apply gains
    Camera.RGB_observer = Camera.RGB_observer .* repmat(Camera.RGB_sen_gains, [size(Camera.RGB_observer,1), 1]);
    
    % Resample and standardize domain(s)
    O = zeros(qty_lam, size(Camera.RGB_observer,2));
    for cc = 1 : size(Camera.RGB_observer,2)
        O(:,cc) = spline(Camera.lambda, Camera.RGB_observer(:,cc), lambda);
    end
    Camera.RGB_observer = O;
    Camera.lambda = Observer.lambda;
    
    Illuminant.power = spline(Illuminant.lambda, Illuminant.power, lambda);
    Illuminant.lambda = lambda;
    
    if show_camera_curves
        figure(66)
            clf
            hold on
            set(gcf,'color','white')
            plot(Observer.lambda, Camera.RGB_observer(:,1), 'r', 'LineWidth', 2)
            plot(Observer.lambda, Camera.RGB_observer(:,2), 'g', 'LineWidth', 2)
            plot(Observer.lambda, Camera.RGB_observer(:,3), 'b', 'LineWidth', 2)
            grid on
            grid minor
            xlabel('Wavelength, nm')
            ylabel('Camera RGB Sensitivity, ~')
            ylim([0 max(ylim)])
            title({'Camera RGB Sensitivity Curves',['\rm\fontsize{9}' Camera.ID ', RGB Gains of [' num2str(Camera.RGB_sen_gains(1)) ', ' num2str(Camera.RGB_sen_gains(2)) ', ' num2str(Camera.RGB_sen_gains(3)) ']' ]})
            legend({'Red','Green','Blue'},'location','northeast')
    end
    
    if show_illuminant
        figure(67)
            clf
            hold on
            set(gcf,'color','white')
            plot(Illuminant.lambda, Illuminant.power, 'k')
            grid on
            grid minor
            xlabel('Wavelength, nm')
            ylabel('Light Power, ~')
            title(Illuminant.description)
            ylim([0 max(ylim)])
    end 

    %% Generate datacube
    
    t_start = tic;

    status_old = 0;
    tic
    msg = 'Generating datacube...';
    h = waitbar(0,msg);
    
    DC = zeros(Photos.res(1), Photos.res(2), qty_lam); % initialize datacube
    UNI = zeros(size(DC)); % response of camera & filters to ideal uniform light source
    
    if show_sensitivities
        figure(77)
            clf
            hold on
            set(gcf,'color','white')
    end
    
    I = Illuminant.power;
    IL = reshape(Illuminant.power, [1, 1, qty_lam]);
    IL = repmat(IL, [Photos.res, 1]);
    
    for f = 1 : Filters.qty % for each filter/image pair
        
        T = Filters.T(:,f); % transmittance, filter
        
        for cc = 1 : 3 % for each color channel
            
            S = Camera.RGB_observer(:,cc); % sensitivity, camera
            ST = S .* T;
            
            if show_sensitivities
                figure(77)
                    plot(Observer.lambda, ST, 'k')
                    drawnow
            end
            
            ST = reshape(ST, [1, 1, qty_lam]);
            ST = repmat(ST, [Photos.res, 1]);

            UNI = UNI + ST;
            
            VAL = Photos.RGB{f}(:,:,cc); % 0 to 1
            VAL = repmat(VAL, [1,1, qty_lam]);
            
            DC = DC + ST .* VAL;
            
            % Update waitbar
            status_new = round(((f-1)*3+cc)/(Filters.qty*3)*100);
            if status_new > status_old
                status = status_new/100;
                tr = toc/status*(1-status); % sec, time remaining
                mr = floor(tr/60); % minutes remaining
                sr = floor(tr-mr*60); % sec remaining
                waitbar(status,h,[msg num2str(mr) ':' num2str(sr) ' remaining'])
                status_old = status_new;
            end
        
        end
    end
    
    DC = DC ./ UNI; % normalize to uniform response
    DC = DC .* IL; % normalize to light source
    
    close(h)
    
    %% Show sum of perceived spectra
    
    figure(99)
        clf
        set(gcf,'color','white')
        plot(Observer.lambda, squeeze(UNI(1,1,:)), 'k')
        xlim([min(Observer.lambda) max(Observer.lambda)])
        ylim([0 max(ylim)])
        grid on
        grid minor
        xlabel('Wavelength, nm')
        ylabel('Sum of Perceived Spectra, ~')
        title('Sum of All Camera-Filter Dot Products')
    
    %% Generate XYZ colors
    
    I_XYZ = zeros(Photos.res(1), Photos.res(2), 3);
    
    % Reshape along third (wavelength) dimension
    X_C = reshape(Observer.responses(:,1), [1, 1, qty_lam]);
    Y_C = reshape(Observer.responses(:,2), [1, 1, qty_lam]);
    Z_C = reshape(Observer.responses(:,3), [1, 1, qty_lam]);
    
    % Repeat for each pixel
    X_C = repmat(X_C,[Photos.res, 1]);
    Y_C = repmat(Y_C,[Photos.res, 1]);
    Z_C = repmat(Z_C,[Photos.res, 1]);
    
    % Index in cell array
    C{1} = X_C;
    C{2} = Y_C;
    C{3} = Z_C;
    
    for cc = 1 : 3
        I_XYZ(:,:,cc) = sum(DC .* C{cc}, 3);
    end
    
    %% Normalize XYZ values
    
    I_XYZ = (I_XYZ-min(I_XYZ(:))) ./ (max(I_XYZ(:))-min(I_XYZ(:))); % 0 to 1
    I_XYZ = I_XYZ * (max(XYZ_lims)-min(XYZ_lims)) + min(XYZ_lims); % XYZ lims
    
%     I_XYZ = (I_XYZ-min(val_lim_active)) .* (abs(diff(value_range))/abs(diff(val_lim_active))) + min(val_lim_active);
    
    %% Generate RGB image
    
    I_RGB = xyz2rgb(I_XYZ, 'WhitePoint', 'D65');
    
    % Normalize values
    I_RGB(I_RGB < 0) = 0;
    I_RGB(I_RGB > 1) = 1;
    
    % Calculate CDF to determine which portion of value range is actually in use
    I_Gray = rgb2gray(I_RGB);
    bin.edges = linspace(0, 1, 256);
    bin.width = abs(diff(bin.edges(1:2)));
    [bin.pop, ~, bin.ID] = histcounts(I_Gray, bin.edges);
    bin.PDF = bin.pop ./ sum(bin.pop);
    bin.CDF = cumsum(bin.PDF);
    bin.ind_active = intersect(find(bin.CDF>sat_thresh), find(bin.CDF<(1-sat_thresh)));
    val_lim_active = [bin.edges(min(bin.ind_active)), bin.edges(max(bin.ind_active))] + bin.width/2;
    
    % Normalize values
%     I_RGB = (I_RGB-min(I_RGB(:))) ./ (max(I_RGB(:))-min(I_RGB(:))); % 0 to 1
    I_RGB = imadjust(I_RGB, val_lim_active, value_range);
    
    I_RGB(I_RGB < 0) = 0;
    I_RGB(I_RGB > 1) = 1;
    
    %% Wrap up up computation
    
    t_end = toc(t_start);
    disp(['Completed at ' num2str(round(size(Photos.RGB{1},1)*size(Photos.RGB{1},2)/t_end)) ' px/sec [' num2str(t_end) ' sec]'])
    
    %% Show results
    
    figure(100)
        clf
        set(gcf,'color','white')
        image(I_RGB)
        axis equal
        axis tight
    
    %% Save results
    
    fn_export = [
                    regexprep(Photos.filename_first,'\..+','') '_' ...
                    'hyperspectral_'...
                    num2str(res_limit) '_px_'...
                    regexprep(datestr(datetime('now')),':','-') '.' extension...
                ];
    
    imwrite(I_RGB, [Photos.pathdir '\' fn_export])
    
    %% Spectra plot
    
    if show_spectra
    
        fig_size = [1000 400]; % px

        dp = round(size(I_RGB,2)/points_per_horizontal_dim); % px
        x = round(dp/2 : dp : size(I_RGB,2));
        y = round(dp/2 : dp : size(I_RGB,1));
        [X, Y] = meshgrid(x, y);

        size_orig = size(X);
        XY = [X(:), Y(:)];
        XY = sortrows(XY, [-2, 1]);
        X = reshape(XY(:,1), size_orig(1), size_orig(2));
        Y = reshape(XY(:,2), size_orig(1), size_orig(2));

        % Center X and Y
        margin_left = min(X(:));
        margin_right = size(I_RGB,2)-max(X(:));
        margin_bottom = min(Y(:));
        margin_top = size(I_RGB,1)-max(Y(:));
        X = X - round((margin_left-margin_right)/2);
        Y = Y - round((margin_bottom-margin_top)/2);

        figure(78)
            clf
            set(gcf,'color','white')
            pos = get(gcf,'position');
            set(gcf,'position', [pos(1:2) fig_size])
            subplot(1,2,1)
            pos = get(gca,'position');
            set(gca,'position',[0.03 0.02 0.45 1.00])
            hold on
            image(flipud(I_RGB))
            title('Simulated Image and Sample Mesh')
            axis equal
            axis tight
            axis off

            scatter(X(:), Y(:), 'wo','LineWidth',3)
            scatter(X(:), Y(:), 'ko','LineWidth',1)
    %         for p = 1 : numel(X)
    %             fill(X(p)+[1 1 0 0].*18+6, Y(p)+[1 0 0 1].*18-9, 'w','EdgeColor','none','FaceAlpha',0.5)
    %             text(X(p), Y(p)+1, ['  ' num2str(p)], 'Color','black', 'HorizontalAlignment','left','VerticalAlignment','middle')
    %         end

            subplot(1,2,2)
%             pos = get(gca,'position');
            set(gca,'position',[0.55 0.145 0.42 0.75])
            hold on
            for p = 1 : numel(X)
                plot(Observer.lambda, squeeze(DC(Y(p),X(p),:)),'Color',squeeze(I_RGB(Y(p),X(p),:)),'LineWidth',2)
            end
            grid on
            grid minor
            xlabel('Wavelength, nm')
            ylabel('Light Power, Dimensionless')
            title('Sample Mesh Spectra and Colors')
            
    end
    
    %% GIF of each wavelength
    
    if show_GIF
        
        lambda_vs_RGB = wavelength_vs_color(Observer.lambda); % get wavelength vs. color data
    
        % GIF parameters
        fig_width = 500; % px
        fs = 10; % font size

        fn_GIF = regexprep(fn_export, '\..+','.GIF');

        figure(77)
            clf
            set(gcf,'color','white')
            pos = get(gcf,'position');
            aspect_ratio = size(DC,2) / size(DC,1); % width/rect.height
            set(gcf,'position',[pos(1:2), fig_width.*[aspect_ratio, 1]])
            set(gca,'position',[0.05 0.05 0.89 0.90])

        for f = 1 : size(DC,3)

            % Show wavelength slice
            cla
            hold on
            pcolor(flipud(DC(:,:,f)))
            shading flat
            axis equal
            axis tight
            axis off
            colormap gray
            caxis([min(DC(:)), max(DC(:))])
            h = colorbar;
            set(get(h,'label'),'string','Light Power, Dimensionless');
            set(h,'FontSize',fs)
            title(['Wavelength: ' num2str(Observer.lambda(f)) ' ± ' num2str(abs(diff(Observer.lambda(1:2)))/2) ' nm'])

            % Show wavelength color
            rect.width = size(DC,2) / length(Observer.lambda); % px/nm
            rect.height = 25; % px
            rect.y_gap = 10; % px
            rect.x = [1 1 -1 -1] .* rect.width/2;
            rect.y = [1 0 0 1] .* rect.height - rect.height - rect.y_gap;
            for w = 1 : size(lambda_vs_RGB, 1)
                center = (Observer.lambda(w)-Observer.lambda(1)) / (Observer.lambda(end)-Observer.lambda(1)); % 0 to 1
                center = center * (size(DC,2)-rect.width) + rect.width/2;
                fill(rect.x + center, rect.y, lambda_vs_RGB(w,:), 'EdgeColor','none')
                if sum(w == 1 : 5 : length(Observer.lambda)) ~= 0
                    text(center, min(rect.y), [num2str(Observer.lambda(w)) ' nm'], 'HorizontalAlignment','center','VerticalAlignment','top','FontSize',fs)
                end
            end

            % Outline the current wavelength band
            center = (Observer.lambda(f)-Observer.lambda(1)) / (Observer.lambda(end)-Observer.lambda(1)); % 0 to 1
            center = center * (size(DC,2)-rect.width) + rect.width/2;
            plot([rect.x, rect.x(1)] + center, [rect.y, rect.y(1)], 'k', 'LineWidth', 2)

            drawnow

            % Capture the frame
            frame = getframe(gcf); 
            im = frame2im(frame); 
            [imind,cm] = rgb2ind(im,256);
            if f == 1
                imwrite(imind,cm, [Photos.pathdir '\' fn_GIF],'gif', 'Loopcount',inf,'DelayTime',1/GIF_fps);
            else 
                imwrite(imind,cm, [Photos.pathdir '\' fn_GIF],'gif','WriteMode','append','DelayTime',1/GIF_fps); 
            end

        end
        
    end

% end


















































