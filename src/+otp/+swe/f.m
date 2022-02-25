function dy = f(~, y, rsfunc, Dl, Dm, g, ai, fcoriolis, costh, tantha, sectha)

[h, u, v] = rsfunc(y);

forc = fcoriolis + (u.*tantha);

dh = -sectha.*(Dl*(h.*u) + (h.*(v.*costh))*Dm);
du = forc.*v - (sectha).*(u.*(Dl*u) + g*(Dl*h)) - ((ai*v).*(u*Dm));
dv = -forc.*u - (sectha).*(u.*(Dl*v)) - ((g*ai).*(h*Dm)) - ((ai*v).*(v*Dm));

dh = dh(:, 2:end-1);
dh = [mean(dh(:, 2)); dh(:); mean(dh(:, end-1))];
du = du(:, 2:end-1);
du = [0; du(:); 0];
dv = dv(:, 2:end-1);
dv = [mean(dv(:, 2)); dv(:); mean(dv(:, end-1))];

dy = [dh; du; dv];

end
