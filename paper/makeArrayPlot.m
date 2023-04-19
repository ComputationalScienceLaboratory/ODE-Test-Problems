setPlotOptions

m = otp.transistoramplifier.presets.Canonical;
sol = m.solve();

rows = ceil(sqrt(m.NumVars));

f2 = figure(); 



for i =1:rows*rows
    
    if i<m.NumVars
        subplot(rows,rows,i)
        
        plot(sol.x, sol.y(i,:))
        xlabel('t'); ylabel(strcat('y_',num2str(i)));
   
        
    end
end

save2pdf(m.Name)
    