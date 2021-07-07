function mustBeNumericOrSym(x)

if ~isnumeric(x) && ~isa(x, 'sym')
    throwAsCaller(MException('mustBeNumericOrSym:notNumericOrSym', 'Value must be numeric or symbolic.'));
end

end
