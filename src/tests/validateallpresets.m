function validateallpresets

pi = PresetIterator;

fprintf('\n   Validating all presets and RHS \n\n');

fprintf([' Model                | Preset               |' ...
    ' Build | Solve \n']);
fprintf([repmat('-', 1, 61) '\n']);

for preset = pi.PresetList
        
    modelname = preset.modelName;
    presetname = preset.presetName;
    presetclass = preset.presetClass;

    fprintf(' %-20s | %-20s | ', ...
        modelname, ...
        presetname);

    try
        model = eval(presetclass);
        fprintf('PASS  | ');
        assert(true);
    catch e
        fprintf('-FAIL | ');
        assert(false, sprintf('Preset %s of %s failed to build with error\n%s\n%s', ...
            presetname, modelname, e.identifier, e.message));
        continue;
    end

    try
        if strcmp(modelname, 'quasigeostrophic')
            model.TimeSpan = [0, 0.0109];
        end
        if strcmp(presetname, 'Lorenz96PodRom')
            model.TimeSpan = [0, 10];
        end
        if strcmp(modelname, 'lorenz96')
            model.TimeSpan = [0, 0.05];
        end
        if strcmp(modelname, 'cusp')
            model.TimeSpan = [0, 0.01];
        end
        if strcmp(modelname, 'nbody')
            model.TimeSpan = [0, 0.01];
        end
        model.solve();
        fprintf('PASS  ');
        assert(true)
    catch e
        assert(false, sprintf('Preset %s of %s failed to solve with error\n%s\n%s', ...
            presetname, modelname, e.identifier, e.message))
        fprintf('-FAIL ');
    end

    fprintf('\n');

end

end
