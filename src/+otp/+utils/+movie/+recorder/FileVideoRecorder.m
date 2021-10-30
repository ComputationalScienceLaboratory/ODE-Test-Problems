classdef FileVideoRecorder < otp.utils.movie.recorder.VideoRecorder
    properties (Access = private)
        VideoWriter
    end
    
    methods
        function obj = FileVideoRecorder(v)
            if ischar(v)
                obj.VideoWriter = VideoWriter(v);
            elseif isa(v, 'VideoWriter')
                obj.VideoWriter = v;
            else
                error('Argument must be a string or a VideoWriter but is a %s', class(v));
            end
        end
        
        function frameRate = getFrameRate(obj)
            frameRate = obj.VideoWriter.FrameRate;
        end
        
        function setFrameRate(obj, newFrameRate)
            obj.VideoWriter.FrameRate = newFrameRate;
        end
        
        function frameCount = getFrameCount(obj)
            frameCount = obj.VideoWriter.FrameCount;
        end
        
        function duration = getDuration(obj)
            duration = obj.VideoWriter.Duration;
        end
        
        function start(obj, ~)
            obj.VideoWriter.open();
        end
        
        function recordFrame(obj, fig)
            obj.VideoWriter.writeVideo(getframe(fig));
        end
        
        function stop(obj)
            obj.VideoWriter.close();
        end
        
        function h = play(obj)
            h = implay(fullfile(obj.VideoWriter.Path, obj.VideoWriter.Filename), obj.VideoWriter.FrameRate);
        end
    end
end
