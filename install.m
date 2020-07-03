function install(uninstall)

name = 'ODE Test Problems';

toolboxes = matlab.addons.toolbox.installedToolboxes;
otp = toolboxes(arrayfun(@(t) strcmp(t.Name, name), toolboxes));

if nargin > 0 && (isequal(uninstall, false) || strcmpi(uninstall, 'false'))
    if isempty(otp)
        warning('Cannot uninstall %s when it is not installed', name);
    else
        matlab.addons.toolbox.uninstallToolbox(otp);
        fprintf('%s version %s has been uninstalled\n', name, otp.Version);
    end
    return;
end

toolboxName = sprintf('%s.mltbx', name);
matlab.addons.toolbox.packageToolbox(sprintf('%s.prj', name), toolboxName);
otpNew = matlab.addons.toolbox.installToolbox(toolboxName);

if isempty(otp)
    fprintf('%s version %s has been installed\n', name, otpNew.Version);
else
    fprintf('%s has been upgraded from version %s to %s\n', name, otp.Version, otpNew.Version);
end

disp('--------------------------------------------------------------------------------');
disp('If you are going to be using the test problems in your research, please cite:');
disp('@article{DBLP:journals/corr/abs-1901-04098,');
disp('  author    = {Steven Roberts and Andrey A. Popov and Adrian Sandu},');
disp('  title     = {{ODE} Test Problems: a {MATLAB} suite of initial value problems},');
disp('  journal   = {CoRR},');
disp('  volume    = {abs/1901.04098},');
disp('  year      = {2019},');
disp('  url       = {http://arxiv.org/abs/1901.04098},');
disp('  archivePrefix = {arXiv},');
disp('  eprint    = {1901.04098},');
disp('  timestamp = {Fri, 01 Feb 2019 13:39:59 +0100}');
disp('}');

end
