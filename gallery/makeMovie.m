close all

presets = getpresets();

if ~ isfolder('animations')
    mkdir('animations')
end


listAllExperiments = {};

for preset = presets
    listAllExperiments{end+1} = preset.presetclass;
end

% select test problem and preset
[indx,tf] = listdlg('PromptString', ...
    {'Select a test problem',...
    'Only one problem can be selected at a time.',''},...
    'ListSize',[250,500], ...
    'InitialValue', 22, ...
    'OKString','Select', ... 
    'SelectionMode','single','ListString',listAllExperiments);

if tf
    eval(strcat(['problem =', listAllExperiments{indx}]));

    vid_format = questdlg('Select Output format', ...
	'Supported Formats:','Avi','Gif','Webm', 'Avi');

    experiment        = strsplit(listAllExperiments{indx},'.');
    filename = strcat('animations/', experiment{2},'-', experiment{4});
        

    if ~isempty(vid_format)
        sol      = problem.solve('RelTol', 1e-8);
        mov      = problem.movie(sol, 'Save', filename);
    end
    

    % convert vido format if neccessary 
    switch vid_format
        case 'Avi'
            
        case 'Gif'
    
            args     = strcat(['-i ' ...
            filename,'.avi ' ...
            filename,'.gif']);

        case 'Webm'
    
            args     = strcat(['-i ' ...
            filename,'.avi ' ...
            '-c:v libvpx -crf 10 -b:v 1M -c:a libvorbis '...
            filename,'.webm']);

    end

    if ~strcmp(vid_format,'Avi') && ~isempty(vid_format)

        prompt = {'Ffmpeg is required for video conversion'};
        dlgtitle = 'Enter path to ffmpeg:';
        dims = [1 35];
        definput = {'/opt/homebrew/bin/ffmpeg'};
        ffmpeg = inputdlg(prompt,dlgtitle,dims,definput);

        if ~isempty(ffmpeg)

            command = strjoin(strcat([ffmpeg,' ' , args]));
            system(command);
            delete(strcat(filename,'.avi'));
        end

    end

    

end





