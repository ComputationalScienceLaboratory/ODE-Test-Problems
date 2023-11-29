function validateallplots(testplots, testmovies)

if nargin < 1 || isempty(testplots)
    testplots = true;
end

if nargin < 2 || isempty(testmovies)
    testmovies = true;
end

fprintf('\n   Validating all model and preset plots and movies \n\n');

fprintf([' Model                | Preset               |' ...
    ' Plot  | Phase | Movie\n']);
fprintf([repmat('-', 1, 85) '\n']);

presets = getpresets();

for preset = presets

    problemname = preset.problem;
    presetname = preset.name;
    presetclass = preset.presetclass;

    fprintf(' %-20s | %-20s | ', ...
        problemname, ...
        presetname);

    problem = eval(presetclass);

    problem.TimeSpan = [0, 1e-3];


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
    sol = problem.solve();

    if testplots
        fig = problem.plot(sol);
        close(fig);
        fprintf('PASS  | ');

        if problem.NumVars > 1
            problem.plotPhaseSpace(sol);
            fprintf('PASS  | ');
        else
            fprintf('      | ');
        end
    else
        fprintf('      | ');
        fprintf('      | ');
    end

    if testmovies
        problem.movie(sol);
        fprintf('PASS  ');
    end


    close all;

    fprintf('\n');

end