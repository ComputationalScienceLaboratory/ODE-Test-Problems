function makeMovie()

    %% Set animation settings
    
    set(0,'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on')
    set(0,'DefaultAxesLineWidth', 2,'DefaultAxesFontName','Times',...
        'DefaultAxesFontSize',18,'DefaultAxesBox','on')
    
    ffmpegPath   = {'/opt/homebrew/bin/ffmpeg'};
    
    outputFormat = 'webm';
    targetTime   =  20;
    size         = [300,300];
    mkdir('animations')
    
    %% KPR Animation 

    problemName  = 'bouncingball';
    presetName   = 'RandomTerrain';

    filename = strcat('animations/', problemName,'-', presetName);

    string   = strcat(['otp.', problemName,'.presets.', presetName] );
    problem  = eval(string);
    problem.TimeSpan = [0,30];

    sol      = problem.solve('RelTol', 1e-8);
    mov      = problem.movie(sol, 'Save', filename, ...
                             'TargetDuration',targetTime, ...
                             'Size', size, ...
                             'FrameRate', 15, ...
                             'view', [0,90]);

    args = get_ffmpeg_args(outputFormat, filename);

    command = strjoin(strcat([ffmpegPath,' ' , args]));
    system(command);    


    % Nbody animation


    problemName  = 'nbody';
    presetName   = 'OuterSolarSystem';

    filename = strcat('animations/', problemName,'-', presetName);

    string   = strcat(['otp.', problemName,'.presets.', presetName] );
    problem  = eval(string);

    sol      = problem.solve('RelTol', 1e-4);
    mov      = problem.movie(sol, 'Save', filename, ...
                             'TargetDuration',targetTime, ...
                             'Size', size, ...
                             'FrameRate', 15, ...
                             'view', [60,30]);

    args = get_ffmpeg_args(outputFormat, filename);

    command = strjoin(strcat([ffmpegPath,' ' , args]));
    system(command);  


    %% Pendulum animation


    problemName  = 'pendulum';
    presetName   = 'Canonical';



    filename = strcat('animations/', problemName,'-', presetName);
    problem  = otp.pendulum.presets.Canonical(4);
    problem.Y0(1:4) = pi/3;
    problem.Parameters.Masses = [1,1,3,3]';


    sol      = problem.solve('RelTol', 1e-9);
    mov      = problem.movie(sol, 'Save', filename, ...
                             'TargetDuration',targetTime, ...
                             'Size', size, ...
                             'FrameRate', 15, ...
                             'view', [0,90]);

    args = get_ffmpeg_args(outputFormat, filename);

    command = strjoin(strcat([ffmpegPath,' ' , args]));
    system(command); 

    %% Lorenz63 animation


    problemName  = 'lorenz63';
    presetName   = 'Canonical';


    
    filename = strcat('animations/', problemName,'-', presetName);
    string   = strcat(['otp.', problemName,'.presets.', presetName] );
    problem  = eval(string);


    sol              = problem.solve('RelTol', 1e-9);
    problem.Y0       = sol.y(:,500);
    problem.TimeSpan = [0,30];
    sol              = problem.solve('RelTol', 1e-9);
    mov              = problem.movie(sol, 'Save', filename, ...
                             'TargetDuration',targetTime, ...
                             'Size', size, ...
                             'FrameRate', 15, ...
                             'view', [60,30]);
    
    
    args = get_ffmpeg_args(outputFormat, filename);
    
    command = strjoin(strcat([ffmpegPath,' ' , args]));
    system(command);
end


function [args] = get_ffmpeg_args(outputFormat, filename) 
    
    % convert vido format if neccessary 
    switch outputFormat
        case 'avi'
            
        case 'gif'
    
            args     = strcat(['-i ' ...
            filename,'.avi ' ...
            ' -vf "fps=15,scale=500:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0' ...
            ' '...
            filename,'.gif']);
    
        case 'webm'
    
            args     = strcat(['-i ' ...
            filename,'.avi ' ...
            '-c:v libvpx -quality best -crf 5 -b:v 1M -c:a libvorbis '...
            filename,'.webm']);
    
    end
end




    






