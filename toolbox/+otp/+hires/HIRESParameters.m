classdef HIRESParameters < otp.Parameters
    % Parameters for the HIRES problem.

    methods
        function obj = HIRESParameters(varargin)
            % Create a HIRES parameters object.
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

