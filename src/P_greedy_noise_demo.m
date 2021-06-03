%% Main program
%% ///////////////////////////////////////////////////////////////////
% Comments:
% 	Collaborator: Keigo Yamada, Yuji Saito, Taku Nonomura,
%                 Kumi Nakai, Takayuki Nagata
% 	Last modified: 2021/6/3
% Nomenclature:
% - Scalars
%   n : Number of degrees of freedom of spatial POD modes (state dimension)
%   p : Number of sensors
%   r : Number of rank for truncated POD
%   m : Number of snaphot (temporal dimension)
% - Matrices
% 	X : Supervising data matrix
% 	Y : Observation matrix
% 	H : Sparse sensor location matrix
% 	U : Spatial POD modes matrix
% 	C : Measurement matrix
% 	Z : POD mode amplitude matrix
%% ===================================================================

clear; close all;
warning('off','all')

%% Selection of Problems ============================================
% num_problem=1; % //Randomized sensor problem//
num_problem=2; % //NOAA-SST//
%
%% Parameters =======================================================
r = 10;
pmin = 1;
pinc = 1;
pmax = 15;
ps   = pmin:pinc:pmax;
CNT = 0; % Counter
maxiteration = 200; % Max iteration for convex approximation

%/////////////////////////////
% //Randomized sensor problem//
n = 2000;
num_ave = 1; % Number of iteration for averaging operation
rn = 100; % Number of noise mode
%/////////////////////////////
% //NOAA-SST//
m = 52*10; % 10-years (52weeks/year)
num_video = 1; % maxmum: m
%/////////////////////////////
%% Preparation of output directories ================================
workdir   = ('../work');
videodir  = [workdir,'/video'];
sensordir = [workdir,'/sensor_location'];
mkdir(workdir);
mkdir(videodir);
mkdir(sensordir);

%% Randomized sensor problem ========================================
if num_problem == 1
    
    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);
        
        %% Average loop =============================================
        for w=1:1:num_ave
            
            %% Preprocess for Randomized problem ====================
            U = randn(n,r);
            Un = randn(n,rn);
            dS = sort(rand(rn+r,1),'descend');
            Q = diag(dS(1:r));
            Sn = diag(dS(r+1:end));
            
            %% Random selection -------------------------------------
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand (CNT,w+1) = F_calc_det  (p,H_rand,U);
                        
            %% D-optimality - Greedy --------------------------------
            [time_DG(CNT,w+1), H_DG, sensors_DG] = F_sensor_DG(U,p);
            det_DG (CNT,w+1) = F_calc_det  (p,H_DG,U);
            
            %% D-optimality - Greedy with correlated noise --------------------------------
            [time_DGCN(CNT,w+1), H_DGCN, sensors_DGCN, iR] = F_sensor_DGCN(U,Un,Sn,p);
            det_DGCN (CNT,w+1) = F_calc_det  (p,H_DGCN,U);

            %% D-optimality - Bayes Greedy --------------------------------
            [time_BDG(CNT,w+1), H_BDG, sensors_BDG, iR] = F_sensor_BDG(U,Un,Sn,p,Q);
            det_BDG (CNT,w+1) = F_calc_det  (p,H_BDG,U);
                        
        end
        
        %% Averaging ================================================
        [ time_rand, det_rand]...
            = F_data_ave1( CNT, num_ave, time_rand, det_rand);
        [ time_DG, det_DG]...
            = F_data_ave1( CNT, num_ave, time_DG, det_DG);
        [ time_DGCN, det_DGCN ]...
            = F_data_ave1( CNT, num_ave, time_DGCN, det_DGCN );
        [ time_BDG, det_BDG]...
            = F_data_ave1( CNT, num_ave, time_BDG, det_BDG );
%         NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
%         iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
        
        %% Sensor location ==========================================
        sensor_memo = [];
        sensor_memo = [sensor_memo sensors_rand(1:p)'];
        sensor_memo = [sensor_memo sensors_DG(1:p)];
        sensor_memo = [sensor_memo sensors_DGCN(1:p)];
        sensor_memo = [sensor_memo sensors_BDG(1:p)];
        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');
        
        text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        disp(text);
    end
    [time_all] = F_data_arrange( ps,   CNT, [time_rand, time_DG, time_DGCN,...
        time_BDG]);
    [det_all]  = F_data_arrange( ps,   CNT, [det_rand,  det_DG,  det_DGCN, ...
        det_BDG]);
    % Normalize
    [Normalized_det] = F_data_normalize( ps, CNT, det_rand, det_DG, det_DGCN, ...
        det_BDG);
    
    cd(workdir)
    save('time.mat','time_all');
    save('det.mat','det_all');
    save('Normalized_det.mat','Normalized_det');
    save('time_rand.mat','time_rand');
    save('det_rand.mat','det_rand');
    save('time_DG.mat','time_DG');
    save('time_DGCN.mat','time_DG');
    save('time_DG.mat','time_DG');
    save('det_DG.mat','det_DG');
    save('det_DGCN.mat','det_DG');
    save('det_BDG.mat','det_BDG');
    
end

%%NOAA-SST =========================================================
if num_problem == 2
    
    %% Preprocces for NOAA-SST ======================================
    text='Reading/Arranging a NOAA-SST dataset';
    disp(text);
    [Lat, Lon, time, mask, sst]...
        = F_pre_read_NOAA_SST( 'sst.wkmean.1990-present.nc', 'lsmask.nc');
    [Uorg, Sorg, Vorg, Xorg, meansst, n] = F_pre_SVD_NOAA_SST(m, time, mask, sst);
    [U, Un, Sn, Error_ave_pod, Error_std_pod]...
        = F_pre_truncatedSVD(r, Xorg, Uorg, Sorg, Vorg, num_video, meansst, mask, time, m, videodir);
    rms_sst = rms(Un*Sn*Vorg(:,r+1:end)',2);
    rms_large = find(rms_sst>(max(rms_sst)*10^-2));
    %Error_ave_pod = repmat( Error_ave_pod , size(ps,2) );
    text='Complete Reading/Arranging a NOAA-SST dataset!';
    disp(text);
    Q = Sorg(1:r,1:r).^2;
    CNT=0;
    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);
        
        %% Random selection -----------------------------------------
        % Average loop
        for w=1:1:num_ave
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand(CNT,w+1) = F_calc_det  (p,H_rand,U);
            iR =  F_calc_Rinv_scalar(Un,Sn,sensors_rand);
            [Zestimate_rand, Err] ...
                = F_calc_error(m, Xorg, U, H_rand,iR,Q);
            Error_rand_ls(CNT,w+1) = Err(1);
            Error_rand_gls(CNT,w+1) = Err(2);
            Error_rand_bayes(CNT,w+1) = Err(3);
        end
        % Averaging
        [ time_rand, det_rand, Error_rand_ls]...
            = F_data_ave2(CNT, num_ave, time_rand, det_rand, Error_rand_ls);
        
        %% D-optimality - Greedy ------------------------------------
        [time_DG(CNT,1), H_DG, sensors_DG] = F_sensor_DG(U,p);
        det_DG (CNT,1) = F_calc_det  (p,H_DG,U);
        iR =  F_calc_Rinv_scalar(Un,Sn,sensors_DG);
        [Zestimate_DG, Error_DG(CNT,:)] ...
            = F_calc_error(m, Xorg, U, H_DG,iR,Q);
            
        %% D-optimality - Greedy with correlated noise --------------------------------
        [time_DGCN(CNT,w+1), H, sensors] = F_sensor_DGCN(U...
            (rms_large,1:end),Un(rms_large,1:end),Sn,p);
%             (rms_large,1:end),Un(rms_large,1:30),Sn(1:30,1:30),p);
        sensors_DGCN = rms_large(sensors);
        H_DGCN = zeros(p,n); H_DGCN(:,rms_large) = H;
        det_DGCN (CNT,w+1) = F_calc_det  (p,H_DGCN,U);
        iR =  F_calc_Rinv_scalar(Un,Sn,sensors_DGCN);
        [Zestimate_DGCN, Error_DGCN(CNT,:)] ...
            = F_calc_error(m, Xorg, U, H_DGCN,iR,Q);

        %% D-optimality - Bayes Greedy --------------------------------
        [time_BDG(CNT,w+1), H, sensors] = F_sensor_BDG(U...
            (rms_large,1:end),Un(rms_large,1:end),Sn,p,Q);
%             (rms_large,1:end),Un(rms_large,1:30),Sn(1:30,1:30),p,Q);
        sensors_BDG = rms_large(sensors);
        H_BDG = zeros(p,n); H_BDG(:,rms_large) = H;
        det_BDG (CNT,w+1) = F_calc_det  (p,H_BDG,U);
        iR =  F_calc_Rinv_scalar(Un,Sn,sensors_BDG);
        [Zestimate_BDG, Error_BDG(CNT,:)] ...
            = F_calc_error(m, Xorg, U, H_BDG,iR,Q);
        
        %% Sensor location ==========================================
        sensor_memo = [];
        sensor_memo = [sensor_memo sensors_rand(1:p)'];
        sensor_memo = [sensor_memo sensors_DG(1:p)];
        sensor_memo = [sensor_memo sensors_DGCN(1:p)];
        sensor_memo = [sensor_memo sensors_BDG(1:p)];
        
        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');
        
        %% Video ====================================================
        %             name='rand';
        %             F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
        %                 sensors_rand, Zestimate_rand, name, videodir, sensordir)
        %             name='DC';
        %             F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
        %                 sensors_DC, Zestimate_DC, name, videodir, sensordir)
        %             name='QR';
        %             F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
        %                 sensors_QR, Zestimate_QR, name, videodir, sensordir)
        %             name='DG';
        %             F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
        %                 sensors_DG, Zestimate_DG, name, videodir, sensordir)
        %             name='QD';
        %
        %             text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        %             disp(text);
    end
        
    %% Data organization ================================================
    % Arrange
    [time_all] = F_data_arrange( ps,   CNT, [time_rand, time_DG, time_DGCN,...
        time_BDG]);
    [det_all]  = F_data_arrange( ps,   CNT, [det_rand,  det_DG,  det_DGCN, ...
        det_BDG]);
    
    [Error] = F_data_arrange( ps, CNT, ...
        [Error_rand_ls(:,1), Error_DG, Error_DGCN, Error_BDG, repmat(Error_ave_pod,size(Error_DG))] );
    
    
    %% Save =============================================================
    cd(workdir)
    save('time.mat','time_all');
    save('det.mat','det_all');
    save('error.mat','Error');
    save('time_rand.mat','time_rand');
    save('det_rand.mat','det_rand');
    cd ../src
end
warning('on','all')
disp('Congratulations!');
cd ../src
%% ///////////////////////////////////////////////////////////////////
%% Main program end