% function test_linear_dependence

    clear
    clc
    
    %%
    
    lambda = (400 : 10 : 700)'; % nm, the standard wavelength domain to be used throughout
    
    Camera.lambda = 400 : 10 : 720;
    Camera.RGB_observer = [ % Canon 600D
                    0.0018383, 0.0034546, 0.0065563, 0.0064237, 0.003663, 0.0032176, 0.0045901, 0.0075219, 0.015409, 0.022585, 0.033511, 0.053847, 0.066262, 0.082616, 0.10166, 0.15313, 0.2023, 0.29541, 0.4398, 0.53074, 0.51692, 0.50521, 0.38884, 0.34276, 0.26434, 0.22089, 0.1637, 0.13044, 0.072591, 0.021389, 0.003813, 0.00089247, 0.00023267
                    0.0027522, 0.0063568, 0.025923, 0.055392, 0.079072, 0.098383, 0.13411, 0.28424, 0.53216, 0.67504, 0.78346, 0.91032, 0.89359, 1, 0.88185, 0.85526, 0.76181, 0.71016, 0.56299, 0.44008, 0.27856, 0.16213, 0.078769, 0.052859, 0.035122, 0.026057, 0.018983, 0.01922, 0.014806, 0.005949, 0.0013347, 0.00034954, 0.00012156
                    0.010963, 0.047664, 0.25927, 0.6278, 0.69721, 0.78211, 0.8035, 0.78122, 0.75824, 0.64609, 0.513, 0.38666, 0.22351, 0.15669, 0.10477, 0.078029, 0.050767, 0.040953, 0.034064, 0.027857, 0.019411, 0.013821, 0.0088981, 0.0081423, 0.007593, 0.0084223, 0.008274, 0.0083911, 0.0053867, 0.0018156, 0.00036101, 0.00011979, 7.6506e-05
                 ]';
             
    OBS = [0.188235 0.000000 0.000000 0.400000 0.027451 0.000000 0.192157 0.070588 0.003922 0.352941 0.266667 0.066667 0.062745 0.117647 0.047059 0.027451 0.109804 0.286275 0.231373 0.137255 0.219608 0.392157 0.019608 0.098039 0.164706 0.121569 0.109804]';
    
    %% Parse inputs
    
    [Observer, ~, Filters] = prepare_filters(lambda, 0, 0);
    
    qty_lam = length(Observer.lambda); % number of wavelength indices
    qty_fil = size(Filters.T,2);
    
    % Resample camera
    O = zeros(qty_lam, size(Camera.RGB_observer,2));
    for cc = 1 : size(Camera.RGB_observer,2)
        O(:,cc) = spline(Camera.lambda, Camera.RGB_observer(:,cc), Observer.lambda);
    end
    Camera.RGB_observer = O';
    Camera.lambda = Observer.lambda;
    
    %% Generate sensitivity matrix
    
    SEN = ones(qty_fil * 3, qty_lam);
    SEN = SEN .* repmat(Camera.RGB_observer, [qty_fil, 1]);
    f = 1;
    for row = 1 : 3 : size(SEN,1)
        SEN(row:row+2,:) = SEN(row:row+2,:) .* repmat(Filters.T(:,f)',[3,1]);
        f = f + 1;
    end

    %%
    
    [coeff,score,latent,tsquared,explained,mu] = pca(SEN);
    explained = explained ./ 100;
    
    PCA_thresh = 0.99;
    PCA_qty = min(find(cumsum(explained) > PCA_thresh));
    
    COEFF = coeff(:,1:PCA_qty);
    
    T = SEN * COEFF;
    M = inv(T'*T)*T';
    b = M * OBS; % result in PCA basis
    
    POW = sum(COEFF .* repmat(b', [qty_lam, 1]), 2); % result in original basis
    
    figure(22)
        clf
        set(gcf,'color','white')
        plot(Observer.lambda, POW, 'k')
        grid on
        grid minor
        xlabel('Wavelength, nm')
        ylabel('Light Power, ~')
    
    OBS_ = SEN * POW;
    
    %%
    
    figure(20)
        clf
        hold on
        set(gcf,'color','white')
        plot(0:length(explained), [0; cumsum(explained)], 'k-o')
        fill([max(xlim) max(xlim) PCA_qty PCA_qty], [max(ylim) min(ylim) min(ylim) max(ylim)], zeros(1,3)+0.5, 'FaceAlpha', 0.25, 'EdgeColor', 'none')
        ylim([0 1])
        grid on
        grid minor
        xlabel('PCA Component Number')
        ylabel('Cumulative Explanative Ability')
    
    figure(21)
        clf
        set(gcf,'color','white')
        image(repmat(coeff./max(coeff(:)), [1,1,3]))
        colorbar
        colormap gray
        axis equal; axis tight
    
    figure(22)
        clf
        set(gcf,'color','white')
        image(repmat(COEFF./max(COEFF(:)), [1,1,3]))
        colorbar
        colormap gray
        axis equal; axis tight
        
    figure(23)
        clf
        set(gcf,'color','white')
        image(repmat([OBS, OBS_]./max([max(OBS(:)),max(OBS_(:))]), [1 1 3]))
        colorbar
        colormap gray
%         axis equal; axis tight
    
	figure(24)
        clf
        set(gcf,'color','white')
        m = sum(COEFF,2);
        image(repmat(m./max(m(:)), [1,1,3]))
        colorbar
        colormap gray
%         axis equal; axis tight
        
% end


















































