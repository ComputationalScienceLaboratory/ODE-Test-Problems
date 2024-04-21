classdef MemoryRecorder < otp.utils.movie.recorder.Recorder
    properties (Access = private)
        Mov
        CurFrame = 0
        FrameRate = otp.utils.movie.Movie.DefaultFramerate;
    end
    
    methods
        function frameRate = getFrameRate(obj)
            frameRate = obj.FrameRate;
        end
        
        function setFrameRate(obj, newFrameRate)
            obj.FrameRate = newFrameRate;
        end
        
        function start(obj, totalFrames)
            tmp(totalFrames) = struct('cdata', [], 'colormap', []);
            obj.Mov = tmp;
            obj.CurFrame = 0;
        end
        
        function recordFrame(obj, fig)
            obj.CurFrame = obj.CurFrame + 1;
            obj.Mov(obj.CurFrame) = getframe(fig);
        end
        
        function stop(~)
            % Nothing to do
        end
        
        function play(obj)
            if exist('implay', 'builtin')
                implay(obj.Mov, obj.FrameRate);
            else
                movie(obj.Mov, 1, obj.FrameRate);
            end
        end
    end
end
