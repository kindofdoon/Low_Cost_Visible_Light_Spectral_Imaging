% function test_power_vs_photons

    %%
    
    % The SI unit of radiance is the watt per steradian per square metre
    % (W新r?1搶?2), while that of spectral radiance in frequency is the
    % watt per steradian per square metre per hertz (W新r?1搶?2廈z?1)
    % and that of spectral radiance in wavelength is the watt per
    % steradian per square metre per metre (W新r?1搶?3) - commonly the
    % watt per steradian per square metre per nanometre (W新r?1搶?2搖m?1)
    
    % https://en.wikipedia.org/wiki/Radiance

    %%
        
    clear
    clc
    
    %%
    
    wavelength = 400 : 5 : 700; % nm
    T = 2700; % K
    
    %% Constants
    
    k = 1.381e-23; % J/K, Boltzmann constant
    h = 6.626e-34;  % J-s, Planck constant
    c = 2.99792e8;  % m/s, speed of light
    
    %% Conversion factors
    
    m_to_nm = 1e9; % 1 m = 1e9 nm (nanometer)
    m_to_um = 1e6; % 1 m = 1e6 um (micrometer)
    
    %% Convert to SI
    
    wavelength = wavelength ./ m_to_nm; % nm to m
    
    %%
    
    v = c ./ wavelength; % Hz, or s^-1, frequency
    
    %%
    
    % https://en.wikipedia.org/wiki/Planck%27s_law#The_law
    spectral_radiance = ((2.*h.*c.^2)./(wavelength.^5)) .* (1./(exp((h.*c)./(wavelength.*k.*T))-1)); % per unit wavelength
    
    radiance = spectral_radiance .* wavelength;
    
    % https://en.wikipedia.org/wiki/Black-body_radiation#Planck's_law_of_black-body_radiation
%     spectral_radiance = ((2.*h*v.^3)/(c.^2)) .* (1 ./ (exp((h.*v)./(k.*T))-1)); % per unit frequency

    spectral_radiance = spectral_radiance ./ spectral_radiance(1);
    radiance = radiance ./ radiance(1);

    %%
    
    figure(80)
        clf
        hold on
        set(gcf,'color','white')
        plot(wavelength .* m_to_nm, spectral_radiance, 'k')
        plot(wavelength .* m_to_nm, radiance, 'k--')
        ylim([0 max(ylim)])
        grid on
        grid minor
        xlabel('Wavelength, nm')
        ylabel('Relative Value, ~')
        legend({'Spectral Radiance, W-sr^{-1}-m^{-3}', 'Radiance, W-sr^{-1}-m^{-2}'}, 'location','northwest')
        title('Comparison of Spectral Radiance vs. Radiance for CIE Illuminant A')

% end


















































