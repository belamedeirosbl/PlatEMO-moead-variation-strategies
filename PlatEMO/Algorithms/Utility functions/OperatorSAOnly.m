function OffDec = OperatorSAOnly(Problem, Parent)
    Parent  = Parent.decs;
    Parent1 = Parent(1, :);  
    D       = size(Parent1, 2);
    OffDec  = Parent1;

    Type = arrayfun(@(i) find(Problem.encoding == i), 1:5, 'UniformOutput', false);

    if ~isempty([Type{1:2}])
        idx = [Type{1:2}];
        lo  = Problem.lower(idx);
        hi  = Problem.upper(idx);
        n   = length(idx);

        T = 0.1;   % temperatura fixa moderada (regime SA tardio)
        tau = 1.0; % fator de escala

        sigma  = 0.1 * (hi - lo);
        x_new  = Parent1(idx) + sigma .* randn(1, n);
        x_new  = min(max(x_new, lo), hi);

        objs_p = zeros(size(Parent, 1), size(Parent, 2));  % placeholder
        delta = sum(abs(x_new - Parent1(idx)) ./ (hi - lo)) / n;

        % Aceita sempre se melhora (delta ~ 0), aceita com prob exp(-delta/T) se piora
        if rand < exp(-tau * delta / T)
            OffDec(idx) = x_new;
        end
    end

    if ~isempty(Type{3}), OffDec(Type{3}) = Parent1(Type{3}); end
    if ~isempty(Type{4}), OffDec(Type{4}) = Parent1(Type{4}); end
    if ~isempty(Type{5}), OffDec(Type{5}) = Parent1(Type{5}); end
end