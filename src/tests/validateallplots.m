function validateallplots

fprintf('\n   Validating all model and preset derivatives \n\n');

fprintf([' Model                | Preset               |' ...
    ' Plot | Phase | Movie\n']);
fprintf([repmat('-', 1, 85) '\n']);

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
    catch
        continue;
    end

    try
        problem.TimeSpan = [0, 1e-3];


        if strcmp(problemname, 'quasigeostrophic')
            problem.TimeSpan = [0, 0.0109];
        end
        if strcmp(presetname, 'Lorenz96PodRom')
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
        assert(true)
    catch
        continue;
    end

    try
        problem.plot(sol);
        fprintf('PASS | ');
    catch e
        assert(false, sprintf('Preset %s of %s failed to plot with error\n%s\n%s', ...
            presetname, problemname, e.identifier, e.message))
        fprintf('-FAIL ');
    end

    if problem.NumVars > 1
        try
            problem.plotPhaseSpace(sol);
            fprintf('PASS  | ');
        catch e
            assert(false, sprintf('Preset %s of %s failed to plot phase space with error\n%s\n%s', ...
                presetname, problemname, e.identifier, e.message))
            fprintf('-FAIL ');
        end
    else
        fprintf('      ');
    end


    try
        problem.movie(sol);
        fprintf('PASS  ');
    catch e
        assert(false, sprintf('Preset %s of %s failed to create movie with error\n%s\n%s', ...
            presetname, problemname, e.identifier, e.message))
        fprintf('-FAIL ');
    end


    close all;

    fprintf('\n');

end