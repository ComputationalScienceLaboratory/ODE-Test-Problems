otpdir = fullfile("src", "+otp");

list = dir(otpdir);

docfilenames = {};

for li = 1:numel(list)
    modeldir = list(li);
    
    if ~modeldir.isdir || modeldir.name(1) ~= '+' || strcmp(modeldir.name, "+utils")
        continue
    end
    problemname = list(li).name;

    problemfolder = fullfile(otpdir, problemname);

    %% find the problem and parameter classes
    listinner = dir(problemfolder);
    for fi = 1:numel(listinner)
        cfile = listinner(fi);
        if ~isempty(regexp(cfile.name, '.*Problem', 'once'))
            problemclassfname = cfile.name(1:(end-2));

            problemtitle = problemclassfname(1:(end-7));

            si = regexp(problemtitle, '([A-Z]+[a-z]*|[0-9][0-9])');
            si = [si, (numel(problemtitle)+1)];
            realproblemtitle = '';
            for i = 1:(numel(si) - 1)
                realproblemtitle = [realproblemtitle, problemclassfname(si(i):(si(i+1) - 1)), ' '];
            end
            realproblemtitle;
        end

        if ~isempty(regexp(cfile.name, '^[A-Z].*Parameters', 'once'))
            parameterclassfname = cfile.name(1:(end-2));
        end
    end

    % get all the presets
    presetdir = fullfile(problemfolder, "+presets");
    presetlist = dir(presetdir);

    presets = {};
    for pi = 1:numel(presetlist)
        preset = presetlist(pi);
        if ~preset.isdir
            presets{end + 1} = preset.name(1:(end-2));
        end
    end

    docfilename = fullfile("docsrc", "problems", [problemname(2:end), '.rst']);
    fh = fopen(docfilename, "w");

    fprintf(fh, "%s\n%s\n\n", realproblemtitle,repmat('=', 1, numel(realproblemtitle)));

    fprintf(fh, ".. automodule:: +otp.%s\n", problemname);
    fprintf(fh, ".. autoclass:: %s\n", problemclassfname);
    fprintf(fh, "    :show-inheritance:\n    :members:\n\n");

    fprintf(fh, "Parameters\n----------\n");

    fprintf(fh, ".. autoclass:: %s\n", parameterclassfname);
    fprintf(fh, "    :members:\n\n");


    fprintf(fh, "Presets\n-------\n");

    fprintf(fh, ".. automodule:: +otp.%s.+presets\n", problemname);
    for pi = 1:numel(presets)
        fprintf(fh, ".. autoclass:: %s\n", presets{pi});
        fprintf(fh, "    :show-inheritance:\n    :members:\n\n");
    end

    fclose(fh);

    docfilenames{end+1} = docfilename;

end


