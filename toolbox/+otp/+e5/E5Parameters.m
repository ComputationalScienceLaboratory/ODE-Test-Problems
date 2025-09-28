classdef E5Parameters < otp.Parameters
    % Parameters for the E5 problem.

    properties
        A %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        B %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        C %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        M %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = E5Parameters(varargin)
            % Create an E5 parameters object.
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
