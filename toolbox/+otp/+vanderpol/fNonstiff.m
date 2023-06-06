function dy = fNonstiff(~, y, ~)

dy = [y(2, :); zeros(1, size(y, 2))];

end
