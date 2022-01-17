entry = dir(which('otp.RHS'));
otpdir = entry.folder;

list = dir(otpdir);

for li = 1:numel(list)
    modeldir = list(li);
    
    if ~modeldir.isdir || modeldir.name(1) ~= '+'
        continue
    end

    modelname = modeldir.name(2:end);
    
    presetdir = fullfile(otpdir, modeldir.name, "+presets");
    presets = dir(presetdir);

    for pi = 1:numel(presets)
        preset = presets(pi);
        
        if preset.isdir
            continue;
        end
        
        presetname = preset.name(1:(end-2));
        presetclass = strcat("otp.", modelname, ".presets.", presetname);
        
        try
            model = eval(presetclass);
            fprintf('The preset %s of the model %s has been built successfully\n', presetname, modelname);
        catch
            fprintf('---- The preset %s of the model %s has failed to build\n', presetname, modelname);
            continue;
        end

        try
            if strcmp(modelname, 'qg')
                model.TimeSpan = [0, 0.01];
            end
            if strcmp(presetname, 'Lorenz96PodRom')
                model.TimeSpan = [0, 10];
            end
            model.solve();
            fprintf('The preset %s of the model %s has been solved successfully\n', presetname, modelname);
        catch
            fprintf('---- The preset %s of the model %s has failed to solve\n', presetname, modelname)
        end
    end
end
