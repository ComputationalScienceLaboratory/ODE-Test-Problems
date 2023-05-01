function str = pad(str, nnew)
% OCTAVE FIX: octave does not support pad. Seriously

n = numel(str);

if nnew > n
    str = [str, repmat(' ', 1, nnew - n)];
end
