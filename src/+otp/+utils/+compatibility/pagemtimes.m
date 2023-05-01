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

if ndims(A) > 3 || ndims(B) > 3
    error('OTP:notImplemented', 'Dimensions greater than 3 are not supported.');
end

% repmat A or B depending on the third dimension 
N = max(size(A, 3), size(B, 3));

if size(A, 3) == 1
    repmat(A, 1, 1, N);
elseif size(A, 3) ~= N
    error('OTP:dimensionMismatch', 'The dimensions of A and B do not match.');
end

if size(B, 3) == 1
    repmat(B, 1, 1, N);
elseif size(B, 3) ~= N
    error('OTP:dimensionMismatch', 'The dimensions of A and B do not match.');
end

% transpose A and B as required
switch transpA 
    case 'transpose'
        A = permute(A, [2, 1, 3]);
    case 'ctranspose'
        A = permute(conj(A), [2, 1, 3]);
end

switch transpB
    case 'transpose'
        B = permute(B, [2, 1, 3]);
    case 'ctranspose'
        B = permute(conj(B), [2, 1, 3]);
end

for i = N:-1:1
    X(:, :, i) = A(:, :, i)*B(:, :, i);
end

end
