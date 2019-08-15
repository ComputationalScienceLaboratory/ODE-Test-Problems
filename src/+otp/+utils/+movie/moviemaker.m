function varargout = moviemaker(t, y, init, frame, varargin)

totalSteps = length(t);
if totalSteps ~= size(y, 1)
    error('Expected y to have %d rows but has %d', totalSteps, size(y, 1));
end

p = inputParser;
p.addParameter('Size', [], @(x) length(x) == 2);
p.addParameter('Frames', totalSteps);
p.addParameter('FrameRate', 60, @(x) x > 0);
p.addParameter('Smooth', true);
p.addParameter('Write', []);
p.parse(varargin{:});
config = p.Results;

state.t = t;
state.y = y;
state.step = 0;
state.totalSteps = totalSteps;
state.numVars = size(y, 2);

frameData.frame = 0;
frameData.totalFrames = config.Frames;

[t0, tEnd] = bounds(t);

fig = figure;
if ~isempty(config.Size)
    fig.Position = [0, 0, config.Size(1), config.Size(2)];
end

initData = init(fig, state, frameData);

if ~isempty(config.Write)
    recorder = otp.utils.movie.FileVideoRecorder(config.Write);
elseif nargout > 0
    recorder = otp.utils.movie.MemoryVideoRecorder;
else
    recorder = otp.utils.movie.NullVideoRecorder;
end
recorder.FrameRate = config.FrameRate;
recorder.start(config.Frames);

for f = 1:config.Frames
    startTime = tic;
    
    frameData.frame = f;
    frameProgress = (f - 1) / (config.Frames - 1);
    stepRangeStart = state.step + 1;
    if config.Smooth
        [~, state.step] = min(abs(t0 + (tEnd - t0) * frameProgress - t));
    else
        state.step = round((totalSteps - 1) * frameProgress + 1);
    end
    state.stepRange = stepRangeStart:state.step;
    
    state.tCur = t(state.step);
    state.yCur = y(state.step, :);
    
    frame(fig, initData, state, frameData);
    
    recorder.recordFrame(fig);
    
    pause(1 / config.FrameRate - toc(startTime));
end

recorder.stop();
if nargout > 0
    varargout{1} = recorder;
end

end
