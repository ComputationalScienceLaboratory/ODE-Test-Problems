classdef Lorenz96Parameters < otp.Parameters
    % Parameters for the Lorenz '96 problem.
    
    properties
        % A forcing function, scalar, or vector.
        F %MATLAB ONLY: {mustBeA(F, {'numeric','function_handle'})}
    end

    methods
        function obj = Lorenz96Parameters(varargin)
            % Create a Lorenz '96 parameters object.
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
