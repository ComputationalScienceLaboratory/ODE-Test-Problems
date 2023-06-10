function mustBeNumericalCell(x)

if ~iscell(x) || ~all(cellfun(@(m) ismatrix(m) && otp.utils.validation.isNumerical(m), x))
    throwAsCaller(MException('OTP:notNumericalCell', 'Value must be a cell array of numerical matrices.'));
end

end
