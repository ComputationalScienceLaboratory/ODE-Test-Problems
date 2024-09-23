classdef InverterChainParameters < otp.Parameters
    % Parameters for the inverter chain problem.
    
    properties
        U0 %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        UIn %MATLAB ONLY: (1,1) {mustBeA(UIn, 'function_handle')} = @(t) 0
        
        UOp %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        UT %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
        
        Gamma %MATLAB ONLY: (1,1) {otp.utils.validation.mustBeNumerical}
    end

    methods
        function obj = InverterChainParameters(varargin)
            % Create an inverter chain parameters object.
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
