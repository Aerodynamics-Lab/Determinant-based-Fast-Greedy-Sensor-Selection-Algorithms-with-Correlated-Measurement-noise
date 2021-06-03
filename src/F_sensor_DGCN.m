function [time, H, sensors, Rinv_DGCN]=F_sensor_DGCN(U,Un,Sn,p)
    [n,r]=size(U);
    tic
    [sensors,Rinv_DGCN,~]= F_sensor_DGCN_r(U,Un,Sn,min(p,r));
    if p>r
        [sensors,Rinv_DGCN,~]= F_sensor_DGCN_p(U,Un,Sn,p,sensors,Rinv_DGCN);
    end
    time=toc;
    [H] = F_calc_sensormatrix(p, n, sensors);
    if det(Rinv_DGCN)<0
        det(Rinv_DGCN)
    end
end