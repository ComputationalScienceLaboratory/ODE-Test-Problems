classdef LinearParameters < otp.Parameters
    % Parameters for the linear problem.
    
    properties
        %LAMBDA is a cell array of same size inputs
        Lambda %MATLAB ONLY: {mustBeNonempty, otp.utils.validation.mustBeNumericalCell} = {-1}
    end

    methods
        function obj = LinearParameters(varargin)
            % Create a linear parameters object.
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
