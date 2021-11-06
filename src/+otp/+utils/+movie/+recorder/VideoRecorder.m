classdef (Abstract) VideoRecorder < handle    
    methods
        function frameRate = getFrameRate(obj)
            frameRate = otp.utils.compatibility.abstract(obj);
        end
        
        function setFrameRate(obj, newFrameRate)
            otp.utils.compatibility.abstract(obj, newFrameRate);
        end
        
        function start(obj, totalFrames)
            otp.utils.compatibility.abstract(obj, totalFrames);
        end
        
        function recordFrame(obj, fig)
            otp.utils.compatibility.abstract(obj, fig);
        end
        
        function stop(obj)
            otp.utils.compatibility.abstract(obj);
        end
        
        function h = play(obj)
            h = otp.utils.compatibility.abstract(obj);
        end
    end
end

