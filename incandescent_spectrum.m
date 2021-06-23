% function incandescent_spectrum

    % Function to analytically estimate the radiative spectrum of an
    % incandescent lightbult, as if to replace a measurement made by a
    % spectrometer.

    % Sources:
        % https://en.wikipedia.org/wiki/Planck%27s_law
        % http://www.instesre.org/Solar/PyranometerProtocol/PyranometerProtocol.htm
        % https://physics.stackexchange.com/questions/432874/simple-computation-of-the-spectrum-of-the-blue-sky
        % 2012: The Color of the Sky, Frederic Zagury
    
    %%
        
    clear
    clc
    
    %%
    
    lam = 400 : 5 : 700; % nm

    
    %% Constants
    
    kB = 1.381e-23; % J/K, Boltzmann constant
    h = 6.626e-34;  % J-s, Planck constant
    c = 2.99792e8;  % m/s, speed of light
    
    %% Conversion factors
    
    m_to_nm = 1e9; % 1 m = 1e9 nm (nanometer)
    m_to_um = 1e6; % 1 m = 1e6 um (micrometer)
    
    %% Convert to SI
    
    lam = lam ./ m_to_nm; % nm to m
    
    %%

    figure(80)
        clf
        hold on
        set(gcf,'color','white')
    
    %%
    
    for T = 2700%[2700 4100]
    
        B = ((2.*h.*c.^2)./(lam.^5)) .* (1./(exp((h.*c)./(lam.*kB.*T))-1)); % Planck's law, blackbody radiator
        B = B ./ max(B(:)); % normalize

%         B = B .* 0.725;
        
        plot(lam .* m_to_nm, B, 'k')
        text(lam(end)*m_to_nm, B(end), [' ' num2str(T) ' K'],'HorizontalAlignment','left','VerticalAlignment','middle')

    end

    ylim([0 max(ylim)])
    grid on
    grid minor
%         set(gca,'yscale','log')
    xlabel('Wavelength, nm')
    ylabel('Spectral Power Distribution, ~')
    
% end



















































