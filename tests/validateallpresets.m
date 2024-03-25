function validateallpresets

fprintf('\n   Validating all presets and RHS \n\n');
fprintf([' Model                   | Preset               | Build | Solve \n']);
fprintf([repmat('-', 1, 64) '\n']);

presets = getpresets();

for preset = presets
        
    problemname = preset.problem;
    presetname = preset.name;
    presetclass = preset.presetclass;

    fprintf(' %-23s | %-20s | ', ...
        problemname, ...
        presetname);

    problem = evalpreset(presetclass, problemname, presetname);
    fprintf('PASS  | ');

    problem.solve();
    fprintf('PASS  ');


    fprintf('\n');

end

end
