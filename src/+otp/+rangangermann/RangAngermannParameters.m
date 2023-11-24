classdef RangAngermannParameters
    % User-configurable parameters for the Rang-Angermann Problem
    %
    %   See also otp.rangangermann.RangAngermannProblem
    
    properties
        %Size is the dimension of the problem
        Size %MATLAB ONLY: (1,1) {mustBeInteger}
        %ForcingU is a forcing function
        ForcingU %MATLAB ONLY: {mustBeA(ForcingU, {'numeric', 'function_handle'})}
        %ForcingV is a forcing function
        ForcingV %MATLAB ONLY: {mustBeA(ForcingU, {'numeric', 'function_handle'})}
        %BoundaryConditionsU is a boundary
        BoundaryConditionsU %MATLAB ONLY: {mustBeA(BoundaryConditionsU, {'numeric', 'function_handle'})}
        %BoundaryConditionsV is a boundary
        BoundaryConditionsV %MATLAB ONLY: {mustBeA(BoundaryConditionsV, {'numeric', 'function_handle'})}
    
    end
end
