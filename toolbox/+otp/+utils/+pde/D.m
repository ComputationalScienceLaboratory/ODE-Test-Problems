function [D] = D(n, domain, BC) 

FD = [-1/2, 0, 1/2];

pa = floor(numel(FD)/2);

switch BC
    
    case 'D'
        
        h = diff(domain)/(n + 1);
        c = 1/(h);
        
        diagonals = c*repmat(FD, n, 1);
        
        ds = (-pa):pa;
        
    case 'C'
        
        h = diff(domain)/n;
        c = 1/(h);
        
        cfdln1 = ((numel(FD)-1)/2);
        cfdln2 = ((numel(FD)-1)/2) + 2;
        
        diagonals = zeros(n, 2*cfdln1 + numel(FD));
        
        diagonals(:, (cfdln1+1):(cfdln1 + numel(FD)))  = c*repmat(FD, n, 1);
        
        for j = 1:cfdln1
            diagonals(:, j) = c*repmat(FD(cfdln2 + j - 1), n, 1);
            diagonals(:, (cfdln1 + numel(FD) + j)) = c*repmat(FD(j), n, 1);
        end
        
        ds = [(-n+1):(-n+((numel(FD)-1)/2)), (-pa):pa, (n-((numel(FD)-1)/2)):(n-1)];
    otherwise
        
end

D = spdiags(diagonals, ds, n, n);

end
