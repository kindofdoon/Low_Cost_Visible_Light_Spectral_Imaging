function create_RAW_previews(path, file_start, file_stop, overwrite, sensor_alignment)

    % A simple function to create and save .JPG previews of RAW files,
    % e.g. .CR2 or .CRW
    
    % Operates on numerically sequential set of RAW files defined by
    % file_start and file_stop
    
    %% Dummy inputs
    
%     path       = 'C:\Users\Daniel\Desktop\hyperspectral_imaging\photos';
%     file_start = 'CRW_4523.CRW';
%     file_stop  = ''; % leave empty if unnecessary
%     overwrite  = 1; % set to 1 to overwrite existing RAW previews
%     sensor_alignment = 'rggb'; % Bayer filter specification, used by demosaic
    
    %%
    
    extension = regexprep(file_start, '[^\.]+\.','');
    
    % Strip file extensions
    start_name = regexprep(file_start, ['\.' extension], '');
    stop_name  = regexprep(file_stop,  ['\.' extension], '');
    
    num_start = str2double(regexprep(start_name, '[^0-9]+', ''));
    num_stop  = str2double(regexprep(stop_name, '[^0-9]+', ''));
    prefix    = regexprep(file_start, '[0-9]+.+','');
    
    %%
    
    if isnan(num_stop) % if argument is left empty
        num_stop = num_start + 1000;
    end
    
    for fn_num = num_start : num_stop
        
        fn_raw = [prefix num2str(fn_num) '.' extension];
        
        disp(fn_raw)
        
        if ~exist([path '\' fn_raw]) % if RAW file exists
            disp('  File not found')
            break
        end
        
        fn_pre = regexprep(fn_raw, '\..+', '_preview.jpg');
        
        if ~exist([path '\' fn_pre]) || exist([path '\' fn_pre]) && overwrite % if no preview yet, or preview exists but user wants to overwrite
            [~, ~, I_preview] = extract_RAW_via_dcraw(path, fn_raw, sensor_alignment, 0, 1, 0);
            imwrite(I_preview, [path '\' fn_pre])
            if overwrite
                disp(['  Overwrote ' fn_pre ' to ' path])
            else
                disp(['  Wrote ' fn_pre ' to ' path])
            end
        else
            disp('  Preview already exists, will not overwrite')
        end
        
    end

% end



















































