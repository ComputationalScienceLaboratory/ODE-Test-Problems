classdef RobertsonParameters < otp.Parameters
    % Parameters for the Robertson problem.
    properties
        % The reaction rate $K_1$.
        K1 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
        % The reaction rate $K_2$.
        K2 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
        % The reaction rate $K_3$.
        K3 %MATLAB ONLY: (1, 1) {mustBeReal, mustBeNonnegative}
    end

    methods
        function obj = RobertsonParameters(varargin)
            % Create a Robertson parameters object.
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
