function presets = getpresets()

entry = "toolbox/+otp/";

if isempty(dir(entry))
    entry = dir(which('otp.RHS'));
    entry = entry.folder;
end

entry = fullfile(entry, '*', '+presets', '*.m');

allpresets = dir(entry);

presets = struct;

for i = 1:numel(allpresets)

[presets(i).presetclass, presets(i).name, presets(i).problem] = ...
    constructPreset(allpresets(i)); 

end

end

function [presetclass, presetname, problemname] = constructPreset(file)

[~, presetname, ~] = fileparts(file.name);
folders = strsplit(file.folder, filesep);
problemname = folders{end-1};
problemname = problemname(2:end);
presetclass = sprintf('otp.%s.presets.%s', problemname, presetname);

if strcmp(problemname, 'quasigeostrophic')
    presetclass = sprintf('%s%s', presetclass, "('Nx', 16, 'Ny', 32)");
end

if strcmp(problemname, 'allencahn')
    presetclass = sprintf('%s%s', presetclass, "('Size', 16)");
end

end