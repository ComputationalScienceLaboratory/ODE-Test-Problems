classdef NullRecorder < otp.utils.movie.recorder.Recorder
    methods
        function frameRate = getFrameRate(~)
            frameRate = 0;
        end
        
        function setFrameRate(~, ~)
        end
        
        function start(~, ~)
            % Nothing to do
        end
        
        function recordFrame(~, ~)
            % Nothing to do
        end
        
        function stop(~)
            % Nothing to do
        end
        
        function h = play(~)
            h = 'Movie not saved for playback';
            error(h);
        end
    end
end
