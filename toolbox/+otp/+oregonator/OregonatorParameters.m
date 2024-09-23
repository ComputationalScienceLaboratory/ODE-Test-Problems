classdef OregonatorParameters < otp.Parameters
    % Parameters for the Oregonator problem.

    properties
        % The stoichiometric factor $f$.
        F %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        % The reaction constant $q$.
        Q %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        % The reaction constant $s$.
        S %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        % The reaction constant $w$.
        W %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = OregonatorParameters(varargin)
            % Create an Oregonator parameters object.
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

