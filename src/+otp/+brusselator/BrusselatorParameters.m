classdef BrusselatorParameters
    %BRUSSELATORPARAMETERS Parameters for the Brusselator problem
    %   See also otp.brusselator.BrusselatorProblem
    properties
        %A concentration of excess reactant A in the Brusselator reaction
        A %MATLAB ONLY: (1,1) {mustBeNumeric}
        %B concentration of excess reactant B in the Brusselator reaction
        B %MATLAB ONLY: (1,1) {mustBeNumeric}
    end
end
