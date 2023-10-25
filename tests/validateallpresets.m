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

    try
        problem = eval(presetclass);
        fprintf('PASS  | ');
        assert(true);
    catch e
        fprintf('-FAIL | ');
        assert(false, sprintf('Preset %s of %s failed to build with error\n%s\n%s', ...
            presetname, problemname, e.identifier, e.message));
        continue;
    end

    try

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
        assert(true)
    catch e
        assert(false, sprintf('Preset %s of %s failed to solve with error\n%s\n%s', ...
            presetname, problemname, e.identifier, e.message))
        fprintf('-FAIL ');
    end

    fprintf('\n');

end

end
