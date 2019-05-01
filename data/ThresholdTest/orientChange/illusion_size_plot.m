plot(subIlluDegree');
legend('rightward','leftward','location','southeast');
ax = gca;
ax.FontSize = 20;
meansubIlluDegree = mean(subIlluDegree(:,20:end),2);
meansubIlluDegree'
saveas(figure(1),[pwd '/shariff.png']);