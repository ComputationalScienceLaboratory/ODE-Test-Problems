classdef OTP
    properties (Constant)
        Name = 'ODE Test Problems';
        SrcDir = 'src';
        BuildDir = 'build';
    end
    
    methods (Static)
        function clean()
            % This is required for Matlab to function correctly
            [~] = rmdir(OTP.BuildDir, 's');
        end
        
        function build()
            OTP.clean();

            mkdir(OTP.BuildDir);
            
            if OTP.isOctave()
                copyfile(OTP.SrcDir, fullfile(OTP.BuildDir, 'inst'));
                copyfile('DESCRIPTION', OTP.BuildDir);
                copyfile('LICENSE', fullfile(OTP.BuildDir, 'COPYING'));
                zip(OTP.packagePath(), OTP.BuildDir);
            else
                copyfile(OTP.SrcDir, OTP.BuildDir);
                OTP.preprocessReplace('%MATLAB ONLY: ', '');
                matlab.addons.toolbox.packageToolbox( ...
                    strcat(OTP.Name, '.prj'), OTP.packagePath());
            end
        end
        
        function install()
            OTP.build();
            
            if OTP.isOctave()
                pkg('install', OTP.packagePath());
            else
                matlab.addons.toolbox.installToolbox(OTP.packagePath());
            end
            
            if OTP.isOctave()
                otp = ver(lower(OTP.Name));
                printf('OTP version %s installed\n', otp.Version);
            else
                fprintf('OTP installed\n');
                fprintf('If you use OTP in your research, please cite as\n')
                fprintf(['@article{roberts2019ode,\n' ...
                    '  title={ODE Test Problems: a MATLAB suite of initial value problems},\n' ...
                    '  author={Roberts, Steven and Popov, Andrey A and Sandu, Adrian},\n' ...
                    '  journal={arXiv preprint arXiv:1901.04098},\n' ...
                    '  year={2019}\n' ...
                    '}'])
            end

            OTP.clean();
        end
        
        function uninstall()
            if OTP.isOctave()
                pkg('uninstall', lower(OTP.Name));
            else
                toolboxes = matlab.addons.toolbox.installedToolboxes;
                otp = toolboxes(strcmp({toolboxes.Name}, OTP.Name));
                matlab.addons.toolbox.uninstallToolbox(otp);
            end
        end
    end
    
    methods (Static, Access = private)
        function oct = isOctave()
            oct = exist('OCTAVE_VERSION', 'builtin') > 0;
        end

        function preprocessReplace(str, replacement)
            fnames = findmfiles('build');
            for f = fnames
                fname = f{1};

                fileid = fopen(fname, 'r');
                contents = fscanf(fileid, '%c');
                fclose(fileid);
                contents = strrep(contents, str, replacement);
                fileid = fopen(fname, 'w');
                fprintf(fileid, '%c', contents);
                fclose(fileid);
            end
        end

        function path = packagePath()
            if OTP.isOctave()
                ext = '.zip';
            else
                ext = '.mltbx';
            end
            
            path = fullfile(OTP.BuildDir, strcat(OTP.Name, ext));
        end
    end
    
    methods (Access = private)
        function obj = OTP()
        end
    end
end


function fnames = findmfiles(dirname)
% This function finds all the m files in a given directory

fnamesm = dir(fullfile(dirname, '*.m'));

cn = numel(fnamesm);

fnames = cell(1, cn);

for fi = 1:cn
    f = fnamesm(fi);

    fnames{fi} = fullfile(f.folder, f.name);
end

fnamesd = dir(dirname);

for di = 1:numel(fnamesd)
    d = fnamesd(di);
    
    if d.isdir && ~strcmp(d.name, '.') && ~strcmp(d.name, '..')
        newdir = fullfile(dirname, d.name);
        newfnames = findmfiles(newdir);
        fnames = [fnames, newfnames];
    end
end

end
