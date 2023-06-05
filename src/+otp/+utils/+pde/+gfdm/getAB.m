function [A, B, alldivs] =  getAB(mesh, meshBC, order, weightfun, hfun)

[spatialdim, nmesh] = size(mesh);
[~, nmeshbc] = size(meshBC);
nmeshfull = nmesh + nmeshbc;
meshfull = [mesh, meshBC];

alldivs = struct('div', {}, 'mult', {});

for ord = 1:order
    unique = getallpartial(spatialdim, ord);

    alldivs = [alldivs, unique];
end

%weightfun = @(d, r) exp(-0.5*(d/r).^2);

ndivterms = numel(alldivs);

W = sparse(nmeshfull, nmesh);

%% build A and B matrix
A = zeros(ndivterms, ndivterms, nmesh);
B = zeros(ndivterms, nmeshfull, nmesh);
for mi = 1:nmesh
meshi = mesh(:, mi);

h = hfun(meshfull, meshi);

w = weightfun(meshfull, meshi);

W(:, mi) = w.';

for i = 1:ndivterms
    dvi = alldivs(i).div;
    divmi = 1/prod(1:numel(dvi));
    divmi = divmi*(alldivs(i).mult);
    
    for j = 1:ndivterms
        dvj = alldivs(j).div;
        divmj = 1/prod(1:numel(dvj));
        divmj = divmj*(alldivs(j).mult);

        b = divmi*(w.^2);

        a = divmj*divmi*(w.^2);
        for ii = 1:numel(dvi)
            divc = dvi(ii);
            a = a.*h(divc, :);
            b = b.*h(divc, :);
        end
        B(i, :, mi) = b;
        for jj = 1:numel(dvj)
            divc = dvj(jj);
            a = a.*h(divc, :);
        end
        A(i, j, mi) = sum(a);
       
    end
end

end

end


function unique = getallpartial(dim, div)

alldivs = combn(dim, div);

unique = struct;
unique.div = alldivs{1};
unique.mult = 1;


for i = 2:numel(alldivs)

    wat = alldivs{i};
    
    isthere = false;
    % check if it is in unique
    for j = 1:numel(unique)
        wat2 = unique(j).div;
        if wat == wat2
            % if it is increase multiplicity
            isthere = true;
            unique(j).mult = unique(j).mult + 1;     
            break
        end
    end

    if ~isthere
        unique(end + 1) = struct('div', wat, 'mult', 1);
    end
    
end

end
    

function strs = combn(objs, ways)

strs = {};

if ways == 1
    for i = 1:objs
        strs{end + 1} = i;
    end
else
    for i = 1:objs
        ends = combn(objs, ways - 1);
        for j = 1:numel(ends)
            strs{end + 1} = sort([i, ends{j}]);
        end
    end
end

end