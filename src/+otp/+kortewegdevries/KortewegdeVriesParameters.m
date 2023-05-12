classdef KortewegdeVriesParameters
    %KORTEWEGDEVRIES PARAMETERS
    %
    properties

        Domain %MATLAB ONLY: (1,2) {mustBeFinite} = [-10, 10]
        Nx %MATLAB ONLY: (1,1) {mustBeFinite, mustBeInteger, mustBePositive} = 200
        Grid %MATLAB ONLY: (:,1) {mustBeFinite}
        InitialCondition %MATLAB ONLY: (1,1) {validateInitialCondition(InitialCondition)} = @(x) 6*(sech(x).^2)
        Theta %MATLAB ONLY: (1,1) {mustBeFinite, mustBeInRange(Theta, 0, 1)} = 0
        Alpha %MATLAB ONLY: (1,1) {mustBeFinite} = -3
        Nu %MATLAB ONLY: (1,1) {mustBeFinite} = -1
        Rho %MATLAB ONLY: (1,1) {mustBeFinite} = 0

    end

end

function validateInitialCondition(f)

flag1 = isequal(class(f), 'function_handle');
flag2 = nargin(f) == 1;

if ~(flag1 && flag2)
    error(['Error setting property ''InitialCondition'' of class ''otp.kortewegdevries.KortewegdeVriesParameters''', ...
        newline ,...
        'Value must be a function_handle taking in one input.'])
end

end
