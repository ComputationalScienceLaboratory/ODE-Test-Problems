function jac = jacobian(~, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate)

jac = [preyBirthRate - preyDeathRate*y(2), -preyDeathRate*y(1); ...
    predatorBirthRate*y(2), -predatorDeathRate + predatorBirthRate*y(1)];

end
