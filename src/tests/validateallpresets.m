function [passed, failed] = validateallpresets

pi = PresetIterator;

passed = 0;
failed = 0;

fprintf('\n   Validating all presets and RHS \n\n');

fprintf([' Model                | Preset               | RHS          |' ...
    ' Build | Solve | Change \n']);
fprintf([repmat('-', 1, 85) '\n']);

padinteral = @otp.utils.compatibility.pad;

for preset = pi.PresetList
        
    modelname = preset.modelName;
    presetname = preset.presetName;
    presetclass = preset.presetClass;

    % do another for loop here for RHS

    rhsname = 'RHS';
    fprintf(' %s | %s | %s | ', ...
        padinteral(modelname, 20), ...
        padinteral(presetname, 20), ...
        padinteral(rhsname, 12));

    try
        model = eval(presetclass);
        fprintf('PASS  | ');
        passed = passed + 1;
    catch
        fprintf('-FAIL | ');
        failed = failed + 2;
        continue;
    end

    try
        if strcmp(modelname, 'quasigeostrophic')
            model.TimeSpan = [0, 0.0109];
        end
        if strcmp(presetname, 'Lorenz96PodRom')
            model.TimeSpan = [0, 10];
        end
        model.solve();
        fprintf('PASS  | ');
        passed = passed + 1;
    catch
        fprintf('-FAIL | ');
        failed = failed + 1;
    end


    try
        model.TimeSpan = [0, 1];
        model.Y0 = 0*model.Y0;
        fprintf('PASS   ');
        passed = passed + 1;
    catch
        fprintf('-FAIL  ');
        failed = failed + 1;
    end

    fprintf('\n');

end

fprintf('\n   Preset validation %d passed and %d failed tests\n', passed, failed);

end
