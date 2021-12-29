list = dir("+otp");

for li = 1:numel(list)
    modeldir = list(li);
    if modeldir.isdir
        if ~any(strcmp(modeldir.name, {'.', '..'}))

            modelname = modeldir.name(2:end);
            
            presetdir = fullfile("+otp", modeldir.name, "+presets");
            presets = dir(presetdir);

            for pi = 1:numel(presets)
                preset = presets(pi);
                if ~preset.isdir
                    presetname = preset.name(1:(end-2));
                    presetclass = strcat("otp.", modelname, ".presets.", presetname);



                    try
                        model = eval(presetclass);
                    catch
                        warning('The preset %s of the model %s has failed to build', presetname, modelname);
                        continue;
                    end

                    fprintf('The preset %s of the model %s has been built successfully\n', presetname, modelname);

                    try
                        model.solve();
                    catch
                        warning('The preset %s of the model %s has failed to solve', presetname, modelname)
                    end
                    fprintf('The preset %s of the model %s has been solved successfully\n', presetname, modelname);
                end
            end
        end
    end
end
