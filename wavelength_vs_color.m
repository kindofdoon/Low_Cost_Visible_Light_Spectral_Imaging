function RGB = wavelength_vs_color(lambda)

    %%

%     clear
%     clc

    %% Inputs
    
%     lambda = 400 : 5 : 700;
    
    %% Constants
    
%     XYZ_lims = [0, 1.0888]; % absolute limits of the color space
    Lab_lims = [100, 128, 128];
    
    %%
    
    addpath('C:\Users\Daniel\Desktop\PAINTERS_COPILOT\')
    [Observer, ~, ~] = prepare_studio(0);
    
    %%
    
    ql = length(lambda); % quantity, lambda
    
    Or = zeros(ql, 3);
    for cc = 1 : 3
        Or(:,cc) = spline(Observer.lambda, Observer.responses(:,cc), lambda);
    end
    Observer.responses = Or;
    Observer.lambda = lambda;
    
    XYZ = zeros(ql, 3);
    RGB = zeros(ql, 3);
    Lab = zeros(ql, 3);
    
    for w = 1 : ql
        
        % Generate narrow-band power spectrum
        P = zeros(ql, 1);
        P(w) = 1;
        
        for cc = 1 : 3
            XYZ(w,cc) = dot(Observer.responses(:,cc), P);
        end
        
    end
    
    %%
    
%     XYZ = (XYZ-min(XYZ(:))) ./ (max(XYZ(:))-min(XYZ(:))); % 0 to 1
%     XYZ = XYZ .* (max(XYZ_lims)-min(XYZ_lims)) + min(XYZ_lims); % scale to absolute limits
    
    for w = 1 : ql
        Lab(w,:) = xyz2lab(XYZ(w,:), 'WhitePoint', 'D65');
    end
    
    Lab(:,1) = Lab(:,1)/max(Lab(:,1)) .* 70 + 15;
    ab = Lab(:,2:3);
    Lab(:,2:3) = ab .* (Lab_lims(2)/max(ab(:))) .* 0.80;
    
    for w = 1 : ql
        RGB(w,:) = lab2rgb(Lab(w,:),'WhitePoint', 'D65');
    end
    
    RGB(RGB<0) = 0;
    RGB(RGB>1) = 1;
    
    %%
    
    return
    
    dl = abs(diff(lambda(1:2)))/2;
    rect.x = dl.*[1 1 -1 -1];
    rect.y = [1 0 0 1];
    
    figure(95)
        clf
        hold on
        set(gcf,'color','white')
        for w = 1 : ql
            fill(rect.x + lambda(w), rect.y, RGB(w,:), 'EdgeColor','none')
        end
        axis tight
    
end



















































