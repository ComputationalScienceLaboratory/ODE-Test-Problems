function yPrime = f(~, y)

yPrime = [
    -1.71 * y(1) + 0.43 * y(2) + 8.32 * y(3) + 0.0007;
    1.71 * y(1) - 8.75 * y(2);
    -10.03 * y(3) + 0.43 * y(4) + 0.035 * y(5);
    8.32 * y(2) + 1.71 * y(3) - 1.12 * y(4);
    -1.745 * y(5) + 0.43 * y(6) + 0.43 * y(7);
    -280 * y(6) * y(8) + 0.69 * y(4) + 1.71 * y(5) - 0.43 * y(6) + 0.69 * y(7);
    280 * y(6) * y(8) - 1.81 * y(7);
    -280 * y(6) * y(8) + 1.81 * y(7)];

end