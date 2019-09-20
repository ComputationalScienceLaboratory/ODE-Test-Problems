function xPrime = f(~, x, spacialDim, masses, gravitationalConstant, softeningLength)

bodies = length(masses);

posLength = bodies * spacialDim;

xPrime = [x(posLength + 1:end); zeros(posLength, 1)];

for i = 1:bodies
    iStartIdx = spacialDim * (i - 1) + 1;
    iEndIdx = spacialDim * i;
    
    posI = x(iStartIdx:iEndIdx);
    
    for j = (i + 1):bodies
        jStartIdx = spacialDim * (j - 1) + 1;
        jEndIdx = spacialDim * j;
        deltaPos = x(jStartIdx:jEndIdx) - posI;
        
        deltaAccel = gravitationalConstant * deltaPos / (sum(deltaPos.^2) + softeningLength^2)^(1.5);
        
        xPrime(posLength + (iStartIdx:iEndIdx)) = xPrime(posLength + (iStartIdx:iEndIdx)) + masses(j) * deltaAccel;
        xPrime(posLength + (jStartIdx:jEndIdx)) = xPrime(posLength + (jStartIdx:jEndIdx)) - masses(i) * deltaAccel;
    end
end

end