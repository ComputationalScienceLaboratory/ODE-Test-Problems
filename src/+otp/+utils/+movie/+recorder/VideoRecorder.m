classdef (Abstract) VideoRecorder < handle    
    methods
        function frameRate = getFrameRate(obj)
            error('Abstract method getFrameRate must be implemented by a subclass');
        end
        
        function setFrameRate(obj, newFrameRate)
            error('Abstract method setFrameRate must be implemented by a subclass');
        end
        
        function start(obj, totalFrames)
            error('Abstract method start must be implemented by a subclass');
        end
        
        function recordFrame(obj, fig)
            error('Abstract method recordFrame must be implemented by a subclass');
        end
        
        function stop(obj)
            error('Abstract method stop must be implemented by a subclass');
        end
        
        function h = play(obj)
            error('Abstract method play must be implemented by a subclass');
        end
    end
end

