function weights = kernelExp(t, t_star, lambda)

t_star_idx = find(t==t_star);
t_sx = t(1:t_star_idx);
t_dx = t(t_star_idx:end);

weights = zeros(size(t));
weights(1:t_star_idx) = exp((t_sx - t_star) / lambda);
weights(t_star_idx:end) = exp(-(t_dx - t_star) / lambda);

end

