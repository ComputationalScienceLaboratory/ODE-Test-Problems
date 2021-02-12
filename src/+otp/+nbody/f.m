function xPrime = f(~, x, spatialDim, masses, gravitationalConstant, softeningLength)

bodies = length(masses);

posLength = bodies * spatialDim;

xPrime = [x(posLength + 1:end); zeros(posLength, 1)];

for i = 1:bodies
    iStartIdx = spatialDim * (i - 1) + 1;
    iEndIdx = spatialDim * i;
    
    posI = x(iStartIdx:iEndIdx);
    
    for j = (i + 1):bodies
        jStartIdx = spatialDim * (j - 1) + 1;
        jEndIdx = spatialDim * j;
        deltaPos = x(jStartIdx:jEndIdx) - posI;
        
        deltaAccel = gravitationalConstant * deltaPos / (sum(deltaPos.^2) + softeningLength^2)^(1.5);
        
        xPrime(posLength + (iStartIdx:iEndIdx)) = xPrime(posLength + (iStartIdx:iEndIdx)) + masses(j) * deltaAccel;
        xPrime(posLength + (jStartIdx:jEndIdx)) = xPrime(posLength + (jStartIdx:jEndIdx)) - masses(i) * deltaAccel;
    end
end

end
