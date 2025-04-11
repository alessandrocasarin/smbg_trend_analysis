clear all
close all
clc 

load smbg.mat

%% Estrazione del trend mensile
% approssimazione con kernel esponenziale

t = [0:(length(ys)-1)]*8;

figure
plot(t, ys, 'LineWidth', 2)
hold on
for i = 0:24:t(end)
    line([i, i], [50 300], 'Color', [0 0 0 0.5], 'LineStyle', '--')
end
hold off
xlim([t(1) t(end)])
ylim([50 300])
xlabel('tempo [ore]')
ylabel('SMBG [mg/dL]')
title('Dati originali')

monthly_trend = zeros(size(t));
for lambda=10:10:100

    for i=1:length(t)
        weights = kernelExp(t, t(i), lambda);
        monthly_trend(i) = (weights*ys)./(sum(weights));
    end
    
    figure
    plot(t, monthly_trend, 'LineWidth', 2)
    xlim([t(1) t(end)])
    ylim([50 300])
    xlabel('tempo [ore]')
    ylabel('SMBG [mg/dL]')
    title(['Trend mensile - λ=', num2str(lambda)])

    pause(0.1)

end
clear('weights')

lambda = 50;
for i=1:length(t)
    weights = kernelExp(t, t(i), lambda);
    monthly_trend(i) = (weights*ys)./(sum(weights));
end


%% Estrazione del trend giornaliero
% approssimazione parametrica con polinomio di grado 3

ys_mat = [];

for i=1:3:(length(t)-3)
    ys_mat = [ys_mat; ys(i:i+3)'-monthly_trend(i:i+3)];
end

ts_day = [0:8:24]'; % griglia delle misurazioni con misure ogni 8 ore
ns_day = length(ts_day);

Tv = 1;
tv_day = [0:Tv:ts_day(end)]'; % griglia virtuale con tutte le ore
nv_day = length(tv_day);

G = [ts_day ones(ns_day, 1)];
Gv = [tv_day ones(nv_day, 1)];

for m=2:3
    G = [ts_day.^m G];
    Gv = [tv_day.^m Gv];

    daily_trend_mat = zeros(size(ys_mat, 1), length(tv_day));
    for day=1:size(ys_mat, 1)
        ys_day = ys_mat(day, :);
        ys_day = ys_day';
    
        a_hat = inv(G'*G)*G'*ys_day;
    
        yp_day = G*a_hat;
        daily_trend_mat(day, :) = Gv*a_hat;

        res_day = ys_day-yp_day;
    
        figure
        subplot(2, 1, 1)
        hold on
        plot(ts_day, ys_day, 'o-b', 'LineWidth', 1.5)
        plot(tv_day, daily_trend_mat(day, :), 'Color', 'red', 'LineWidth', 1.5)
        title(['Trend giornaliero (in riferimento al trend mensile) - m=', num2str(m), ' - giorno ', num2str(day)])
        xlim([tv_day(1) tv_day(end)])
        hold off
        subplot(2, 1, 2)
        plot(ts_day, res_day, 'o-g', 'LineWidth', 1.5)
        title(['Residui (m=', num2str(m), ') - giorno ', num2str(day)])
        xlim([tv_day(1) tv_day(end)])
         
        pause(0.1)
    end
    
    daily_trend = mean(daily_trend_mat, 1);
    
    figure
    hold on
    plot(ts_day, ys_mat, 'Color', [0 0 0 0.3])
    plot(tv_day, daily_trend, 'Color', 'Red', 'LineWidth', 2)
    xlabel('tempo [ore]')
    ylabel('SMBG [mg/dL]')
    xlim([tv_day(1) tv_day(end)])
    title(['Trend giornaliero (in riferimento al trend mensile) - m=', num2str(m)])
    
    hold off
end

%% Bande di variabilità

P = prctile(daily_trend_mat, [5 95], 1);

figure
hold on
fill([tv_day', fliplr(tv_day')], [P(1,:), fliplr(P(2,:))], [1 1 0], 'FaceAlpha', 0.5, 'LineStyle', 'none')
plot(ts_day, ys_mat, 'Color', [0 0 0 0.3])
plot(tv_day, daily_trend, 'Color', 'Red', 'LineWidth', 2)
xlim([tv_day(1) tv_day(end)])
xlabel('tempo [ore]')
ylabel('SMBG [mg/dL]')
title('Trend giornaliero con bande di variabilità')
hold off
