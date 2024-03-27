classdef TrigonometricDAEParameters < otp.Parameters
    % Parameters for the trigonometric DAE problem.
    
    methods
        function obj = TrigonometricDAEParameters(varargin)
            % Create a trigonometric DAE parameters object.
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

