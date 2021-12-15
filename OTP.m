classdef OTP
    properties (Constant)
        Name = 'ODE Test Problems';
        SrcDir = 'src';
        BuildDir = 'build';
    end
    
    methods (Static)
        function clean()
            rmdir(OTP.BuildDir, 's');
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
            
            otp = ver(lower(OTP.Name));
            printf('OTP version %s installed\n', otp.Version);
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
            cmd = sprintf( ...
                'find %s -type f -name "*.m" -exec sed -i "s/%s/%s/g" {} +', ...
                OTP.BuildDir, ...
                str, ...
                replacement);
            [status, msg] = system(cmd);
            
            if status ~= 0
                error('Preprocessor failure: %s', msg);
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
