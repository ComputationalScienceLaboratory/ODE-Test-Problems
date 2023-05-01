function [passed, failed] = validateallpresets

pi = otptests.PresetIterator;

passed = 0;
failed = 0;

for preset = pi.PresetList
        
    modelname = preset.modelName;
    presetname = preset.presetName;
    presetclass = preset.presetClass;

    try
        model = eval(presetclass);
        fprintf('The preset %s of the model %s has been built successfully\n', presetname, modelname);
        passed = passed + 1;
    catch
        fprintf('---- The preset %s of the model %s has failed to build\n', presetname, modelname);
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
        fprintf('The preset %s of the model %s has been solved successfully\n', presetname, modelname);
        passed = passed + 1;
    catch
        fprintf('---- The preset %s of the model %s has failed to solve\n', presetname, modelname)
        failed = failed + 1;
    end
end

end
