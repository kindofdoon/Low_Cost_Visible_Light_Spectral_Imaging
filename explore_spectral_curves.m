% function explore_spectral_curves

    clear
    clc
    
    %% Inputs

    [Observer, Illuminant, Filters] = prepare_filters(0);


    Camera.RGB_observer = [ % Canon_300D
                    0.0074301, 0.0075795, 0.0083043, 0.0098831, 0.010432, 0.011028, 0.01193, 0.013319, 0.01075, 0.0071592, 0.007603, 0.0095502, 0.013374, 0.011634, 0.010348, 0.016463, 0.1081, 0.39461, 0.5796, 0.70646, 0.65966, 0.64128, 0.48616, 0.40497, 0.32996, 0.26965, 0.19645, 0.068429, 0.015261, 0.0062609, 0.002577, 0.00073993, 0.00018341
                    0.041477, 0.058, 0.072545, 0.10017, 0.1198, 0.16235, 0.23092, 0.36946, 0.45982, 0.50908, 0.69947, 0.84752, 0.99131, 0.99574, 0.93826, 0.88043, 0.67937, 0.57855, 0.4181, 0.29859, 0.15914, 0.083305, 0.039898, 0.025915, 0.018503, 0.012969, 0.010731, 0.0048377, 0.0016101, 0.00095847, 0.00056323, 0.00019049, 7.9922e-05
                    0.26332, 0.42981, 0.53966, 0.69805, 0.77811, 0.95757, 0.97645, 1, 0.94768, 0.84684, 0.7179, 0.49589, 0.31392, 0.17227, 0.09118, 0.041019, 0.014928, 0.0090299, 0.0055769, 0.0046034, 0.0024248, 0.0020683, 0.0016975, 0.0013351, 0.0017914, 0.0012195, 0.0018138, 0.00064544, 0.00019937, 0.00010163, 6.6623e-05, 2.6923e-05, 3.7135e-05
                 ];
             
    %% Resample domain(s)
    
    O = zeros(size(Camera.RGB_observer,1), length(Observer.lambda));
    for cc = 1 : size(Camera.RGB_observer,1)
        O(cc,:) = resample_and_extrapolate(400:10:720, Camera.RGB_observer(cc,:), Observer.lambda);
    end
    Camera.RGB_observer = O';
    
    Camera.RGB_observer(Camera.RGB_observer < 0.05) = NaN;
    
    %%
    
    figure(1)
        clf
        hold on
        set(gcf,'color','white')
    
    %%
    
    S = zeros(length(Observer.lambda), Filters.qty * 3);
    
    col = 1;
    
    for f = 1 : Filters.qty
       
        for cc = 1 : 3
            
            S(:,col) = Filters.T(:,f) .* Camera.RGB_observer(:,cc);
            
            c = [0 0 0];
            c(cc) = 1;
            plot(Observer.lambda, S(:,col), 'Color', c, 'LineWidth', 2)
            
            col = col + 1;
            
        end
        
    end
    
    grid on
    grid minor
    xlabel('Wavelength, nm')
    ylabel('Spectral Sensitivity, ~')
    title('Spectral Sensitivity of Filter Set With Camera')
    
    %%
    
    figure(2)
        clf
        hold on
        set(gcf,'color','white')
        for cc = 1 : 3
            c = [0 0 0];
            c(cc) = 1;
            
            y = Camera.RGB_observer(:,cc);
            
            y_inv = 1./y;
%             y_inv(y < 0.05) = NaN;
            
            plot(Observer.lambda, y, 'Color', c, 'LineWidth', 2)
            plot(Observer.lambda, y_inv, 'Color', c, 'LineWidth', 2)
            
        end
        xlabel('Wavelength, nm')
        ylabel('Spectral Sensitivity, ~')
        title('Camera Observer Functions')
        grid on
        grid minor
        

% end



















































