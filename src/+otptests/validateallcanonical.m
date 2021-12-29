list = dir("+otp\");

for li = 1:numel(list)
    elem = list(li);
    if elem.isdir
        if ~any(strcmp(elem.name, {'.', '..'}))
            
            canonical = strcat("otp.", elem.name(2:end), ".presets.Canonical");
            
            try
                model = eval(canonical);
            catch
                warning('The model %s has failed to build', elem.name(2:end));
                continue;
            end

            fprintf('The model %s has been built successfully\n', elem.name(2:end));

            try
                model.solve();
            catch
                warning('The model %s has failed to solve', elem.name(2:end))
            end
            fprintf('The model %s has been solved successfully\n', elem.name(2:end));

        end
    end
end