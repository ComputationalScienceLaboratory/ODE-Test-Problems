classdef SanzSernaParameters < otp.Parameters
    % Parameters for the Sanz-Serna problem.
    
    methods
        function obj = SanzSernaParameters(varargin)
            % Create a Sanz-Serna parameters object.
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
