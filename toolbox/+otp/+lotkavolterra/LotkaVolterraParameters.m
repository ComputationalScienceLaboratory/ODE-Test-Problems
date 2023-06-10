classdef LotkaVolterraParameters
    properties
        %PREYBIRTHRATE determines the rate at which the prey is born it is a source term
        PreyBirthRate %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
        %PREYDEATHRATE determines how fast the prey is killed by the predators
        PreyDeathRate %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
        %PREDATORDEATHRATE is a sink term for the predators
        PredatorDeathRate %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
        %PREDATORBIRTHRATE determines how fast the predators are born based on the amount of prey that exists
        PredatorBirthRate %MATLAB ONLY: (1,1) {mustBeReal, mustBeFinite, mustBePositive} = 1
    end
end
