classdef Lorenz96Parameters
    %LORENZ96PARAMETERS User-configurable parameters for the Lorenz 96 problem
    %
    %   See also otp.lorenz96.Lorenz96Problem
    
    properties
        %F is a forcing function, scalar, or vector
        F %MATLAB ONLY: {mustBeA(F, {'numeric','function_handle'})}
    end
end
