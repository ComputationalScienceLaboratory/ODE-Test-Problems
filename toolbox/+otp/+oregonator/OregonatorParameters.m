classdef OregonatorParameters
    % Parameters for the Oregonator problem.
    properties
        % The stoichiometric factor $f$.
        F %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
        
        % The reaction constant $q$.
        Q %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
        
        % The reaction constant $s$.
        S %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
        
        % The reaction constant $w$.
        W %MATLAB ONLY: (1, 1) {mustBeReal, mustBeFinite}
    end
end

