function mustBeNumerical(x)

if ~otp.utils.validation.isNumerical(x)
    throwAsCaller(MException('OTP:notNumeric', 'Value must be numeric.'));
end

end
