% function sensor_distance_study

    % Study on the distance between sensor bottom and measured brightness
    
    dz = [ % in, glass thickness, i.e. distance between sensor and reflector
            0
            0.068
            0.230
         ];
     
    L = [ % Lab L value
            92.9
            88.5
            80.3
        ];
    
    x = 0.023; % in, glass thickness to query
    
    figure(30)
    clf
    hold on
    set(gcf,'color','white')
    plot(dz, L, 'k-o')
    grid on
    grid minor
    
    xlabel('Glass thickness, i.e. distance between sensor and reflector, in')
    ylabel('Measured Lab color L value, ~')
    title('Measured Brightness vs. Sensor-Reflector Distance')
    
    y = interp1(dz, L, x);
    frac = y/max(L);
    scatter(x, y, 'ks')
    text(x, y, ['  Interpolated: (' num2str(x) '", ' num2str(round(y*100)/100) '), ' num2str(round(y/max(L)*10000)/100) '% efficiency'], 'HorizontalAlignment','left','VerticalAlignment','middle')

% end