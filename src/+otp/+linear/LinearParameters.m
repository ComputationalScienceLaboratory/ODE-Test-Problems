classdef LinearParameters
    %LINEARPARAMETERS
    %
    properties
        %A is a cell array of same size inputs
        A %MATLAB ONLY: {mustBeNumericCell} = {-1}
    end
end

function mustBeNumericCell(A)
    if ~(iscell(A)) || ~all(cellfun(@(m) ismatrix(m) && isnumeric(m), A))
        eidType = 'mustBeNumericCell:notNumericCellArray';
        msgType = 'Input must be a cell array of numeric types.';
        throwAsCaller(MException(eidType,msgType))
    end
end
