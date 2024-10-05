classdef NullRecorder < otp.utils.movie.recorder.Recorder
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
        
        function play(~)
            error('OTP:movieNotSaved', 'Movie not saved for playback');
        end
    end
end
