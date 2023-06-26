classdef InverterChainParameters
    %INVERTERCHAINPARAMETERS 
    properties
        U0 %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBeNonnegative}
        
        UIn %MATLAB ONLY: {mustBeA(UIn, 'function_handle')} = @(t) 0
        
        UOp %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
        
        UT %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
        
        Gamma %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
    end
end
