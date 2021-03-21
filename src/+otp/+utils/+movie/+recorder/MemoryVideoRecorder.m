classdef MemoryVideoRecorder < otp.utils.movie.recorder.VideoRecorder
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
        
        function h = play(obj)
            h = implay(obj.Mov, obj.FrameRate);
        end
    end
end
