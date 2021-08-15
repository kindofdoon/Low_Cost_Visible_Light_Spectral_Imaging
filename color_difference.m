function dE = color_difference(Lab1, Lab2, method)

    % Returns the color difference, Delta_E, between two Lab colors
    
    % Inputs:
        % Lab1: [L, a, b] color
        % Lab2: [L, a, b] color
        % method: 'CIE76', 'CIE94', or 'CIEDE2000'
        
    % Output:
        % dE: color difference between Lab1 and Lab2

    % http://www.brucelindbloom.com/index.html?Eqn_DeltaE_CIE76.html
    % http://www.brucelindbloom.com/index.html?Eqn_DeltaE_CIE94.html
    % http://www.brucelindbloom.com/index.html?Eqn_DeltaE_CIE2000.html
    
    %%
    
    switch method
        
        case 'CIE76'
            dE = norm(Lab1-Lab2);
            
        case 'CIE94'
            L_1 = Lab1(1);
            a_1 = Lab1(2);
            b_1 = Lab1(3);
            
            L_2 = Lab2(1);
            a_2 = Lab2(2);
            b_2 = Lab2(3);
            
            dL = L_1 - L_2;
            C1 = sqrt(a_1^2 + b_1^2);
            C2 = sqrt(a_2^2 + b_2^2);
            dC = C1 - C2;
            da = a_1 - a_2;
            db = b_1 - b_2;
            dH = sqrt(da^2 + db^2 - dC^2);
            S_L = 1;
            K1 = 0.045; % graphic arts (not textiles)
            K2 = 0.015; % graphic arts (not textiles)
            S_C = 1 + K1*C1;
            S_H = 1 + K2*C1;
            K_L = 1; % default (not textiles)
            K_C = 1;
            K_H = 1;
            
            dE = sqrt((dL/(K_L*S_L))^2 + (dC/(K_C*S_C))^2 + (dH/(K_H*S_H))^2);
            
        case 'CIEDE2000'
            
            % Compute the CIEDE2000 color-difference between the sample between a reference
            % with CIELab coordinates Labsample and a standard with CIELab coordinates 
            % Labstd
            % The function works on multiple standard and sample vectors too
            % provided Labstd and Labsample are K x 3 matrices with samples and 
            % standard specification in corresponding rows of Labstd and Labsample
            % The optional argument KLCH is a 1x3 vector containing the
            % the value of the parametric weighting factors kL, kC, and kH
            % these default to 1 if KLCH is not specified.

            % Based on the article:
            % "The CIEDE2000 Color-Difference Formula: Implementation Notes, 
            % Supplementary Test Data, and Mathematical Observations,", G. Sharma, 
            % W. Wu, E. N. Dalal, Color Research and Application, vol. 30. No. 1, pp.
            % 21-30, February 2005.
            % available at http://www.ece.rochester.edu/~/gsharma/ciede2000/

            dE = [];
            Labstd = Lab1;
            Labsample = Lab2;
            KLCH = [1 1 1];

            % Error checking to ensure that sample and Std vectors are of correct sizes
            v=size(Labstd); w = size(Labsample);
            if ( v(1) ~= w(1) | v(2) ~= w(2) )
              disp('deltaE00: Standard and Sample sizes do not match');
              return
            end % if ( v(1) ~= w(1) | v(2) ~= w(2) )
            if ( v(2) ~= 3) 
              disp('deltaE00: Standard and Sample Lab vectors should be Kx3  vectors'); 
              return
            end 

            % Parametric factors 
            if (nargin <3 ) 
                 % Values of Parametric factors not specified use defaults
                 kl = 1; kc=1; kh =1;
            else
                 % Use specified Values of Parametric factors
                 if ( (size(KLCH,1) ~=1) | (size(KLCH,2) ~=3))
                   disp('deltaE00: KLCH must be a 1x3  vector');
                   return;
                else
                   kl =KLCH(1); kc=KLCH(2); kh =KLCH(3);
                 end
            end

            Lstd = Labstd(:,1)';
            astd = Labstd(:,2)';
            bstd = Labstd(:,3)';
            Cabstd = sqrt(astd.^2+bstd.^2);

            Lsample = Labsample(:,1)';
            asample = Labsample(:,2)';
            bsample = Labsample(:,3)';
            Cabsample = sqrt(asample.^2+bsample.^2);

            Cabarithmean = (Cabstd + Cabsample)/2;

            G = 0.5* ( 1 - sqrt( (Cabarithmean.^7)./(Cabarithmean.^7 + 25^7)));

            apstd = (1+G).*astd; % aprime in paper
            apsample = (1+G).*asample; % aprime in paper
            Cpsample = sqrt(apsample.^2+bsample.^2);
            Cpstd = sqrt(apstd.^2+bstd.^2);
            % Compute product of chromas and locations at which it is zero for use later
            Cpprod = (Cpsample.*Cpstd);
            zcidx = find(Cpprod == 0);


            % Ensure hue is between 0 and 2pi
            % NOTE: MATLAB already defines atan2(0,0) as zero but explicitly set it
            % just in case future definitions change
            hpstd = atan2(bstd,apstd);
            hpstd = hpstd+2*pi*(hpstd < 0);  % rollover ones that come -ve
            hpstd(find( (abs(apstd)+abs(bstd))== 0) ) = 0;
            hpsample = atan2(bsample,apsample);
            hpsample = hpsample+2*pi*(hpsample < 0);
            hpsample(find( (abs(apsample)+abs(bsample))==0) ) = 0;

            dL = (Lsample-Lstd);
            dC = (Cpsample-Cpstd);
            % Computation of hue difference
            dhp = (hpsample-hpstd);
            dhp = dhp - 2*pi* (dhp > pi );
            dhp = dhp + 2*pi* (dhp < (-pi) );
            % set chroma difference to zero if the product of chromas is zero
            dhp(zcidx ) = 0;

            % Note that the defining equations actually need
            % signed Hue and chroma differences which is different
            % from prior color difference formulae

            dH = 2*sqrt(Cpprod).*sin(dhp/2);
            %dH2 = 4*Cpprod.*(sin(dhp/2)).^2;

            % weighting functions
            Lp = (Lsample+Lstd)/2;
            Cp = (Cpstd+Cpsample)/2;
            % Average Hue Computation
            % This is equivalent to that in the paper but simpler programmatically.
            % Note average hue is computed in radians and converted to degrees only 
            % where needed
            hp = (hpstd+hpsample)/2;
            % Identify positions for which abs hue diff exceeds 180 degrees 
            hp = hp - ( abs(hpstd-hpsample)  > pi ) *pi;
            % rollover ones that come -ve
            hp = hp+ (hp < 0) *2*pi;
            % Check if one of the chroma values is zero, in which case set 
            % mean hue to the sum which is equivalent to other value
            hp(zcidx) = hpsample(zcidx)+hpstd(zcidx);

            Lpm502 = (Lp-50).^2;
            Sl = 1 + 0.015*Lpm502./sqrt(20+Lpm502);  
            Sc = 1+0.045*Cp;
            T = 1 - 0.17*cos(hp - pi/6 ) + 0.24*cos(2*hp) + 0.32*cos(3*hp+pi/30) ...
                -0.20*cos(4*hp-63*pi/180);
            Sh = 1 + 0.015*Cp.*T;
            delthetarad = (30*pi/180)*exp(- ( (180/pi*hp-275)/25).^2);
            Rc =  2*sqrt((Cp.^7)./(Cp.^7 + 25^7));
            RT =  - sin(2*delthetarad).*Rc;

            klSl = kl*Sl;
            kcSc = kc*Sc;
            khSh = kh*Sh;

            % The CIE 00 color difference
            dE = sqrt( (dL./klSl).^2 + (dC./kcSc).^2 + (dH./khSh).^2 + RT.*(dC./kcSc).*(dH./khSh) );
            
        otherwise
            error('Unrecognized method')
    end

end



















































