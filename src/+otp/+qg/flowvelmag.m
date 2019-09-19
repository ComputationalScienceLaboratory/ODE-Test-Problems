function m = flowvelmag(psi, Ddx, Ddy)

m = sqrt((Ddx*psi).^2 + (Ddy*psi).^2);

end
