close all

problemName  = 'bouncingball';
presetName   = 'RandomTerrain';
outputFormat = 'gif';
targetTime   =  40;
size = [400,400];


set(0,'DefaultAxesXMinorTick','on','DefaultAxesYMinorTick','on')
set(0,'DefaultAxesLineWidth', 2,'DefaultAxesFontName','Times',...
    'DefaultAxesFontSize',20,'DefaultAxesBox','on')
% set(0,'DefaultLineLineWidth',4,'DefaultLineMarkerSize',8)

ffmpegPath   = {'/opt/homebrew/bin/ffmpeg'};


mkdir('animations')
filename = strcat('animations/', problemName,'-', presetName);


string   = strcat(['otp.', problemName,'.presets.', presetName] );
problem  = eval(string);
problem.TimeSpan = [0,30];

% 

sol      = problem.solve('RelTol', 1e-8);
mov      = problem.movie(sol, 'Save', filename, ...
                         'TargetDuration',targetTime, ...
                         'Size', size, ...
                         'FrameRate', 15, ...
                         'view', [0,90]);


% convert vido format if neccessary 
switch outputFormat
    case 'avi'
        
    case 'gif'

        args     = strcat(['-i ' ...
        filename,'.avi ' ...
        ' -vf "fps=10,scale=400:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 1 '...
        filename,'.gif']);


    case 'webm'

        args     = strcat(['-i ' ...
        filename,'.avi ' ...
        '-c:v libvpx -crf 10 -b:v 1M -c:a libvorbis '...
        filename,'.webm']);

end

command = strjoin(strcat([ffmpegPath,' ' , args]));
system(command);        



    






