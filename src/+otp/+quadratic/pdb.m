function jB = pdb(~, y, ~, B, ~)

r = size(B, 1);

jB = kron(y.', speye(r));

end
