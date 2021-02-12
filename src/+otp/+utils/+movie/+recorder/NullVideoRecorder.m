classdef NullVideoRecorder < otp.utils.movie.recorder.VideoRecorder
    properties (Access = private)
        FrameRate = otp.utils.movie.Movie.DefaultFramerate;
    end
    
    methods
        function frameRate = getFrameRate(obj)
            frameRate = obj.FrameRate;
        end
        
        function setFrameRate(obj, frameRate)
            obj.FrameRate = frameRate;
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
            h = 'Video not saved for playback';
            error(h);
        end
    end
end
