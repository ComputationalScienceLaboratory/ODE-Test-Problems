classdef OTP
    properties (Access = private, Constant)
        Octave = exist('OCTAVE_VERSION', 'builtin') > 0
        Name = 'ODE Test Problems'
        SrcDir = 'toolbox'
        BuildDir = 'build'
        ProjectFile = 'toolboxPackaging.prj'
        DescriptionFile = 'DESCRIPTION'
    end
    
    methods (Static)
        function clean()
            [~] = rmdir(OTP.BuildDir, 's');
        end

        function updateVersion(newVersion)
            OTP.replaceInFile('(<param.version>).+(</param.version>)', ['$1', newVersion, '$2'], OTP.ProjectFile);
            OTP.replaceInFile( ...
                {'(Version: ).+', '(Date: ).+'}, ...
                {['$1', newVersion], ['$1', date()]}, ...
                OTP.DescriptionFile);
        end
        
        function build()
            OTP.clean();
            
            if OTP.Octave
                OTP.processFiles({}, {}, OTP.SrcDir, fullfile(OTP.BuildDir, 'inst'));
                copyfile(OTP.DescriptionFile, OTP.BuildDir);
                copyfile('license.txt', fullfile(OTP.BuildDir, 'COPYING'));
                zip(OTP.packagePath(), OTP.BuildDir);
            else
                OTP.processFiles('\s*%\s*MATLAB ONLY:\s*', ' ', OTP.SrcDir, OTP.BuildDir);
                matlab.addons.toolbox.packageToolbox('toolboxPackaging.prj', OTP.packagePath());
            end
        end
        
        function install()
            OTP.build();
            
            if OTP.Octave
                pkg('install', OTP.packagePath());
            else
                matlab.addons.toolbox.installToolbox(OTP.packagePath());
            end
            
            fprintf('ODE Test Problems successfully installed\n');
        end
        
        function uninstall()
            if OTP.Octave
                pkg('uninstall', lower(OTP.Name));
            else
                tbxs = matlab.addons.toolbox.installedToolboxes;
                otp = tbxs(arrayfun(@(t) strcmp(t.Name, OTP.Name), tbxs));
                if ~isempty(otp)
                    matlab.addons.toolbox.uninstallToolbox(otp);
                end
            end
        end
    end
    
    methods (Static, Access = private)
        function processFiles(str, replacement, src, dest)
            list = dir(src);
            mkdir(dest);
            
            for i = 1:length(list)
                item = list(i);
                newSrc = fullfile(src, item.name);
                newDest = fullfile(dest, item.name);
                
                if ~item.isdir
                    [~, ~, ext] = fileparts(item.name);
                    if strcmp(ext, '.m')
                        OTP.replaceInFile(str, replacement, newSrc, newDest);
                    else
                        copyfile(newSrc, newDest);
                    end
                elseif ~any(strcmp(item.name, {'.', '..'}))
                    OTP.processFiles(str, replacement, newSrc, newDest);
                end
            end
        end

        function replaceInFile(str, replacement, src, dest)
            if nargin < 4
                dest = src;
            end

            content = regexprep(fileread(src), str, replacement, 'dotexceptnewline');
            fid = fopen(dest, 'w');
            fprintf(fid, '%s', content);
            fclose(fid);
        end

        function path = packagePath()
            if OTP.Octave
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
