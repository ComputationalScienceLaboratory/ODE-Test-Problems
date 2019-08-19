classdef (Abstract) VideoRecorder < handle    
    methods (Abstract)
        frameRate = getFrameRate(obj);
        setFrameRate(obj, newFrameRate);
        start(obj, totalFrames);
        recordFrame(obj, fig);
        stop(obj);
        h = play(obj);
    end
end

