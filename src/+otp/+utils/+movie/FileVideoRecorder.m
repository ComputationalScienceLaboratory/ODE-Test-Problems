classdef FileVideoRecorder < otp.utils.movie.IVideoRecorder
    properties (SetAccess = immutable, GetAccess = private)
        videoWriter
    end
    
    methods (Access = protected)
        function frameRate = internalGetFrameRate(obj)
            frameRate = obj.videoWriter.FrameRate;
        end
        
        function internalSetFrameRate(obj, newFrameRate)
            obj.videoWriter.FrameRate = newFrameRate;
        end
        
        function frameCount = internalGetFrameCount(obj)
            frameCount = obj.videoWriter.FrameCount;
        end
        
        function duration = internalGetDuration(obj)
            duration = obj.videoWriter.Duration;
        end
    end
    
    methods (Hidden)
        function start(obj, ~)
            obj.videoWriter.open();
        end
        
        function recordFrame(obj, fig)
            obj.videoWriter.writeVideo(getframe(fig));
        end
        
        function stop(obj)
            obj.videoWriter.close();
        end
    end
    
    methods
        function obj = FileVideoRecorder(v)
            if nargin ~= 1
                error('One argument expected');
            elseif ischar(v)
                obj.videoWriter = VideoWriter(v);
            elseif isa(v, 'VideoWriter')
                obj.videoWriter = v;
            else
                error('Argument must be a string or a VideoWriter but is a %s', class(v));
            end
        end
        
        function h = play(obj)
            h = implay(fullfile(obj.videoWriter.Path, obj.videoWriter.Filename));
        end
    end
end
