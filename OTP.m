classdef OTP
    properties (Access = private, Constant)
        Octave = exist('OCTAVE_VERSION', 'builtin') > 0
        Name = 'ODE Test Problems';
        SrcDir = 'src';
        BuildDir = 'build';
    end
    
    methods (Static)
        function clean()
            [~] = rmdir(OTP.BuildDir, 's');
        end
        
        function build()
            OTP.clean();
            
            if OTP.Octave
                OTP.processFiles(OTP.SrcDir, fullfile(OTP.BuildDir, 'inst'), ...
                    {}, {});
                copyfile('DESCRIPTION', OTP.BuildDir);
                copyfile('LICENSE', fullfile(OTP.BuildDir, 'COPYING'));
                zip(OTP.packagePath(), OTP.BuildDir);
            else
                OTP.processFiles(OTP.SrcDir, OTP.BuildDir, ...
                    '\s*%\s*MATLAB ONLY:\s*', ' ');
                matlab.addons.toolbox.packageToolbox( ...
                    strcat(OTP.Name, '.prj'), OTP.packagePath());
            end
        end
        
        function install()
            OTP.build();
            
            if OTP.Octave
                pkg('install', OTP.packagePath());
            else
                matlab.addons.toolbox.installToolbox(OTP.packagePath());
            end
            
            fprintf('ODE Test Problems sucessfully installed\n');
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
        function processFiles(src, dest, str, replacement)
            list = dir(src);
            mkdir(dest);
            
            for i = 1:length(list)
                item = list(i);
                newSrc = fullfile(src, item.name);
                newDest = fullfile(dest, item.name);
                
                if ~item.isdir
                    [~, ~, ext] = fileparts(item.name);
                    if strcmp(ext, '.m')
                        content = regexprep(fileread(newSrc), str, replacement);
                        
                        fid = fopen(newDest, 'w');
                        fprintf(fid, '%s', content);
                        fclose(fid);
                    else
                        copyfile(newSrc, newDest);
                    end
                elseif ~any(strcmp(item.name, {'.', '..'}))
                    OTP.processFiles(newSrc, newDest, str, replacement);
                end
            end
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
