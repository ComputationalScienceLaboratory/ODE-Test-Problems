classdef PresetIterator < handle

    properties
        Index = 0;
        PresetList
    end

    methods
        function obj = PresetIterator
            entry = dir("+otp/");

            if isempty(entry)
                entry = dir(which('otp.RHS'));
            end

            
            otpdir = entry.folder;

            listTmp = dir(otpdir);

            obj.PresetList = [];

            for li = 1:numel(listTmp)
                modeldir = listTmp(li);

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

                    presetst = struct;
                    presetst.modelName = modelname;
                    presetst.presetName = presetname;
                    presetst.presetClass = presetclass;

                    obj.PresetList = [obj.PresetList, presetst];
                end
            end
        end


        function preset = next(obj)
            obj.Index = obj.Index + 1;
            if obj.Index > numel(obj.PresetList)
                preset = [];
            else
                preset = obj.PresetList(obj.Index);
            end
        end

    end

end