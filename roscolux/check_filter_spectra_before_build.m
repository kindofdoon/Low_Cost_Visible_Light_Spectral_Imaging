% function check_filter_spectra_before_build

    % The purpose of this function is to check that spectra are in
    % agreement between MATLAB and the scraped datasheets
    
    %%
    
    clear
    clc
    
    check_list = {
        
    % KNOWN BAD
%                     '3405' % _roscosun-85n.3
%                     '19_fire'
%                     '25_orange-red'
%                     '42_deep-salmon'
    

    
    % KNOWN GOOD
%                     '47_light-rose-purple'
%                     '373_theatre-booster-3'
%                     '81_urban-blue'
%                     '73_peacock-blue'
%                     '363_aquamarine'
%                     '86_pea-green'
%                     '86_pea-green'
%                     '313_light-relief-yellow'
%                     '49_medium-purple'
%                     '93_blue-green'
%                     '2007_storaro-blue'
%                     '369_tahitian-blue'
%                     '389_chroma-green'
%                     '363_aquamarine'
%                     '2003_storaro-yellow'
%                     '386_leaf-green'
%                     '3407' % _roscosun-cto
%                     '4315_calcolor-15-cyan'
%                     '346_tropical-magenta'
%                     '313_light-relief-yellow'
%                     '317_apricot'
%                     '99_chocolate'
%                     '342_rose-pink'
%                     '49_medium-purple'
%                     '2003_storaro-yellow'
%                     '324_gypsy-red'

                 };
             
    %%
    
    check_list = unique(check_list);
    
    Filters = load_roscolux_filters(0);
    
    dir_orig = pwd;
    dir_ds   = [pwd '\datasheets'];
    cd(dir_ds)
    files = struct2cell(dir('*.jpg'));
    files = files(1,:)';
    cd(dir_orig)
    
    %%
    
    for f = 1 : length(check_list)
        
        % Find data
        i_data = 1;
        while isempty(strfind(Filters.name{i_data}, check_list{f})) && i_data<=length(Filters.name)
            i_data = i_data + 1;
        end
        if i_data > length(Filters.name)
            error([check_list{f} ' data not found'])
        end
        
        % Find datasheet
        i_sheet = 1;
        while isempty(strfind(files{i_sheet}, check_list{f})) && i_sheet<=length(files)
            i_sheet = i_sheet + 1;
        end
        if i_sheet > length(files)
            error([check_list{f} ' datasheet not found'])
        end
        
        disp([check_list{f} ': booklet index ' num2str(Filters.booklet_index(i_data))])
        
        figure(1)
            clf
            hold on
            set(gcf,'color','white')
            plot(Filters.lambda, Filters.T(i_data,:).*100, 'Color', Filters.RGB(i_data,:), 'LineWidth', 2)
            xlabel('Wavelength, nm')
            ylabel('Transmission Fraction, 0-1, ~')
            axis([min(Filters.lambda) max(Filters.lambda) 0 100])
            grid on
            grid minor
            set(gca,'ytick',0:10:100)
            title(regexprep(Filters.name{i_data},'\_','\\_'))
        
        cd(dir_ds)
        I = imread(files{i_sheet});
        figure(2)
            clf
            set(gcf,'color','white')
            image(I)
            axis tight
            axis equal
            axis off
            set(gca,'position',[0 0 1 1])
            title(regexprep(files{i_sheet},'\_','\\_'))
            
        cd(dir_orig)
        
        pause
        
    end
    

% end



















































