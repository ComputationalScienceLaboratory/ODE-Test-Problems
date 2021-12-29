function xPrime = f(~, x, spatialdim, masses, gravitationalconstant, softeninglength)

bodies = length(masses);

posLength = bodies * spatialdim;

xPrime = [x(posLength + 1:end); zeros(posLength, 1)];

for i = 1:bodies
    iStartIdx = spatialdim * (i - 1) + 1;
    iEndIdx = spatialdim * i;
    
    posI = x(iStartIdx:iEndIdx);
    
    for j = (i + 1):bodies
        jStartIdx = spatialdim * (j - 1) + 1;
        jEndIdx = spatialdim * j;
        deltaPos = x(jStartIdx:jEndIdx) - posI;
        
        deltaAccel = gravitationalconstant * deltaPos / (sum(deltaPos.^2) + softeninglength^2)^(1.5);
        
        xPrime(posLength + (iStartIdx:iEndIdx)) = xPrime(posLength + (iStartIdx:iEndIdx)) + masses(j) * deltaAccel;
        xPrime(posLength + (jStartIdx:jEndIdx)) = xPrime(posLength + (jStartIdx:jEndIdx)) - masses(i) * deltaAccel;
    end
end

end
