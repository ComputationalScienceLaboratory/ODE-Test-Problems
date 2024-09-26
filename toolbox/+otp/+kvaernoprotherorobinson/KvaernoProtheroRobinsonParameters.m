classdef KvaernoProtheroRobinsonParameters < otp.Parameters
    % Parameters for the KPR problem.
    
    properties
        Lambda %MATLAB ONLY: (2,2) {otp.utils.validation.mustBeNumerical}
        
        Omega %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = KvaernoProtheroRobinsonParameters(varargin)
            % Create a KPR parameters object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. A name can be any property of this class, and the subsequent
            %    value initializes that property.

            obj = obj@otp.Parameters(varargin{:});
        end
    end
end
