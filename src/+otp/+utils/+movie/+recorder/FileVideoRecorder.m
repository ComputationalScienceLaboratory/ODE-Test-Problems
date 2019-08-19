classdef FileVideoRecorder < otp.utils.movie.recorder.VideoRecorder
    properties (SetAccess = immutable, GetAccess = private)
        videoWriter
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
        
        function frameRate = getFrameRate(obj)
            frameRate = obj.videoWriter.FrameRate;
        end
        
        function setFrameRate(obj, newFrameRate)
            obj.videoWriter.FrameRate = newFrameRate;
        end
        
        function frameCount = getFrameCount(obj)
            frameCount = obj.videoWriter.FrameCount;
        end
        
        function duration = getDuration(obj)
            duration = obj.videoWriter.Duration;
        end
        
        function start(obj, ~)
            obj.videoWriter.open();
        end
        
        function recordFrame(obj, fig)
            obj.videoWriter.writeVideo(getframe(fig));
        end
        
        function stop(obj)
            obj.videoWriter.close();
        end
        
        function h = play(obj)
            h = implay(fullfile(obj.videoWriter.Path, obj.videoWriter.Filename), obj.videoWriter.FrameRate);
        end
    end
end
