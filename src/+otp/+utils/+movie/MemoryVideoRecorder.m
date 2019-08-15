classdef MemoryVideoRecorder < otp.utils.movie.IVideoRecorder
    properties (Access = private)
        mov
        curFrame = 0
        frameRate = 60;
    end
    
    methods (Access = protected)
        function frameRate = internalGetFrameRate(obj)
            frameRate = obj.frameRate;
        end
        
        function internalSetFrameRate(obj, newFrameRate)
            obj.frameRate = newFrameRate;
        end
        
        function frameCount = internalGetFrameCount(obj)
            frameCount = obj.curFrame;
        end
        
        function duration = internalGetDuration(obj)
            duration = obj.FrameCount / obj.FrameRate;
        end
    end
    
    methods (Hidden)
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
    end
    
    methods
        function h = play(obj)
            h = implay(obj.mov, obj.frameRate);
        end
    end
end
