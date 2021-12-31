classdef ZlaKineticsParameters
    %ZLAKINETICSPARAMETERS 
    %
    
    properties
        %k are the reaction rates of ancillary reactions
        k %MATLAB ONLY: (1,4) {mustBeReal, mustBeFinite, mustBePositive} = [18.7, 0.58, 0.09, 0.42];
        %K is the ZLA reaction rate
        K %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 34.4;
        %KLA is the mass transfer coefficient
        KlA %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 3.3;
        %KS is the equilibrium constant
        Ks %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 115.83;
        %PCO2 is the partial CO_2 pressure
        PCO2 %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 0.9;
        %H is the Henry constant
        H %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 737;
    end
end
