classdef (Abstract) IVideoRecorder < handle
    properties (Dependent)
        FrameRate
        FrameCount
        Duration
    end
    
    methods (Abstract, Access = protected)
        frameRate = internalGetFrameRate(obj);
        internalSetFrameRate(obj, newFrameRate);
        frameCount = internalGetFrameCount(obj);
        duration = internalGetDuration(obj);
    end
    
    methods (Abstract, Hidden)
        start(obj, totalFrames);
        recordFrame(obj, fig);
        stop(obj);
    end
    
    methods (Abstract)
        h = play(obj);
    end
    
    methods
        function frameRate = get.FrameRate(obj)
            frameRate = obj.internalGetFrameRate();
        end
        
        function set.FrameRate(obj, newFrameRate)
            obj.internalSetFrameRate(newFrameRate);
        end
        
        function frameCount = get.FrameCount(obj)
            frameCount = obj.internalGetFrameCount();
        end
        
        function duration = get.Duration(obj)
            duration = obj.internalGetDuration();
        end
    end
end

