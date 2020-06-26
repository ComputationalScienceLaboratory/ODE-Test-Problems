function L = laplacian(n, domain, diffc, BC)

% Temp fix
n = fliplr(n);
BC = fliplr(BC);
domain = flipud(domain);

% assume dirichlet and 2-order CFD

dims = numel(n);
numvar = prod(n);
L = sparse(numvar, numvar);

% second order is hard-coded in.
FD = [1, -2, 1];

pa = floor(numel(FD)/2);


for dim = 1:dims
    
    nd = n(dim);

    LD = 1;
    
    switch BC(dim)
        case 'C'
            
            h = diff(domain(dim, :))/nd;
            c = diffc(dim)/(h^2);
            % cyclic
            
            cfdln1 = ((numel(FD)-1)/2);
            cfdln2 = ((numel(FD)-1)/2) + 2;
            
            diagonals = zeros(nd, 2*cfdln1 + numel(FD));
            
            diagonals(:, (cfdln1+1):(cfdln1 + numel(FD)))  = c*repmat(FD, nd, 1);
            
            for j = 1:cfdln1
                diagonals(:, j) = c*repmat(FD(cfdln2 + j - 1), n, 1);
                diagonals(:, (cfdln1 + numel(FD) + j)) = c*repmat(FD(j), n, 1);
            end
            
            ds = [(-nd+1):(-nd+((numel(FD)-1)/2)), (-pa):pa, (nd-((numel(FD)-1)/2)):(nd-1)];
            
        case 'D'
            h = diff(domain(dim, :))/(nd + 1);
            c = diffc(dim)/(h^2);
            
            diagonals = c*repmat(FD, nd, 1);
            
            ds = (-pa):pa;
        case 'N'
            h = diff(domain(dim, :))/(nd - 1);
            c = diffc(dim)/(h^2);
            
            diagonals = c*repmat(FD, nd, 1);
            
            % specific to second order
            diagonals(2, 3) = diagonals(1, 3)*2;
            diagonals(end-1, 1) = diagonals(end-1, 1)*2;
            
            ds = (-pa):pa;
        otherwise
            error('Other Boundary condition types are not supported');
    end
    
    D = spdiags(diagonals, ds, nd, nd);

    for i = 1:(dim - 1)
        LD = kron(LD, speye(n(i)));
    end
    LD = kron(LD, D);
    for i = (dim + 1):dims
        LD = kron(LD, speye(n(i)));
    end
    L = L + LD;
end

end
