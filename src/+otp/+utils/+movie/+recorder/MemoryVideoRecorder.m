classdef MemoryVideoRecorder < otp.utils.movie.recorder.VideoRecorder
    properties (Access = private)
        mov
        curFrame = 0
        frameRate = 60;
    end
    
    methods
        function frameRate = getFrameRate(obj)
            frameRate = obj.frameRate;
        end
        
        function setFrameRate(obj, newFrameRate)
            obj.frameRate = newFrameRate;
        end
        
        function start(obj, totalFrames)
            tmp(totalFrames) = struct('cdata', [], 'colormap', []);
            obj.mov = tmp;
            obj.curFrame = 0;
        end
        
        function recordFrame(obj, fig)
            obj.curFrame = obj.curFrame + 1;
            obj.mov(obj.curFrame) = getframe(fig);
        end
        
        function stop(~)
            % Nothing to do
        end
        
        function h = play(obj)
            h = implay(obj.mov, obj.frameRate);
        end
    end
end
