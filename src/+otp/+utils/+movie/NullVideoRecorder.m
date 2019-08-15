classdef NullVideoRecorder < otp.utils.movie.IVideoRecorder    
    methods (Access = protected)
        function frameRate = internalGetFrameRate(~)
            frameRate = 0;
        end
        
        function internalSetFrameRate(~, ~)
        end
        
        function frameCount = internalGetFrameCount(~)
            frameCount = 0;
        end
        
        function duration = internalGetDuration(obj)
            duration = 0;
        end
    end
    
    methods (Hidden)
        function start(~, ~)
            % Nothing to do
        end
        
        function recordFrame(~, ~)
            % Nothing to do
        end
        
        function stop(~)
            % Nothing to do
        end
    end
    
    methods
        function h = play(~)
            h = error('Video not saved');
        end
    end
end
