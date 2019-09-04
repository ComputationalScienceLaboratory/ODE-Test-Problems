function dy = fconst(~, y, F)

dy = -y([end, 1:(end - 1)]).*(y([end - 1, end, 1:(end - 2)]) - y([2:end, 1])) - y(1:end) + F;

end
