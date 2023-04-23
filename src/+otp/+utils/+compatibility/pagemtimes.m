function x = pagemtimes(A, b)
% OCTAVE FIX: This function is a naive implementation of the pagemtimes
% functionality for the purposes of supporting octave and legacy matlab
% installations

N = size(A, 3);

x = zeros(size(A, 1), size(b, 2), N);

for i = 1:N
    x(:, :, i) = A(:, :, i)*b(:, :, i);
end

end
