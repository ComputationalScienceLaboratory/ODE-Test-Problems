function M = mass(~, ~, C, ~, ~, ~, ~, ~)

M = blkdiag([-C(1), C(1); C(1), -C(1)], ...
    -C(2),...
    [-C(3), C(3); C(3), -C(3)], ...
    -C(4), ...
    [-C(5), C(5); C(5), -C(5)]);

end