classdef AllenCahnParameters
    %ALLENCAHNPARAMETERS User-configurable parameters for the Allen-Cahn Problem
    %
    %   See also otp.allencahn.AllenCahnProblem
    
    properties
        %Size is the dimension of the problem
        Size %MATLAB ONLY: (1,1) {mustBeInteger}
        %Alpha is non-negative diffusion constant
        Alpha %MATLAB ONLY: (1,1) {mustBeNonnegative}
        %Beta is a non-negative reaction constant
        Beta %MATLAB ONLY: (1,1) {mustBeNonnegative}
        %Forcing is a forcing function or constant
        Forcing %MATLAB ONLY: {mustBeA(Forcing, {'numeric', 'function_handle'})}
    end
end
