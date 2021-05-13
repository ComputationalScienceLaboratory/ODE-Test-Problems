function dy = f(~, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate)

dy = [preyBirthRate*y(1, :) - preyDeathRate*y(1, :).*y(2, :);
    -predatorDeathRate*y(2, :) + predatorBirthRate*y(1, :).*y(2, :)];

end
