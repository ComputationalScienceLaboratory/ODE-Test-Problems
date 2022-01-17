classdef (Abstract) Movie < handle
    properties (Constant)
        DefaultFramerate = 60
    end
    
    properties (Access = private)
        Config
        Recorder
    end
    
    properties (Dependent)
        FrameRate
    end
    
    methods
        function obj = Movie(varargin)
            p = inputParser;
            p.addParameter('Save', false);
            p.addParameter('FrameRate', otp.utils.movie.Movie.DefaultFramerate);
            p.addParameter('TargetDuration', [], @(d) d > 0);
            p.addParameter('Size', [], @(s) length(s) == 2 && all(s > 0));
            p.addParameter('Smooth', true, @islogical);
            p.parse(varargin{:});
            
            obj.Config = p.Results;
            switch obj.Config.Save
                case true
                    obj.Recorder = otp.utils.movie.recorder.MemoryVideoRecorder;
                case false
                    obj.Recorder = otp.utils.movie.recorder.NullVideoRecorder;
                otherwise
                    obj.Recorder = otp.utils.movie.recorder.FileVideoRecorder(obj.Config.Save);
            end
            obj.FrameRate = obj.Config.FrameRate;
        end
        
        function frameRate = get.FrameRate(obj)
            frameRate = obj.Recorder.getFrameRate();
        end
        
        function set.FrameRate(obj, frameRate)
            obj.Recorder.setFrameRate(frameRate);
        end
        
        function record(obj, t, y)
            totalSteps = length(t);
            [state.numVars, state.totalSteps] = size(y);
            if length(t) ~= state.totalSteps
                error('Expected y to have %d columns but has %d', length(t), state.totalSteps);
            end
            
            state.t = t;
            state.y = y;
            state.step = 0;
            state.frame = 0;
            
            if isempty(obj.Config.TargetDuration)
                state.totalFrames = totalSteps;
            else
                state.totalFrames = round(obj.Config.TargetDuration * obj.FrameRate);
            end
            
            [t0, tEnd] = bounds(t);
            
            fig = figure;
            if ~isempty(obj.Config.Size)
                fig.Position = [0; 0: obj.Config.Size(:)];
            end
            
            obj.init(fig, state);
            obj.Recorder.start(state.totalFrames);
            for f = 1:state.totalFrames
                startTime = tic;
                
                state.frame = f;
                frameProgress = (f - 1) / (state.totalFrames - 1);
                stepRangeStart = state.step + 1;
                if obj.Config.Smooth
                    [~, state.step] = min(abs(t0 + (tEnd - t0) * frameProgress - t));
                else
                    state.step = round((totalSteps - 1) * frameProgress + 1);
                end
                state.stepRange = stepRangeStart:state.step;
                
                state.tCur = t(state.step);
                state.yCur = y(:, state.step);
                
                obj.drawFrame(fig, state);
                drawnow;
                obj.Recorder.recordFrame(fig);
                
                pause(1 / obj.FrameRate - toc(startTime));
            end
            
            obj.Recorder.stop();
        end
        
        function h = play(obj)
            h = obj.Recorder.play();
        end
    end
    
    methods (Access = protected)
        function init(obj, fig, state)
            otp.utils.compatibility.abstract(obj, fig, state);
        end
        
        function drawFrame(obj, fig, state)
            otp.utils.compatibility.abstract(obj, fig, state);
        end
    end
end

