function [ALL]=F_data_arrange(ps, CNT, A)
    [~,a] = size(A);
    ALL(1:CNT,1) = ps'        ;
    for i=1:a
        ALL(1:CNT,i+1) = A(1:CNT,i);
    end
end
