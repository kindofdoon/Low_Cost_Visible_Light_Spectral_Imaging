% function observer_domain

    % This function visualizes how much area is under the CIE standard
    % observer function curves, as a function of the domain limits. This is
    % intended to provide some intuition about reasonable "stopping"
    % points, or points past which there is no appreciable contribution to
    % perceived color.

    %%
    
    clear
    clc
    
    %% Inputs
    
    i_ob    = 1;
    lambda  = 360 : 1 : 830; % nm, full domain
    lam_lim = [420 660]; % nm, domain subset
    
    % Graphics
    fs         = 12; % font size

    %%

    Observer.lambda = 360 : 5 : 830; % nm
    switch i_ob
        % Data source: http://cvrl.ioo.ucl.ac.uk/index.htm
        case 1
            desc = 'CIE 1931 2° XYZ';
            ob_sen = [
                        0.0001299 0.0002321 0.0004149 0.0007416 0.001368 0.002236 0.004243 0.00765 0.01431 0.02319 0.04351 0.07763 0.13438 0.21477 0.2839 0.3285 0.34828 0.34806 0.3362 0.3187 0.2908 0.2511 0.19536 0.1421 0.09564 0.05795001 0.03201 0.0147 0.0049 0.0024 0.0093 0.0291 0.06327 0.1096 0.1655 0.2257499 0.2904 0.3597 0.4334499 0.5120501 0.5945 0.6784 0.7621 0.8425 0.9163 0.9786 1.0263 1.0567 1.0622 1.0456 1.0026 0.9384 0.8544499 0.7514 0.6424 0.5419 0.4479 0.3608 0.2835 0.2187 0.1649 0.1212 0.0874 0.0636 0.04677 0.0329 0.0227 0.01584 0.01135916 0.008110916 0.005790346 0.004109457 0.002899327 0.00204919 0.001439971 0.0009999493 0.0006900786 0.0004760213 0.0003323011 0.0002348261 0.0001661505 0.000117413 8.307527E-05 5.870652E-05 4.150994E-05 2.935326E-05 2.067383E-05 1.455977E-05 1.025398E-05 7.221456E-06 5.085868E-06 3.581652E-06 2.522525E-06 1.776509E-06 1.251141E-06
                        3.917E-06 6.965E-06 1.239E-05 2.202E-05 3.9E-05 6.4E-05 0.00012 0.000217 0.000396 0.00064 0.00121 0.00218 0.004 0.0073 0.0116 0.01684 0.023 0.0298 0.038 0.048 0.06 0.0739 0.09098 0.1126 0.13902 0.1693 0.20802 0.2586 0.323 0.4073 0.503 0.6082 0.71 0.7932 0.862 0.9148501 0.954 0.9803 0.9949501 1 0.995 0.9786 0.952 0.9154 0.87 0.8163 0.757 0.6949 0.631 0.5668 0.503 0.4412 0.381 0.321 0.265 0.217 0.175 0.1382 0.107 0.0816 0.061 0.04458 0.032 0.0232 0.017 0.01192 0.00821 0.005723 0.004102 0.002929 0.002091 0.001484 0.001047 0.00074 0.00052 0.0003611 0.0002492 0.0001719 0.00012 8.48E-05 6E-05 4.24E-05 3E-05 2.12E-05 1.499E-05 1.06E-05 7.4657E-06 5.2578E-06 3.7029E-06 2.6078E-06 1.8366E-06 1.2934E-06 9.1093E-07 6.4153E-07 4.5181E-07
                        0.0006061 0.001086 0.001946 0.003486 0.006450001 0.01054999 0.02005001 0.03621 0.06785001 0.1102 0.2074 0.3713 0.6456 1.0390501 1.3856 1.62296 1.74706 1.7826 1.77211 1.7441 1.6692 1.5281 1.28764 1.0419 0.8129501 0.6162 0.46518 0.3533 0.272 0.2123 0.1582 0.1117 0.07824999 0.05725001 0.04216 0.02984 0.0203 0.0134 0.008749999 0.005749999 0.0039 0.002749999 0.0021 0.0018 0.001650001 0.0014 0.0011 0.001 0.0008 0.0006 0.00034 0.00024 0.00019 1E-04 4.999999E-05 3E-05 2E-05 1E-05 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                     ];

        case 2
            desc = 'CIE 1964 10° XYZ';
            ob_sen = [
                        1.222E-07 9.1927E-07 5.9586E-06 3.3266E-05 0.000159952 0.00066244 0.0023616 0.0072423 0.0191097 0.0434 0.084736 0.140638 0.204492 0.264737 0.314679 0.357719 0.383734 0.386726 0.370702 0.342957 0.302273 0.254085 0.195618 0.132349 0.080507 0.041072 0.016172 0.005132 0.003816 0.015444 0.037465 0.071358 0.117749 0.172953 0.236491 0.304213 0.376772 0.451584 0.529826 0.616053 0.705224 0.793832 0.878655 0.951162 1.01416 1.0743 1.11852 1.1343 1.12399 1.0891 1.03048 0.95074 0.856297 0.75493 0.647467 0.53511 0.431567 0.34369 0.268329 0.2043 0.152568 0.11221 0.0812606 0.05793 0.0408508 0.028623 0.0199413 0.013842 0.00957688 0.0066052 0.00455263 0.0031447 0.00217496 0.0015057 0.00104476 0.00072745 0.000508258 0.00035638 0.000250969 0.00017773 0.00012639 9.0151E-05 6.45258E-05 4.6339E-05 3.34117E-05 2.4209E-05 1.76115E-05 1.2855E-05 9.41363E-06 6.913E-06 5.09347E-06 3.7671E-06 2.79531E-06 2.082E-06 1.55314E-06
                        1.3398E-08 1.0065E-07 6.511E-07 3.625E-06 1.7364E-05 7.156E-05 0.0002534 0.0007685 0.0020044 0.004509 0.008756 0.014456 0.021391 0.029497 0.038676 0.049602 0.062077 0.074704 0.089456 0.106256 0.128201 0.152761 0.18519 0.21994 0.253589 0.297665 0.339133 0.395379 0.460777 0.53136 0.606741 0.68566 0.761757 0.82333 0.875211 0.92381 0.961988 0.9822 0.991761 0.99911 0.99734 0.98238 0.955552 0.915175 0.868934 0.825623 0.777405 0.720353 0.658341 0.593878 0.527963 0.461834 0.398057 0.339554 0.283493 0.228254 0.179828 0.140211 0.107633 0.081187 0.060281 0.044096 0.0318004 0.0226017 0.0159051 0.0111303 0.0077488 0.0053751 0.00371774 0.00256456 0.00176847 0.00122239 0.00084619 0.00058644 0.00040741 0.000284041 0.00019873 0.00013955 9.8428E-05 6.9819E-05 4.9737E-05 3.55405E-05 2.5486E-05 1.83384E-05 1.3249E-05 9.6196E-06 7.0128E-06 5.1298E-06 3.76473E-06 2.77081E-06 2.04613E-06 1.51677E-06 1.12809E-06 8.4216E-07 6.297E-07
                        5.35027E-07 4.0283E-06 2.61437E-05 0.00014622 0.000704776 0.0029278 0.0104822 0.032344 0.0860109 0.19712 0.389366 0.65676 0.972542 1.2825 1.55348 1.7985 1.96728 2.0273 1.9948 1.9007 1.74537 1.5549 1.31756 1.0302 0.772125 0.57006 0.415254 0.302356 0.218502 0.159249 0.112044 0.082248 0.060709 0.04305 0.030451 0.020584 0.013676 0.007918 0.003988 0.001091 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                     ];

    end

    ob_sen = ob_sen';
    S = zeros(length(lambda), 3);
    for cc = 1 : 3
        S(:,cc) = interp1(Observer.lambda, ob_sen(:,cc), lambda);
    end

    S_sum = sum(S,2);
    
    %%
    
    ob_sum = sum(ob_sen,2);
    ob_sum_cumsum = cumsum(ob_sum);
    ob_sum_cumsum = ob_sum_cumsum ./ max(ob_sum_cumsum);
    
    lam_round = 10; % nm
    
    figure(3)
        clf
        hold on
        set(gcf,'color','white')
        plot(Observer.lambda, ob_sum_cumsum, 'k')
        lam_center = interp1(ob_sum_cumsum, Observer.lambda, 0.5);
        lam_center = round(lam_center/lam_round)*lam_round;
        xlabel('Wavelength, nm')
        ylabel('CDF of Observer Functions, 0-1')
        grid on
        grid minor
%         title({
%                 'Wavelength Centroid of Visible Light Spectrum\rm\fontsize{10}'
%                 ['Per ' desc ' Observer, Rounding: ' num2str(lam_round) ' nm']
%              })
         xlim([min(Observer.lambda) max(Observer.lambda)])
         lam_center_y = interp1(Observer.lambda, ob_sum_cumsum, lam_center);
         scatter(lam_center, lam_center_y, 'ko')
         text(lam_center, lam_center_y, ['  ' num2str(lam_center) ' nm, ' num2str(round(lam_center_y*100)) '%'],'HorizontalAlignment','left','VerticalAlignment','middle', 'FontSize', fs)
         set(gca,'FontSize',fs)
         
    
    %%
    
    figure(1)
        clf
        hold on
        set(gcf,'color','white')
        S_copy = S;
        lam_res = abs(mean(diff(Observer.lambda)));
        
        area_under_CDF = sum(ob_sum_cumsum);
        area_under_obs = sum(S(:));
        
%         S_copy = S_copy ./ (area_under_obs/area_under_CDF);

        for cc = 1 : 3
            col = [0 0 0];
            col(cc) = 1;
            plot(lambda, S(:,cc)./max(S(:)), 'Color', col,'LineWidth',1.5)
        end
        plot(Observer.lambda, ob_sum_cumsum, '-', 'Color', zeros(1,3)+0.5, 'LineWidth', 2)
        
        text(lam_center, max(ylim), [num2str(lam_center) ' nm'], 'HorizontalAlignment','center','VerticalAlignment','bottom')
        
%         plot(lambda, S_sum, 'Color', zeros(1,3)+0.5, 'LineWidth',2)
        plot(zeros(1,2)+lam_center,   ylim, 'k--')
%         plot(zeros(1,2)+min(lam_lim), ylim, 'k--')
%         plot(zeros(1,2)+max(lam_lim), ylim, 'k--')
%         text(min(lam_lim), max(ylim), [num2str(min(lam_lim)) ' nm '],'Rotation', 90,'HorizontalAlignment','right','VerticalAlignment','bottom')
%         text(max(lam_lim), max(ylim), [num2str(max(lam_lim)) ' nm '],'Rotation', 90,'HorizontalAlignment','right','VerticalAlignment','bottom')
        
%         set(gca,'ytick',0:0.25:1)

        grid on
        grid minor
        xlabel('Wavelength, nm')
        ylabel('Sensitivity, ~')
%         title(['Observer: ' desc])
        xlim([min(lambda) max(lambda)])
        ylim([0 max(ylim)])
        legend({'$\bar{x}$','$\bar{y}$','$\bar{z}$','CDF($\bar{x}+\bar{y}+\bar{z}$)'},'location','east','Interpreter','Latex','FontSize',12)
        set(gca,'FontSize', fs)
        

    %%
        
    [~, i_center] = min(abs(lambda-lam_center));
    
    qty = (min([i_center, length(lambda)-i_center])-1);
    S_frac = zeros(qty+1,1);
    lo = zeros(qty+1,1);
    hi = zeros(qty+1,1);
    
    for i_win = 0 : qty
        
        ind = (i_center-i_win) : (i_center+i_win);
        S_frac(i_win+1) = sum(S_sum(ind)) / sum(S_sum);
        lo(i_win+1)     = lambda(min(ind));
        hi(i_win+1)     = lambda(max(ind));
        
    end
    
    width = hi - lo;
    
    figure(2)
        clf
        hold on
        set(gcf,'color','white')
        plot(width, S_frac, 'k')
        grid on
        grid minor
        x = abs(diff(lam_lim));
        y = interp1(width, S_frac, x);
        scatter(x, y, 'ko')
        plot([x x], [0 y], 'Color', zeros(1,3)+0.5)
        plot([0 x], [y y], 'Color', zeros(1,3)+0.5)
        text(x, y, {[' ' num2str(x) ' nm, ' num2str(round(y*1000)/10) '%'],[' ' num2str(min(lam_lim)) ' to ' num2str(max(lam_lim)) ' nm']}, 'HorizontalAlignment','left','VerticalAlignment','top')

    xlabel(['Sensor Domain Width, Centered on ' num2str(lam_center) ' nm, ~'])
    ylabel('Fraction of Observer Area Covered, ~')

% end


















































