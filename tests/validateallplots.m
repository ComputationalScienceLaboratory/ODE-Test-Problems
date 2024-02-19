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

    problem = evalpreset(presetclass, problemname, presetname, ...
        'DefaultTimeSpan', [0, 1e-3]);

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