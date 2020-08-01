function dy = f(~, y, m1 ,m2)

    D1 = ((y(1) + m1)^2 + y(2)^2)^(3/2);
    D2 = ((y(1) - m2)^2 + y(2)^2)^(3/2);
    
    dy = [y(3:4);
          y(1) + 2*y(4) - m2/D1*(y(1) + m1) - m1/D2*(y(1) - m2);
          y(2) - 2*y(3) - m2/D1*y(2)  - m1/D2*y(2)];
      
end
