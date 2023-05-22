function X = pagemtimes(A, B, C, D)
% OCTAVE FIX: This function is a naive implementation of the pagemtimes
% functionality for the purposes of supporting octave and legacy matlab
% installations

if nargin == 2
    transpA = 'none';
    transpB = 'none';
elseif nargin == 4
    transpA = B;
    transpB = D;
    B = C;
else
    error('OTP:invalidNumberOfArguments', 'The number of arguments has to be 2 or 4.');
end

mfun = @mtimes;

X = otp.utils.compatibility.pagemfun(A, transpA, B, transpB, mfun);

end
