classdef TransistorAmplifierParameters
    properties
        %C are the magnitudes of the change in voltage of the capacitors
        C (1, 5) {mustBeFinite, mustBePositive} = (1:5)*1e-6
        %R denotes the resistances
        R (1, 10) {mustBeFinite, mustBePositive} = [1000, 9000*ones(1,9)]
        %UB is the operating voltage
        Ub (1,1) {mustBeFinite, mustBePositive} = 6
        %UF is an auxillary voltage
        UF (1,1) {mustBeFinite, mustBePositive} = 0.026
        %ALPHA controls the current coming through the gate
        Alpha (1,1) {mustBeFinite, mustBePositive} = 0.99
        %BETA is an auxillary constant
        Beta (1,1) {mustBeFinite, mustBePositive} = 1e-6
    end
end
