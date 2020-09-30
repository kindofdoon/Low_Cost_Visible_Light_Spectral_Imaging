% function scrape_datasheet_plots

    clear
    clc

    %%
    
    % Define domains
    dom_x = [360 740];
    dom_y = [0 100];
    
    x_out = 360 : 20 : 740;
    
    %%
    
    files = struct2cell(dir('*.jpg'));
    files = files(1,:)';
    
    T = nan(length(x_out), length(files));
            
    for i = 39 : length(files)% 1 : length(files)
        
        disp([num2str(i) ': ' files{i}])
        
        I = imread(files{i});
        I = flipud(I);
        
        I = rgb2gray(I);
        I = repmat(I, [1,1,3]);
        
        figure(1)
            clf
            hold on
            set(gcf,'color','white')
            I_crop1 = I(1:700, 1:700,:);
            image(I_crop1)
            axis equal
            axis tight
            set(gca,'position',[0 0 1 1])
            axis off

        [frame_x, frame_y] = ginput(2);
        frame_x = round(frame_x);
        frame_y = round(frame_y);
        
        I_crop2 = I_crop1(min(frame_y):max(frame_y), min(frame_x):max(frame_x), :);
        
        [X, Y] = meshgrid(1:size(I_crop2,2), 1:size(I_crop2,1));
        
        ind_dark = find(I_crop2(:,:,1) < 30);
        
        a = X(ind_dark);
        b = Y(ind_dark);
        
        % Non-dimensionalize to graph limits
        a = a ./ size(I_crop2,2); % 0 to 1
        b = b ./ size(I_crop2,1); % 0 to 1
        
        % Dimensionalize using domain limits
        a = a .* (max(dom_x)-min(dom_x)) + min(dom_x);
        b = b .* (max(dom_y)-min(dom_y)) + min(dom_y);
        
        AB = [a, b];
        AB = sortrows(AB, 1);
        
        figure(2)
            clf
            set(gcf,'color','white')
            hold on
            image(I_crop2)
            axis tight
            axis equal
            scatter(X(ind_dark), Y(ind_dark), 'y.')
            drawnow
        
        % Parse points
        x_uni = unique(AB(:,1));
        AB_ = zeros(length(x_uni),2);
        AB_(:,1) = x_uni;
        for x_ind = 1 : length(x_uni)
            val = x_uni(x_ind);
            AB_(x_ind,2) = mean(AB(find(AB(:,1)==val), 2));
        end
        AB = AB_;

        x = x_out;
        y = interp1(AB(:,1), AB(:,2), x_out, 'linear', 'extrap');
        XY = [x', y'];
        
        T(:,i) = y';
        
    end
    
% end



















































