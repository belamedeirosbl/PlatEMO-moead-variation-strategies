function OffDec = OperatorEDAOnly(Problem, Parent)

    alpha = 3.0;     

    ParentDec = Parent.decs;        % [T x D_full]
    xi        = ParentDec(1, :);    % solução atual do subproblema i

    Type = arrayfun(@(k) find(Problem.encoding == k), 1:5, 'UniformOutput', false);
    OffDec = xi;

    if isempty([Type{1:2}])
        return;
    end

    idx  = [Type{1:2}];
    lo   = Problem.lower(idx);
    hi   = Problem.upper(idx);
    T    = size(ParentDec, 1);
    X    = ParentDec(:, idx);       
    D    = length(idx);

    centro    = mean(X, 1);
    dists     = sum((X - centro).^2, 2);        
    [~, ord]  = sort(dists);                   
    ranks     = zeros(T, 1);
    ranks(ord) = 1:T;

    w_raw  = alpha .^ (T - ranks);
    w      = w_raw / sum(w_raw);             

    mu = (w' * X);                              
    
    sigma = std(X, 0, 1);                       % [1 x D]
    sigma = max(sigma, 1e-6 * (hi - lo));       % evita sigma = 0

    v = mu + sigma .* randn(1, D);

    OffDec(idx) = min(max(v, lo), hi);
end