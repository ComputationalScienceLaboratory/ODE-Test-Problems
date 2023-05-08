function mustBeNumerical(x)

if ~otp.utils.validation.isNumerical(x)
    throwAsCaller(MException('OTP:notNumerical', 'Value must be numerical.'));
end

end
