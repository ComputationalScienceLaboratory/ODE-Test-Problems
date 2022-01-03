classdef RobertsonParameters
    %ROBERTSONPARAMETERS User-configurable parameters for the Robertson problem
    %
    %   See also otp.robertson.RobertsonProblem
    
    properties
        K1 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
        K2 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
        K3 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
    end
end
