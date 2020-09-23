% function compare_camera_sensitivities

    clear
    clc

    %%
    
    lambda = 400 : 10 : 720; % nm

    Canon_300D = [
                    0.0074301, 0.0075795, 0.0083043, 0.0098831, 0.010432, 0.011028, 0.01193, 0.013319, 0.01075, 0.0071592, 0.007603, 0.0095502, 0.013374, 0.011634, 0.010348, 0.016463, 0.1081, 0.39461, 0.5796, 0.70646, 0.65966, 0.64128, 0.48616, 0.40497, 0.32996, 0.26965, 0.19645, 0.068429, 0.015261, 0.0062609, 0.002577, 0.00073993, 0.00018341
                    0.041477, 0.058, 0.072545, 0.10017, 0.1198, 0.16235, 0.23092, 0.36946, 0.45982, 0.50908, 0.69947, 0.84752, 0.99131, 0.99574, 0.93826, 0.88043, 0.67937, 0.57855, 0.4181, 0.29859, 0.15914, 0.083305, 0.039898, 0.025915, 0.018503, 0.012969, 0.010731, 0.0048377, 0.0016101, 0.00095847, 0.00056323, 0.00019049, 7.9922e-05
                    0.26332, 0.42981, 0.53966, 0.69805, 0.77811, 0.95757, 0.97645, 1, 0.94768, 0.84684, 0.7179, 0.49589, 0.31392, 0.17227, 0.09118, 0.041019, 0.014928, 0.0090299, 0.0055769, 0.0046034, 0.0024248, 0.0020683, 0.0016975, 0.0013351, 0.0017914, 0.0012195, 0.0018138, 0.00064544, 0.00019937, 0.00010163, 6.6623e-05, 2.6923e-05, 3.7135e-05
                 ];
             
%     Canon_450D = [
%                     0.03	0.02	0.01	0	0	0	0.01	0.01	0.02	0.02	0.04	0.06	0.07	0.09	0.12	0.17	0.23	0.37	0.59	0.78	0.77	0.8	0.87	0.82	0.77	0.83	0.77	0.69	0.65	0.6	0.62	0.63	0.58
%                     0.03	0.03	0.04	0.04	0.06	0.08	0.13	0.26	0.51	0.64	0.81	0.92	1.02	1.01	1.03	1	0.92	0.84	0.78	0.58	0.39	0.21	0.15	0.1	0.08	0.08	0.07	0.09	0.11	0.15	0.19	0.21	0.19
%                     0.24	0.34	0.46	0.5	0.64	0.71	0.77	0.75	0.73	0.67	0.5	0.39	0.26	0.16	0.13	0.1	0.07	0.06	0.06	0.05	0.03	0.02	0.02	0.02	0.02	0.03	0.04	0.04	0.04	0.05	0.05	0.05	0.04
%                  ];

    Canon_500D = [
                    0.0047882, 0.006503, 0.014181, 0.0090063, 0.0072716, 0.008399, 0.012928, 0.023407, 0.042132, 0.06015, 0.079772, 0.11068, 0.1296, 0.1528, 0.17491, 0.23995, 0.27103, 0.35363, 0.59207, 0.56519, 0.50552, 0.48372, 0.40474, 0.35005, 0.26818, 0.22628, 0.17275, 0.13367, 0.060161, 0.012976, 0.0026525, 0.00064602, 0.00064602
                    0.0063344, 0.01322, 0.056945, 0.072339, 0.10335, 0.12163, 0.16863, 0.33452, 0.58549, 0.72721, 0.82791, 0.94525, 0.93856, 1, 0.91351, 0.90129, 0.74393, 0.68775, 0.65043, 0.45765, 0.29386, 0.17488, 0.10517, 0.076, 0.053159, 0.042043, 0.032367, 0.029075, 0.016249, 0.0045584, 0.0010866, 0.00030439, 0.00030439
                    0.031083, 0.094291, 0.48083, 0.67493, 0.76173, 0.82236, 0.86969, 0.84873, 0.82207, 0.7235, 0.58539, 0.46393, 0.30706, 0.23495, 0.18321, 0.1615, 0.11978, 0.10939, 0.11367, 0.087972, 0.064425, 0.047167, 0.034519, 0.02963, 0.024397, 0.023239, 0.020503, 0.018144, 0.009073, 0.0022567, 0.00049182, 0.00014889, 0.00014889
                 ];

    Canon_600D = [
                    0.0018383, 0.0034546, 0.0065563, 0.0064237, 0.003663, 0.0032176, 0.0045901, 0.0075219, 0.015409, 0.022585, 0.033511, 0.053847, 0.066262, 0.082616, 0.10166, 0.15313, 0.2023, 0.29541, 0.4398, 0.53074, 0.51692, 0.50521, 0.38884, 0.34276, 0.26434, 0.22089, 0.1637, 0.13044, 0.072591, 0.021389, 0.003813, 0.00089247, 0.00023267
                    0.0027522, 0.0063568, 0.025923, 0.055392, 0.079072, 0.098383, 0.13411, 0.28424, 0.53216, 0.67504, 0.78346, 0.91032, 0.89359, 1, 0.88185, 0.85526, 0.76181, 0.71016, 0.56299, 0.44008, 0.27856, 0.16213, 0.078769, 0.052859, 0.035122, 0.026057, 0.018983, 0.01922, 0.014806, 0.005949, 0.0013347, 0.00034954, 0.00012156
                    0.010963, 0.047664, 0.25927, 0.6278, 0.69721, 0.78211, 0.8035, 0.78122, 0.75824, 0.64609, 0.513, 0.38666, 0.22351, 0.15669, 0.10477, 0.078029, 0.050767, 0.040953, 0.034064, 0.027857, 0.019411, 0.013821, 0.0088981, 0.0081423, 0.007593, 0.0084223, 0.008274, 0.0083911, 0.0053867, 0.0018156, 0.00036101, 0.00011979, 7.6506e-05
                 ];
             
	figure(20)
    clf
    hold on
    set(gcf,'color','white')
             
    for cc = 1:3
        
        switch cc
            case 1
                col = 'r';
            case 2
                col = 'g';
            case 3
                col = 'b';
        end
        
        plot(lambda, Canon_300D(cc,:), [col '-o'])
%         plot(lambda, Canon_450D(cc,:), 'r-o')
        plot(lambda, Canon_500D(cc,:), [col '-s'])
        plot(lambda, Canon_600D(cc,:), [col '-^'])
        
        grid on
        grid minor
        
        xlabel('Wavelength, nm')
        ylabel('Normalized Sensitivity, ~')
        title('Comparison of Canon Camera Spectral Sensitivities')
        
        
        
    end
    
    legend({'Canon 300D','Canon 500D','Canon 600D'}, 'location','northeast')
    
% end




















































