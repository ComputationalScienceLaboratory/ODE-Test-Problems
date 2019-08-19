disp('Packaging toolbox');
matlab.addons.toolbox.packageToolbox('ODE Test Problems.prj', 'ODE Test Problems.mltbx');
disp('Toolbox packaged');

disp('Installing toolbox');
matlab.addons.toolbox.installToolbox('ODE Test Problems.mltbx');
disp('Toolbox installed');