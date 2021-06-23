% function blue_sky_spectrum

    % Function to analytically estimate the radiative spectrum of diffuse
    % clear blue sky at noon, as if to replace a measurement made by a
    % pyranometer or spectrometer.

    % Sources:
        % https://en.wikipedia.org/wiki/Planck%27s_law
        % http://www.instesre.org/Solar/PyranometerProtocol/PyranometerProtocol.htm
        % https://physics.stackexchange.com/questions/432874/simple-computation-of-the-spectrum-of-the-blue-sky
        % 2012: The Color of the Sky, Frederic Zagury
    
    %%
        
    clear
    clc
    
    %%
    
    lam = 350 : 5 : 750; % nm
    
    %% Constants
    
    k = 1.381e-23; % J/K, Boltzmann constant
    h = 6.626e-34;  % J-s, Planck constant
    c = 2.99792e8;  % m/s, speed of light
    T = 6500;       % K, absolute temperature
    
    a = 5e-27;%0.005;
    p = 1.3;
%     b = 4.5e-7;%0.45;
    
    %% Conversion factors
    
    m_to_nm = 1e9; % 1 m = 1e9 nm (nanometer)
    m_to_um = 1e6; % 1 m = 1e6 um (micrometer)
    
    %% Convert to SI
    
    lam = lam ./ m_to_nm;
    
    %%
    
    B = ((2.*h.*c.^2)./(lam.^5)) .* (1./(exp((h.*c)./(lam.*k.*T))-1)); % Planck's law, blackbody radiator
    
%     B = B .* lam.^-4; % Rayleigh scattering
    
%     x = exp(-a./lam.^4);
%     y = exp(-b./lam.^p);
%     B = B .* x;% .* y; % Mie scattering

    B = B ./ max(B(:)); % normalize
    
    %%
    
    figure(1)
        clf
        set(gcf,'color','white')
        plot(lam .* m_to_nm, B, 'k')
        ylim([0 max(ylim)])
        grid on
        grid minor
%         set(gca,'yscale','log')

% end



















































