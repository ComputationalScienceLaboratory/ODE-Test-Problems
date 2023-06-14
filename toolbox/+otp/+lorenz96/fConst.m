function dy = fConst(~, y, F)

dy = -y([end, 1:(end - 1)], :).*(y([end - 1, end, 1:(end - 2)], :) - y([2:end, 1], :)) - y + F;

end
