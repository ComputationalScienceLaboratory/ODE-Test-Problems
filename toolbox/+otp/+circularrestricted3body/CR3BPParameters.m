classdef CR3BPParameters < otp.Parameters
    % Parameters for the CR3BP problem.

    properties
        % Relative mass of the system.
        Mu %MATLAB ONLY: (1, 1) {otp.utils.validation.mustBeNumerical}
        
        % A factor to avoid singularity when computing distances.
        SoftFactor %MATLAB ONLY: (1, 1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = CR3BPParameters(varargin)
            % Create a CR3BP parameters object.
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
