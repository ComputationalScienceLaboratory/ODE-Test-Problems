classdef ArenstorfParameters
    %ARENSTORFPARAMETERS User-configurable parameters for the Arenstorf problem
    %
    %   See also otp.arenstorf.ArenstorfProblem
    
    properties
        %MU The mass of one body, while the other body has mass MU'=1-Mu
        Mu %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
    end
end
