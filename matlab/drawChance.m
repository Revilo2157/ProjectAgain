clear; format short e

fid = fopen("../outputs/divider_dshift/chance.txt");
S = textscan(fid, "%s %f");
chance = S{2}(1);
x = [];
for ind = S{1}(3:end).'
   x = [x str2double(ind{1})];
end
x = x.'
y = S{2}(3:end)

figure(5); clf
hold on
plot(x, y)

coeffs = polyfit(x, y, 2)
y2 = polyval(coeffs, x);
plot(x, y2)


ylabel("SDQL")
xlabel("Max Fault Size (ns)")
title(sprintf("SDQL vs Maximum Fault Size (Fault Chance = %d%%)", chance))
% saveas(figure(3), "div_times.png");