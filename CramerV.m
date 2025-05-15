function v = VCramer(signal, maxdelay)
    signal = categorical(signal);
    signal_ohe = onehotencode(signal,1);

    rel_freq = 1/length(signal_ohe) * sum(signal_ohe, 2);
    freq_matrix = rel_freq*rel_freq';
    
    contingen_matrix  = zeros(length(signal), size(signal_ohe, 1), size(signal_ohe, 1));
    for delay = 1:maxdelay
        for i =1:length(rel_freq)
            for j=1:length(rel_freq)
                contingen_matrix(delay, i, j) = mean(signal_ohe(i, delay:end).*signal_ohe(j, 1:end-delay+1));
            end
        end
    end

    for k=1:maxdelay
        v(k) = sqrt(sum(((squeeze(contingen_matrix(k,:,:)) - freq_matrix).^2)./freq_matrix, 'all')/(size(signal_ohe,1)-1));
    end
    v(find(v>1)) = 1; 
end
