function retVal = isOctave(octaveVal, matlabVal)
    persistent cacheval;

    if isempty(cacheval)
        cacheval = exist('OCTAVE_VERSION', 'builtin') > 0;
    end

    if nargin == 0
        retVal = cacheval;
    elseif cacheval
        retVal = octaveVal;
    else
        retVal = matlabVal;
    end
end
