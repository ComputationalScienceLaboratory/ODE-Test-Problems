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

if numel(size(A)) > 3 || numel(size(B)) > 3
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
        Anew = zeros(size(A, 2), size(A, 1), N);
        for i = 1:N
            Anew(:, :, i) = A(:, :, i).';
        end
        A = Anew;
    case 'ctranspose'
        Anew = zeros(size(A, 2), size(A, 1), N);
        for i = 1:N
            Anew(:, :, i) = A(:, :, i)';
        end
        A = Anew;
end

switch transpB
    case 'transpose'
        Bnew = zeros(size(B, 2), size(B, 1), N);
        for i = 1:N
            Bnew(:, :, i) = B(:, :, i).';
        end
        B = Bnew;
    case 'ctranspose'
        Bnew = zeros(size(B, 2), size(B, 1), N);
        for i = 1:N
            Bnew(:, :, i) = B(:, :, i)';
        end
        B = Bnew;
end


X = zeros(size(A, 1), size(B, 2), N);

for i = 1:N
    X(:, :, i) = A(:, :, i)*B(:, :, i);
end

end
