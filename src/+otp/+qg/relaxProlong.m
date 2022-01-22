function u = relaxProlong(u, newsizename)

s1 = size(u, 1);

[s2x, s2y] = otp.qg.QuasiGeostrophicProblem.name2size(newsizename);

size2n = @(s) round(log2((round(sqrt(1 + 8*s)) + 3)/4));

n1 = size2n(s1);
n2 = size2n(s2x*s2y);

if n1 > n2
    
    for i = 1:(n1 - n2)
        
        ni = n1 - i + 1;
       
        six = 2^ni - 1;
        siy = 2^(ni + 1) - 1;
        
        sjx = 2^(ni - 1) - 1;
        sjy = 2^ni - 1;
        
        [If2c, ~] = otp.utils.pde.relaxprolong2D(six, sjx, siy, sjy);
        
        u = If2c*u;
        
    end
    
elseif n1 < n2
    
    for i = 1:(n2 - n1)
        
        ni = n1 + i - 1;
        
        six = 2^ni - 1;
        siy = 2^(ni + 1) - 1;
        
        sjx = 2^(ni + 1) - 1;
        sjy = 2^(ni + 2) - 1;
        
        [~, Ic2f] = otp.utils.pde.relaxprolong2D(sjx, six, sjy, siy);
        
        u = Ic2f*u;
        
    end
    
end

end
