function validateallpresets

fprintf('\n   Validating all presets and RHS \n\n');
fprintf([' Model                | Preset               |' ...
    ' Build | Solve \n']);
fprintf([repmat('-', 1, 61) '\n']);

presets = getpresets();

for preset = presets
        
    problemname = preset.problem;
    presetname = preset.name;
    presetclass = preset.presetclass;

    fprintf(' %-20s | %-20s | ', ...
        problemname, ...
        presetname);

    problem = eval(presetclass);
    fprintf('PASS  | ');

    if strcmp(problemname, 'quasigeostrophic')
        problem.TimeSpan = [0, 0.0109];
    end
    if strcmp(presetname, 'Lorenz96PODROM')
        problem.TimeSpan = [0, 0.1];
    end
    if strcmp(problemname, 'lorenz96')
        problem.TimeSpan = [0, 0.05];
    end
    if strcmp(problemname, 'cusp')
        problem.TimeSpan = [0, 0.01];
    end
    if strcmp(problemname, 'nbody')
        problem.TimeSpan = [0, 0.01];
    end
    problem.solve();
    fprintf('PASS  ');


    fprintf('\n');

end

end
