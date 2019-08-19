classdef (Abstract) Movie < handle
    properties (SetAccess = immutable, GetAccess = private)
        config
        recorder
    end
    
    properties (Dependent)
        FrameRate
    end
    
    methods
        function obj = Movie(varargin)
            p = inputParser;
            p.addParameter('Save', false);
            p.addParameter('FrameRate', 60);
            p.addParameter('TargetDuration', []);
            p.addParameter('Size', []);
            p.addParameter('Smooth', true);
            p.parse(varargin{:});
            
            obj.config = p.Results;
            switch obj.config.Save
                case true
                    obj.recorder = otp.utils.movie.recorder.MemoryVideoRecorder;
                case false
                    obj.recorder = otp.utils.movie.recorder.NullVideoRecorder;
                otherwise
                    obj.recorder = otp.utils.movie.recorder.FileVideoRecorder(obj.config.Save);
            end
            obj.FrameRate = obj.config.FrameRate;
        end
        
        function frameRate = get.FrameRate(obj)
            frameRate = obj.recorder.getFrameRate();
        end
        
        function set.FrameRate(obj, frameRate)
            obj.recorder.setFrameRate(frameRate);
        end
        
        function record(obj, t, y, varargin)
            totalSteps = length(t);
            if totalSteps ~= size(y, 1)
                error('Expected y to have %d rows but has %d', totalSteps, size(y, 1));
            end
            
            state.t = t;
            state.y = y;
            state.step = 0;
            state.totalSteps = totalSteps;
            state.numVars = size(y, 2);
            state.frame = 0;
            
            if isempty(obj.config.TargetDuration)
                state.totalFrames = totalSteps;
            else
                state.totalFrames = round(obj.config.TargetDuration * obj.FrameRate);
            end
            
            [t0, tEnd] = bounds(t);
            
            fig = figure;
            if ~isempty(obj.config.Size)
                fig.Position = [0, 0, obj.config.Size(1), obj.config.Size(2)];
            end
            
            obj.init(fig, state);
            obj.recorder.start(state.totalFrames);
            for f = 1:state.totalFrames
                startTime = tic;
                
                state.frame = f;
                frameProgress = (f - 1) / (state.totalFrames - 1);
                stepRangeStart = state.step + 1;
                if obj.config.Smooth
                    [~, state.step] = min(abs(t0 + (tEnd - t0) * frameProgress - t));
                else
                    state.step = round((totalSteps - 1) * frameProgress + 1);
                end
                state.stepRange = stepRangeStart:state.step;
                
                state.tCur = t(state.step);
                state.yCur = y(state.step, :);
                
                obj.drawFrame(fig, state);
                drawnow;
                obj.recorder.recordFrame(fig);
                
                pause(1 / obj.FrameRate - toc(startTime));
            end
            
            obj.recorder.stop();
        end
        
        function h = play(obj)
            h = obj.recorder.play();
        end
    end
    
    methods (Access = protected, Abstract)
        init(obj, fig, state);
        drawFrame(obj, fig, state);
    end
end

