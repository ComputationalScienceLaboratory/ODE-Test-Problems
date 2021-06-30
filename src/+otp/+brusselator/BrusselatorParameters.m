classdef BrusselatorParameters
    properties
        ReactionRateA (1, 1) {mustBeReal, mustBePositive, mustBeFinite} = 1
        ReactionRateB (1, 1) {mustBeReal, mustBePositive, mustBeFinite} = 1
    end
end
