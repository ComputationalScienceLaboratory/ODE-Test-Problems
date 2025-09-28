function problem = evalpreset(presetclass, problemname, presetname, varargin)

p = inputParser;
addParameter(p, 'DefaultTimeSpan', []);
parse(p, varargin{:});

s = p.Results;

problem = eval(presetclass);

if ~isempty(s.DefaultTimeSpan)
    problem.TimeSpan = s.DefaultTimeSpan;
end

if strcmp(problemname, 'quasigeostrophic')
    problem.TimeSpan = [0, 0.0109];
end
if strcmp(presetname, 'Lorenz96PODROM')
    problem.TimeSpan = [0, 10];
end
if strcmp(problemname, 'lorenz96')
    problem.TimeSpan = [0, 0.05];
end
if strcmp(problemname, 'cusp')
    problem.TimeSpan = [0, 0.01];
end
if strcmp(problemname, 'bouncingball')
    problem.TimeSpan = [0, 1];
end
if strcmp(problemname, 'lorenz63')
    problem.TimeSpan = [0, 0.12];
end
if strcmp(problemname, 'nbody')
    problem.TimeSpan = [0, 0.01];
end

end
