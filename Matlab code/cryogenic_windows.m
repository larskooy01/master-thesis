clc;close all;clear
%% Parameters for radiation
% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];   
col.black = [0,0,0];

% ambient temperature
T0 = 300;
% shield temperatures 
T1 = 250;
T2 = 80;
T3 = 40;
T4 = 15;
Ts = [T1,T2,T3,T4];

% area of one side of a shield (width x height) 
A1 = 1.44*1.22; 
A2 = 1.22*1.10;
A3 = 1.10*1.00;
A4 = 0.94*0.84;
As = [A1,A2,A3,A4];

% aperture radius 
R = 0.05;
A = pi*R^2;

% test mass dimensions
Rtm = 0.075;                    % radius
Dtm = 0.08;                     % thickness
Atm = 2*pi*(Rtm^2 + Rtm*Dtm);   % total surface area
Ttm = 15;                       % design temperature

% inner-outer wall seperation (of a double-walled shield)
D = 0.017;

% shield-to-shield seperatation
H12 = 0.036;
H23 = 0.043;
H34 = 0.015;
% distance from inner shield to the test mass
Htm = 0.25;
% distance from window to d
Htot=[H12+H23+H34+3*D; H23+H34+2*D; H34+D; 0];
Hrel=[0,H12,H23,H34];

sig = 5.67e-8;  % stefan-boltzmann constant
e   = 0.1;      % emissivity of Aluminium shields (ETpf design report)


%% Parameters for window conduction
mat = ["sapphire", "N-BK7", "fused silica"];

% transmittance(Tw,Tr) for sapphire at different window temperatures 
% Tw = [300,250,80,40,15] and radiation spectra Tr = [300,250,80,40,15]
tau_sa = [0.04 0.01 0.03 0.12 0.37
          0.04 0.02 0.05 0.18 0.41
          0.05 0.04 0.20 0.38 0.52
          0.07 0.06 0.33 0.48 0.57
          0.09 0.09 0.42 0.54 0.59];
% transmittance of the spectra considered is practically zero for glasses
tau_bk = ones(5,1)*[0.0007, 0.0001, 0, 0, 0];
tau_fs = ones(5,1)*[0.001,  0.0002, 0, 0, 0];

% reflectance (to be conservative in calculations, rho = 0 )
rho_sa = 0.0;    % sapphire
rho_bk = 0.0;    % N-BK7
rho_fs = 0.0;    % fused silica 

% emissivity (follows from tau and rho)
e_sa = 1-rho_sa-tau_sa;         % sapphire
e_bk = 1-rho_bk-tau_bk;         % N-BK7
e_fs = 1-rho_fs-tau_fs;         % fused silica 


% thermal conductivity at T = [250,80,40,15] expressed in W/m.K
k_sa  = [60; 800; 7000; 10000];     % Sapphire
k_bk  = [1.1; 0.6; 0.2;0.1];        % N-BK7
k_fs  = [2; 0.9; 0.4; 0.2];         % Fused Silica


% window properties
e_tot = {e_sa,e_bk,e_fs};
k_tot = [k_sa,k_bk,k_fs];
rho_tot=[rho_sa,rho_bk,rho_fs];

t  = 2e-3;               % [m] window thickness

%% Parameters for thermal stress

% coefficients of thermal expansion at Tw = [250,80,40,15] (ppm/K)
cte_sa = [4.5; 0.51; 0.14; 0.05];
cte_fs = [0.37; -0.7; -0.88; -0.37];
cte_bk = [6.0; 0.68; 0.19; 0.07];
cte_tot = [cte_sa,cte_bk,cte_fs]*1e-6;

% Young's moduli of sapphire, nbk7, fused silica
E_tot = [335, 82 ,73]*1e9; % [GPa]



%% Initial case R = 0.01 & no window (optical lever holes in ETpathfinder)
R = 0.01;
A = pi*R^2;

% first aperture. effectively a black body source with area A)
qa = A*sig*T0^4;    

% ambient irradiation to aperture d
H = D + H23% + H34 + 4*D;  % distance from a to d
Fad = Fcirc(H,R)           % view factor
q_am = Fad*qa               % irradiation [W]

% ambient irradiation to test mass
H = H + Htm;                % distance from a to TM
Fatm = Ftm(H,R);            % view factor
q_atm = Fatm*qa;             % irradiation [W]


% mutual radiation from s3 to d (accounting for reflectivities) 
q3 = e*A3*sig*T3^4; 
F3d = Fshield(A3,H34,R);
q_mut = qrad(T3,T4,A3,A,e,1,F3d)

% total irradiation on d
q_tot = q_am + q_mut

%% Case 1: R = 0.05 & one window in a shield %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 0.05;
A = pi*R^2;
qa = A*sig*T0^4;    

% choose window material & shield number
m     = 1;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n     = 2;   % [1, 2, 3, 4] = [250, 80, 40, 15]
t  = 2e-3; 

% material properties
cte_w = cte_tot(n,m);
E_w   = E_tot(m);

T_w = Ts(n);
T_w = 48;
H   = Htot(n);
% mutual radiation from previous shield onto the window
if n>1
    Fmut = Fshield(As(n-1),Hrel(n),R);
    %qs = Fmut*e*As(n)*sig*Ts(n-1)^4;
    qs = qrad(Ts(n-1),T_w,As(n-1),A,e,1,Fmut)
else
    qs = 0
end

% window properties
k_w = k_tot(n,m);       % thermal conductivity k(temperature, material)
k_w = 10000;
e_w = e_tot{m};         % emissivity for material
e_w = e_w(n+1,:);       % at current window temperature
   
% ambient heat onto window 
Hw  = Htot(1)-H;             % distance from a to this window
Faw = Fcirc(Hw,R);           % view factor 
qaw = Faw*qa                 % irradiation [W]
%%
% heat that is absorbed by window (ambient and mutual)
qw = e_w(1)*qaw + e_w(n)*qs;  
tau_w = 1-e_w(1);               % 300K radiation transmittance for this Tw
Had= Htot(1);                   % distance from a to d
q_t  = Fcirc(Had,R)*tau_w*qa ;   % ambient transmitted that reaches d
q_t = 0;

% resulting temperature profile
T_R = tprof(qw, T_w, e_w(n+1), k_w, t, R);
r = linspace(0, R, 500);

figure;
plot(r*1000,T_R,'r', LineWidth=1.2); 
xlabel('radius [mm]'); ylabel('window temperature [K]', fontsize=10)
legend(mat(m)+' window')
legend('boxoff')

% Calculate stresses due to temperature gradient
[sigma_r,sigma_t] = stresses(T_R,r,cte_w,E_w);

figure;
plot(r*1e3, sigma_r*1e-6, 'k-', Linewidth=1.5);
hold on
plot(r*1e3, sigma_t*1e-6, 'k--', LineWidth=1.5)

xlabel('Radius r [mm]');
ylabel('Stress [Mpa]');
legend('radial stress \sigma_r', 'tangential stress \sigma_\theta',...
    Location='southwest', fontsize=10);
legend('boxoff')


% resulting radiation from window heating up
qw_out = 2*pi*e_w(n+1)*sig*trapz(r, T_R.^4 .* r);
qw_out = A*sig*T_w^4;

% irradiation from window to aperture d
Fad = Fcirc(H,R);                % view factor
q_win = Fad*qw_out               % irradiation [W]

% irradiation from window to test mass
Fatm = Ftm(H+0.25,R);           % view factor
q_atm = Fatm*qw_out;            % irradiation [W]

% mutual radiation from s3 to d (accounting for reflectivities)
if n<4
    F3d = Fshield(A3,H34,R);
    q_mut = qrad(T3,T4,A3,A,e,1,F3d)
else
    q_mut = 0
end


% mutual radiation from s2 to d (through aperture c)
if n<3
    F3d = Fshield(A3,H34,R);
    q_mut2 = qrad(T3,T4,A3,A,e,1,F3d)
else
    q_mut2 = 0
end

% total irradiation on d
q_tot = q_win + q_mut + q_t

%% Case 2: R = 0.05 & more windows in seperate shields %%%%%%%%%%%%%%%%%%%%
R = 0.05;
A = pi*R^2;
qa = A*sig*T0^4; 
t  = 3e-3; 

% choose first window material & shield number
m1     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n1     = 2;   % [1, 2, 3, 4] = [250, 80, 40, 15]

% choose second window material & shield number
m2     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n2     = 3;   % [1, 2, 3, 4] = [250, 80, 40, 15]

m3     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n3     = 4;   % [1, 2, 3, 4] = [250, 80, 40, 15]

T_w1 = Ts(n1);
T_w2 = Ts(n2);

H1   = Htot(n1);          % window 1 to d
H2   = Htot(n2);          % window 2 to d
Hww  = H1-H2;             % window 1 to window 2 

% window properties
k_w1 = k_tot(n1,m1);      % thermal conductivity k(temperature, material)
e_w1 = e_tot{m1};         % emissivity for material
e_w1 = e_w1(n1+1,:);      % at current window temperature

cte_w1 = cte_tot(n1,m1);  % CTE
E_w1   = E_tot(m1);       % Young's modulus

% window properties
k_w2 = k_tot(n2,m2);      % thermal conductivity k(temperature, material)
e_w2 = e_tot{m2};         % emissivity for material
e_w2 = e_w2(n2+1,:);      % at current window temperature

cte_w2 = cte_tot(n2,m2);  % CTE
E_w2   = E_tot(m2);       % Young's modulus

% first window

% mutual irradiation from previous shield onto window 1
if n1>1
    Fmut = Fshield(As(n1-1),Hrel(n1),R);
    qs = qrad(Ts(n1-1),T_w1,As(n1-1),A,e,1,Fmut);
else
    qs=0;
end

% ambient irradiation onto window 1
Hw  = Htot(1)-H1;            % distance from a to this window
Faw = Fcirc(Hw,R);           % view factor 
qaw = Faw*qa;                % irradiation [W]

% heat that is absorbed by window 1 (ambient and mutual from shield)
qw1 = e_w1(1)*qaw + e_w1(n1)*qs;    
qat  = Fcirc(H2,R)*(1-e_w1(1))*qa;   % ambient transmitted that reaches window 2

% resulting temperature profile 
T_R = tprof(qw1, T_w1, e_w1(n1+1), k_w1, t, R);
r = linspace(0, R, 500);

% temperature profile with contact resistance
hc = 100;
T_R2 = tprof2(qw1, T_w1, e_w1(n1+1), k_w1, t, R,hc);
T_R=T_R2;
%
%
figure(1);
subplot(2,1,1)
plot(r*1e3,T_R,'color', col.red, LineWidth=1.7)
hold on
%plot(r*1e3,T_R2,'r--', LineWidth=1.2)
ylabel('Temperature [K]')
title('first window', fontsize=10.5)
legend(mat(m1), fontsize=9.5,Location='southwest')
%legend('hc = \infty', 'hc = 100')
legend('boxoff')
%

%T_R=T_R2;

% resulting stresses
[sigma_r,sigma_t] = stresses(T_R,r,cte_w1,E_w1);
[sigma_r2,sigma_t2] = stresses(T_R2,r,cte_w1,E_w1);

%C = 3.5e-12;
%dn = C*(sigma_r-sigma_t)*t;
%figure(4);
%plot(r*1e3,dn)

figure(2);
plot(r*1e3, sigma_r*1e-6, '-', 'color', col.black, Linewidth=1.7);
hold on
plot(r*1e3, sigma_t*1e-6, '--', 'color', col.black, LineWidth=1.7)
xlabel('Window radius [mm]'); ylabel('Stress [Mpa]');
legend('radial stress \sigma_r', 'tangential stress \sigma_\theta',...
    Location='southwest', fontsize=9.5); legend('boxoff')
title('thermal stress in the first window', fontsize=10.5)


% resulting radiation from window 1 heating up [W]
qw_out1 = 2*pi*e_w1(n1+1)*sig*trapz(r, T_R.^4 .* r);
T_eff1 = ( qw_out1/(A*e_w1(n1+1)*sig) )^(1/4); % effective temperature
%
% second window

if n1==n2   % when in same shield take distance from inner to outer wall
    Hs2 = D;
else
    Hs2 = Hrel(n2);
end
% mutual irradiation from previous shield onto the window
Fmut = Fshield(As(n2-1),Hs2,R);
qs = qrad(Ts(n2-1),T_w2,As(n2-1),A,e,1,Fmut);

% mutual irradiation from window 1 onto the window 2
Fww = Fcirc(Hww,R);
qww = Fww*qw_out1;
qww_test = qrad(T_eff1,T_w2,A,A,e_w1(n1+1),1,Fww);
qww=qww;
% ^ when two windows are placed in the same shield one must use the
% qww_test variable instead. This one takes into account T1^4-T2^4 and in
% the case of same shield windows this value is significantly different
% from T1^4. Otherwise, using qww is fine

% heat that is absorbed by window 2 (from ambient, shield, and window 1)
qw2 = e_w2(1)*qat + e_w2(n2)*qs + e_w2(n1+1)*qww ;
Had = Htot(1); 
qat2 = Fcirc(Had,R)*(1-e_w2(1))*qa;       % transmitted ambient (300K) to d
qwt = Fcirc(H1,R)*(1-e_w2(n1+1))*qw_out1; % transmitted window1 (T=T1) to d
%
% resulting temperature profile 
T_R = tprof(qw2, T_w2, e_w2(n2+1), k_w2, t, R);
r = linspace(0, R, 500);

T_R2 = tprof2(qw2, T_w2, e_w2(n2+1), k_w2, t, R,hc);
T_R=T_R2;


figure(1);
subplot(2,1,2)
plot(r*1e3,T_R, 'color', col.blue, LineWidth=1.7)
hold on
%plot(r*1e3,T_R2, 'b--', LineWidth=1.2 )
title('second window', fontsize=10.5)
legend(mat(m2), fontsize=9.5,Location='southwest')
%legend('hc = \infty', 'hc = 100')
legend('boxoff')
xlabel('Window radius [mm]'); ylabel('Temperature [K]')


T_R=T_R2;

% resulting stresses
[sigma_r,sigma_t] = stresses(T_R,r,cte_w2,E_w2);

figure(3);
plot(r*1e3, sigma_r*1e-6, '-', 'color', col.black, Linewidth=1.7);
hold on
plot(r*1e3, sigma_t*1e-6, '--', 'color', col.black, LineWidth=1.7)
%yline(0)
xlabel('Window radius [mm]'); ylabel('Stress [Mpa]');
legend('radial stress \sigma_r', 'tangential stress \sigma_\theta',...
    Location='southwest', fontsize=10); legend('boxoff')
title('stresses in the second window', fontsize=10.5)
xlim([0,50])

% resulting radiation from window 2 to d
qw_out2 = 2*pi*e_w2(n2+1)*sig*trapz(r, T_R.^4 .* r);
qw = Fcirc(H2,R) * qw_out2;

if n2 == 4
    q_mut = 0 ; % if window is in the last shield, no mutual radiation
else
    % mutual radiation from s3 to d 
    F3d = Fshield(A3,H34,R);
    q_mut = qrad(T3,T4,A3,A,e,1,F3d);
end 

q_tot = qat2 + qwt + qw + q_mut;

% Adding a third window 
% choose third window material & shield location


% window temperature
T_w3 = Ts(n3);

% distances
H3   = Htot(n3);          % window 3 to d
Hww  = H2-H3;             % window 2 to window 3

% window properties
k_w3 = k_tot(n3,m3);      % thermal conductivity k(temperature, material)
e_w3 = e_tot{m3};         % emissivity for material
e_w3 = e_w3(n3+1,:);      % at current window temperature

cte_w3 = cte_tot(n3,m3);  % CTE
E_w3   = E_tot(m3);       % Young's modulus

if n2==n3   % when in same shield take distance from inner to outer wall
    Hs3 = D;
else
    Hs3 = Hrel(n3);
end

% mutual irradiation from previous shield onto the window
Fmut = Fshield(As(n3-1),Hs3,R);
qs = qrad(Ts(n3-1),T_w3,As(n3-1),A,e,1,Fmut);

% mutual irradiation from window 2 onto the window 3
Fww = Fcirc(Hww,R);
qww = Fww*qw_out2;

% all incident radiation onto window 3
qw3 = e_w3(1)*qat + e_w3(n3)*qs + e_w3(n2+1)*qww;

qat3 = Fcirc(Had,R)*(1-e_w3(1))*qa;       % transmitted ambient (300K) to d
qwt = Fcirc(H1,R)*(1-e_w3(n2+1))*qw_out1; % transmitted window1 (T=T1) to d

% resulting temperature profile 
T_R = tprof2(qw3, T_w3, e_w3(n3+1), k_w3, t, R, hc);
r = linspace(0, R, 500);

figure();
plot(r*1e3,T_R, 'color', col.black, LineWidth=1.7)
hold on
title('third window', fontsize=10.5)
legend(mat(m3), fontsize=9.5,Location='southwest')
legend('boxoff')
xlabel('Window radius [mm]'); ylabel('Temperature [K]')

[sigma_r,sigma_t] = stresses(T_R,r,cte_w3,E_w3);

figure();
plot(r*1e3, sigma_r*1e-6, '-', 'color', col.black, Linewidth=1.7);
hold on
plot(r*1e3, sigma_t*1e-6, '--', 'color', col.black, LineWidth=1.7)
xlabel('Window radius [mm]'); ylabel('Stress [Mpa]');
legend('radial stress \sigma_r', 'tangential stress \sigma_\theta',...
    Location='southwest', fontsize=10); legend('boxoff')
title('stresses in the third window', fontsize=10.5)
xlim([0,50])

% resulting radiation from window 3 to d 
qw_out3 = 2*pi*e_w3(n3+1)*sig*trapz(r, T_R.^4 .* r);
qw = Fcirc(H3,R) * qw_out3;

if n3 == 4
    q_mut = 0; % if window is in the last shield, no mutual radiation
else
    % mutual radiation from s3 to d 
    F3d = Fshield(A3,H34,R);
    q_mut = qrad(T3,T4,A3,A,e,1,F3d);
end 

% total = amb. transmitted + win. transmitted + from window + from shield
q_tot = qat3 + qwt + qw + q_mut


%% FOR LOOP PLOTS (for comparing sapphire / fused silica vs. h_tc)
% conclusion... realistically <1mW is not possible with 2 windows...
t_list = [3,4,5];
t_list = t_list*1e-3; % free variable

q_tot_list = zeros(1,length(t_list));

% choose first window material & shield number
m1     = 3;  % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n1     = 2;   % [1, 2, 3, 4] = [250, 80, 40, 15]

% choose second window material & shield number
m2     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n2     = 3;   % [1, 2, 3, 4] = [250, 80, 40, 15]

T_w1 = Ts(n1);
T_w2 = Ts(n2);

H1   = Htot(n1);          % window 1 to d
H2   = Htot(n2);          % window 2 to d
Hww  = H1-H2;             % window 1 to window 2 

% window properties
k_w1 = k_tot(n1,m1);      % thermal conductivity k(temperature, material)
e_w1 = e_tot{m1};         % emissivity for material
e_w1 = e_w1(n1+1,:);      % at current window temperature

cte_w1 = cte_tot(n1,m1);  % CTE
E_w1   = E_tot(m1);       % Young's modulus

% window properties
k_w2 = k_tot(n2,m2);      % thermal conductivity k(temperature, material)
e_w2 = e_tot{m2};         % emissivity for material
e_w2 = e_w2(n2+1,:);      % at current window temperature

cte_w2 = cte_tot(n2,m2);  % CTE
E_w2   = E_tot(m2);       % Young's modulus

hcs = 40:5:500;
hcst = num2str(hcs');
i=1;
for t=t_list
for hc= hcs

    t=3e-3;

    % mutual irradiation from previous shield onto window 1
    if n1>1
        Fmut = Fshield(As(n1-1),Hrel(n1),R);
        qs = qrad(Ts(n1-1),T_w1,As(n1-1),A,e,1,Fmut);
    else
        qs=0;
    end
    
    % ambient irradiation onto window 1
    Hw  = Htot(1)-H1;            % distance from a to this window
    Faw = Fcirc(Hw,R);           % view factor 
    qaw = Faw*qa;                % irradiation [W]
    
    % heat that is absorbed by window 1 (ambient and mutual from shield)
    qw1 = e_w1(1)*qaw + e_w1(n1)*qs;    
    qat  = Fcirc(H2,R)*(1-e_w1(1))*qa;   % ambient transmitted that reaches window 2
    
    % resulting temperature profile 
    T_R = tprof(qw1, T_w1, e_w1(n1+1), k_w1, t, R);
    r = linspace(0, R, 500);
    
    % temperature profile with contact resistance
    T_R2 = tprof2(qw1, T_w1, e_w1(n1+1), k_w1, t, R,hc);

    T_R=T_R2;
      
    % resulting stresses
    [sigma_r,sigma_t] = stresses(T_R,r,cte_w1,E_w1);
    [sigma_r2,sigma_t2] = stresses(T_R2,r,cte_w1,E_w1);
    
    %C = 3.5e-12;
    %dn = C*(sigma_r-sigma_t)*t;
       
    % resulting radiation from window 1 heating up
    qw_out1 = 2*pi*e_w1(n1+1)*sig*trapz(r, T_R.^4 .* r);
    T_eff1 = ( qw_out1/(A*e_w1(n1+1)*sig) )^(1/4); % effective temperature
    
    % second window
    
    if n1==n2   % when in same shield take distance from inner to outer wall
        Hs2 = D;
    else
        Hs2 = Hrel(n2);
    end

    % mutual irradiation from previous shield onto the window
    Fmut = Fshield(As(n2-1),Hs2,R);
    qs = qrad(Ts(n2-1),T_w2,As(n2-1),A,e,1,Fmut);
    
    % mutual irradiation from window 1 onto the window 2
    Fww = Fcirc(Hww,R);
    qww = Fww*qw_out1;
    qww_test = qrad(T_eff1,T_w2,A,A,e_w1(n1+1),1,Fww);
    qww=qww;
    % ^ when two windows are placed in the same shield one must use the
    % qww_test variable instead. This one takes into account T1^4-T2^4 and in
    % the case of same shield windows this value is significantly different
    % from T1^4. Otherwise, using qww is fine
    
    % heat that is absorbed by window 2 (from ambient, shield, and window 1)
    qw2 = e_w2(1)*qat + e_w2(n2)*qs + e_w2(n1+1)*qww;
    Had = Htot(1); 
    qat2 = Fcirc(Had,R)*(1-e_w2(1))*qa;       % transmitted ambient (300K) to d
    qwt = Fcirc(H1,R)*(1-e_w2(n1+1))*qw_out1; % transmitted window1 (T=T1) to d
    
    % resulting temperature profile 
    T_R = tprof(qw2, T_w2, e_w2(n2+1), k_w2, t, R);
    r = linspace(0, R, 500);
    
    T_R2 = tprof2(qw2, T_w2, e_w2(n2+1), k_w2, t, R,hc);
    
        T_R=T_R2;
    
    % resulting stresses
    [sigma_r,sigma_t] = stresses(T_R,r,cte_w2,E_w2);
    
    
    % resulting radiation from window 2 to d
    qw_out2 = 2*pi*e_w2(n2+1)*sig*trapz(r, T_R.^4 .* r);
    qw = Fcirc(H2,R) * qw_out2;
    
    % mutual radiation from s3 to d (accounting for reflectivities)
    F3d = Fshield(A3,H34,R);
    q_mut = qrad(T3,T4,A3,A,e,1,F3d);
    q_tot = qat2 + qwt + qw + q_mut;

    q_tot_list(i) = q_tot; 
    i=i+1;

%figure(6)
%plot(TR,r)

end
figure(7);
plot(hcs,q_tot_list*1000)

end

%ylim([1 6])
xlabel('Thermal contact conductance'); ylabel('heat load Q_d [mW]')
% change radius to 'effective contact area' and reason that results are
% representable under the condition that is T(r) is close to radially
% symmetric (nest of springs / long leaf springs / design tbd)

%legend("mat1 h_{tc} = " + hcst(1,:), ...
%       "mat1 h_{tc} = " + hcst(2,:), ...
%       "mat1 h_{tc} = " + hcst(3,:), ...
%       "mat2 h_{tc} = " + hcst(1,:), ...
%       "mat2 h_{tc} = " + hcst(2,:), ...
%       "mat2 h_{tc} = " + hcst(3,:));

%% NEW FOR LOOP
t_list = [3,4,5];
t_list = t_list*1e-3; % free variable

q_tot_list = zeros(1,length(t_list));

% choose first window material & shield number
m1     = 3;  % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n1     = 2;   % [1, 2, 3, 4] = [250, 80, 40, 15]

% choose second window material & shield number
m2     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n2     = 3;   % [1, 2, 3, 4] = [250, 80, 40, 15]

T_w1 = Ts(n1);
T_w2 = Ts(n2);

H1   = Htot(n1);          % window 1 to d
H2   = Htot(n2);          % window 2 to d
Hww  = H1-H2;             % window 1 to window 2 

% window properties
k_w1 = k_tot(n1,m1);      % thermal conductivity k(temperature, material)
e_w1 = e_tot{m1};         % emissivity for material
e_w1 = e_w1(n1+1,:);      % at current window temperature

cte_w1 = cte_tot(n1,m1);  % CTE
E_w1   = E_tot(m1);       % Young's modulus

% window properties
k_w2 = k_tot(n2,m2);      % thermal conductivity k(temperature, material)
e_w2 = e_tot{m2};         % emissivity for material
e_w2 = e_w2(n2+1,:);      % at current window temperature

cte_w2 = cte_tot(n2,m2);  % CTE
E_w2   = E_tot(m2);       % Young's modulus

hcs = 10:1:500;
hcst = num2str(hcs');
i=1;
q_tot_mat =zeros(length(t_list),length(hcs));

for it = 1:length(t_list)

    t = t_list(it);   % convert once here

    for ih = 1:length(hcs)

        hc = hcs(ih);

        % mutual irradiation from previous shield onto window 1
    if n1>1
        Fmut = Fshield(As(n1-1),Hrel(n1),R);
        qs = qrad(Ts(n1-1),T_w1,As(n1-1),A,e,1,Fmut);
    else
        qs=0;
    end
    
    % ambient irradiation onto window 1
    Hw  = Htot(1)-H1;            % distance from a to this window
    Faw = Fcirc(Hw,R);           % view factor 
    qaw = Faw*qa;                % irradiation [W]
    
    % heat that is absorbed by window 1 (ambient and mutual from shield)
    qw1 = e_w1(1)*qaw + e_w1(n1)*qs;    
    qat  = Fcirc(H2,R)*(1-e_w1(1))*qa;   % ambient transmitted that reaches window 2
    
    % resulting temperature profile 
    T_R = tprof(qw1, T_w1, e_w1(n1+1), k_w1, t, R);
    r = linspace(0, R, 500);
    
    % temperature profile with contact resistance
    T_R2 = tprof2(qw1, T_w1, e_w1(n1+1), k_w1, t, R,hc);

    T_R=T_R2;
      
    % resulting stresses
    [sigma_r,sigma_t] = stresses(T_R,r,cte_w1,E_w1);
    [sigma_r2,sigma_t2] = stresses(T_R2,r,cte_w1,E_w1);
    
    %C = 3.5e-12;
    %dn = C*(sigma_r-sigma_t)*t;
       
    % resulting radiation from window 1 heating up
    qw_out1 = 2*pi*e_w1(n1+1)*sig*trapz(r, T_R.^4 .* r);
    T_eff1 = ( qw_out1/(A*e_w1(n1+1)*sig) )^(1/4); % effective temperature
    
    % second window
    
    if n1==n2   % when in same shield take distance from inner to outer wall
        Hs2 = D;
    else
        Hs2 = Hrel(n2);
    end

    % mutual irradiation from previous shield onto the window
    Fmut = Fshield(As(n2-1),Hs2,R);
    qs = qrad(Ts(n2-1),T_w2,As(n2-1),A,e,1,Fmut);
    
    % mutual irradiation from window 1 onto the window 2
    Fww = Fcirc(Hww,R);
    qww = Fww*qw_out1;
    qww_test = qrad(T_eff1,T_w2,A,A,e_w1(n1+1),1,Fww);
    qww=qww;
    % ^ when two windows are placed in the same shield one must use the
    % qww_test variable instead. This one takes into account T1^4-T2^4 and in
    % the case of same shield windows this value is significantly different
    % from T1^4. Otherwise, using qww is fine
    
    % heat that is absorbed by window 2 (from ambient, shield, and window 1)
    qw2 = e_w2(1)*qat + e_w2(n2)*qs + e_w2(n1+1)*qww;

    qw2_mat(it, ih) = qw2;

    Had = Htot(1); 
    qat2 = Fcirc(Had,R)*(1-e_w2(1))*qa;       % transmitted ambient (300K) to d
    qwt = Fcirc(H1,R)*(1-e_w2(n1+1))*qw_out1; % transmitted window1 (T=T1) to d
    
    % resulting temperature profile 
    T_R = tprof(qw2, T_w2, e_w2(n2+1), k_w2, t, R);
    r = linspace(0, R, 500);
    
    T_R2 = tprof2(qw2, T_w2, e_w2(n2+1), k_w2, t, R,hc);
    
        T_R=T_R2;
    
    % resulting stresses
    [sigma_r,sigma_t] = stresses(T_R,r,cte_w2,E_w2);
    
    
    % resulting radiation from window 2 to d
    qw_out2 = 2*pi*e_w2(n2+1)*sig*trapz(r, T_R.^4 .* r);
    qw = Fcirc(H2,R) * qw_out2;
    
    % mutual radiation from s3 to d (accounting for reflectivities)
    F3d = Fshield(A3,H34,R);
    q_mut = qrad(T3,T4,A3,A,e,1,F3d);
    q_tot = qat2 + qwt + qw + q_mut;

    q_tot_mat(it, ih) = q_tot;

    end
end
%%

col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];  
col.black = [0,0,0];

%% varying htc for q_tot
figure; 

plot(hcs, q_tot_mat(1,:)*1000, 'Color', col.black, Linewidth=1.7);
hold on;
plot(hcs, q_tot_mat(2,:)*1000, 'Color', col.gray2, Linewidth=1.7);
plot(hcs, q_tot_mat(3,:)*1000, 'Color', col.gray3, Linewidth=1.7);
plot([0,500],[1.3,1.3], 'Color', col.blue, Linewidth=1.7)

ylim([1.2,1.6])
xlim([0,300])

xlabel('Thermal contact conductance [W/m^2K]');
ylabel('Heat load [mW]');
legend('t = 3 mm','t = 4 mm','t = 5 mm','max. allowed heat load Q_d', fontsize=10)
legend boxoff

%% varying htc for q_w2 (heat load on window 2)
figure; 

plot(hcs, qw2_mat(1,:)*1000, 'Color', col.black, Linewidth=1.7);
hold on;
plot(hcs, qw2_mat(2,:)*1000, 'Color', col.gray2, Linewidth=1.7);
plot(hcs, qw2_mat(3,:)*1000, 'Color', col.gray3, Linewidth=1.7);
plot([0,500],[25,25], 'Color', col.red, Linewidth=1.7)


%ylim([1.1,1.8])
xlim([40,240])

xlabel('Thermal contact conductance [W/m^2K]');
ylabel('Heat load [mW]');
legend('t = 3 mm','t = 4 mm','t = 5 mm', fontsize=10)
legend boxoff

%%
y_ref = 25;

figure; hold on;

% curves
plot(hcs, qw2_mat(1,:)*1000, 'Color', col.black, 'LineWidth', 1.7);
plot(hcs, qw2_mat(2,:)*1000, 'Color', col.gray2, 'LineWidth', 1.7);
plot(hcs, qw2_mat(3,:)*1000, 'Color', col.gray3, 'LineWidth', 1.7);

% red line
yline(y_ref, 'Color', col.red, 'LineWidth', 1.7);

% make sure limits are known BEFORE fill
xlim([40 240])

yl = ylim;   % get current y-limits after plotting

% fill region above y_ref
fill([min(hcs) max(hcs) max(hcs) min(hcs)], ...
     [y_ref y_ref yl(2) yl(2)], ...
     col.red, ...
     'FaceAlpha', 0.12, ...
     'EdgeColor', 'none');

% bring lines back on top (important)
uistack(gca,'top');
xlim([40,200])

xlabel('Thermal contact conductance [W/m^2K]');
ylabel('Heat load [mW]');
legend('t = 3 mm','t = 4 mm','t = 5 mm','max. allowed radation on second window' , fontsize=10)
legend boxoff
%%
hcs = 10:5:500;
q_tot_list = zeros(size(hcs));

for i = 1:length(hcs)

    hc = hcs(i);

    % --- temperature (ONLY ONE VERSION) ---
    T_R = tprof2(qw1, T_w1, e_w1(n1+1), k_w1, t, R, hc);

    r = linspace(0, R, 500);

    % --- radiation ---
    qw_out1 = 2*pi*e_w1(n1+1)*sig*trapz(r, T_R.^4 .* r);

    % --- rest of model unchanged ---
    ...

    q_tot_list(i) = q_tot;

end

figure;
plot(hcs, q_tot_list*1000);
xlabel('Thermal contact conductance hc');
ylabel('Heat load Q_d [mW]');

%% FOR LOOP for 3-window configurations.

R = 0.05;
A = pi*R^2;
qa = A*sig*T0^4; 
t  = 3e-3; 

% choose first window material & shield number
m1     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n1     = 1;   % [1, 2, 3, 4] = [250, 80, 40, 15]

% choose second window material & shield number
m2     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n2     = 2;   % [1, 2, 3, 4] = [250, 80, 40, 15]

m3     = 3;   % [1, 2, 3]    = [sapphire, N-BK7, fused silcia]
n3     = 4;   % [1, 2, 3, 4] = [250, 80, 40, 15]

T_w1 = Ts(n1);
T_w2 = Ts(n2);

H1   = Htot(n1);          % window 1 to d
H2   = Htot(n2);          % window 2 to d
Hww  = H1-H2;             % window 1 to window 2 

% window properties
k_w1 = k_tot(n1,m1);      % thermal conductivity k(temperature, material)
e_w1 = e_tot{m1};         % emissivity for material
e_w1 = e_w1(n1+1,:);      % at current window temperature

cte_w1 = cte_tot(n1,m1);  % CTE
E_w1   = E_tot(m1);       % Young's modulus

% window properties
k_w2 = k_tot(n2,m2);      % thermal conductivity k(temperature, material)
e_w2 = e_tot{m2};         % emissivity for material
e_w2 = e_w2(n2+1,:);      % at current window temperature

cte_w2 = cte_tot(n2,m2);  % CTE
E_w2   = E_tot(m2);       % Young's modulus

% third window
% window temperature
T_w3 = Ts(n3);

% distances
H3   = Htot(n3);          % window 3 to d
Hww  = H2-H3;             % window 2 to window 3

% window properties
k_w3 = k_tot(n3,m3);      % thermal conductivity k(temperature, material)
e_w3 = e_tot{m3};         % emissivity for material
e_w3 = e_w3(n3+1,:);      % at current window temperature

cte_w3 = cte_tot(n3,m3);  % CTE
E_w3   = E_tot(m3);       % Young's modulus

t_list = [3,4,5]*1e-3;
hcs = 5:0.1:300;
hcst = num2str(hcs');
i=1;

q_tot_mat =zeros(length(t_list),length(hcs));

for it = 1:length(t_list)

    t = t_list(it);   % convert once here

    for ih = 1:length(hcs)

        hc = hcs(ih);

% mutual irradiation from previous shield onto window 1
if n1>1
    Fmut = Fshield(As(n1-1),Hrel(n1),R);
    qs = qrad(Ts(n1-1),T_w1,As(n1-1),A,e,1,Fmut);
else
    qs=0;
end

% ambient irradiation onto window 1
Hw  = Htot(1)-H1;            % distance from a to this window
Faw = Fcirc(Hw,R);           % view factor 
qaw = Faw*qa;                % irradiation [W]

% heat that is absorbed by window 1 (ambient and mutual from shield)
qw1 = e_w1(1)*qaw + e_w1(n1)*qs;    
qat  = Fcirc(H2,R)*(1-e_w1(1))*qa;   % ambient transmitted that reaches window 2

% resulting temperature profile 
T_R = tprof(qw1, T_w1, e_w1(n1+1), k_w1, t, R);
r = linspace(0, R, 500);

% temperature profile with contact resistance
%hc = 100;
T_R2 = tprof2(qw1, T_w1, e_w1(n1+1), k_w1, t, R,hc);
T_R=T_R2;


% resulting radiation from window 1 heating up [W]
qw_out1 = 2*pi*e_w1(n1+1)*sig*trapz(r, T_R.^4 .* r);
T_eff1 = ( qw_out1/(A*e_w1(n1+1)*sig) )^(1/4); % effective temperature
%
% second window

if n1==n2   % when in same shield take distance from inner to outer wall
    Hs2 = D;
else
    Hs2 = Hrel(n2);
end

% mutual irradiation from previous shield onto the window
Fmut = Fshield(As(n2-1),Hs2,R);
qs = qrad(Ts(n2-1),T_w2,As(n2-1),A,e,1,Fmut);

% mutual irradiation from window 1 onto the window 2
Fww = Fcirc(Hww,R);
qww = Fww*qw_out1;

% heat that is absorbed by window 2 (from ambient, shield, and window 1)
qw2 = e_w2(1)*qat + e_w2(n2)*qs + e_w2(n1+1)*qww ;
Had = Htot(1); 
qat2 = Fcirc(Had,R)*(1-e_w2(1))*qa;       % transmitted ambient (300K) to d
qwt = Fcirc(H1,R)*(1-e_w2(n1+1))*qw_out1; % transmitted window1 (T=T1) to d

% resulting temperature profile 
T_R = tprof(qw2, T_w2, e_w2(n2+1), k_w2, t, R);
r = linspace(0, R, 500);

T_R2 = tprof2(qw2, T_w2, e_w2(n2+1), k_w2, t, R,hc);
T_R=T_R2;




T_R=T_R2;


% resulting radiation from window 2 to d
qw_out2 = 2*pi*e_w2(n2+1)*sig*trapz(r, T_R.^4 .* r);
qw = Fcirc(H2,R) * qw_out2;

if n2 == 4
    q_mut = 0 ; % if window is in the last shield, no mutual radiation
else
    % mutual radiation from s3 to d 
    F3d = Fshield(A3,H34,R);
    q_mut = qrad(T3,T4,A3,A,e,1,F3d);
end 

q_tot = qat2 + qwt + qw + q_mut;

% Adding a third window 
% choose third window material & shield location


if n2==n3   % when in same shield take distance from inner to outer wall
    Hs3 = D;
else
    Hs3 = Hrel(n3);
end

% mutual irradiation from previous shield onto the window
Fmut = Fshield(As(n3-1),Hs3,R);
qs = qrad(Ts(n3-1),T_w3,As(n3-1),A,e,1,Fmut);

% mutual irradiation from window 2 onto the window 3
Fww = Fcirc(Hww,R);
qww = Fww*qw_out2;

% all incident radiation onto window 3
qw3 = e_w3(1)*qat + e_w3(n3)*qs + e_w3(n2+1)*qww;

qat3 = Fcirc(Had,R)*(1-e_w3(1))*qa;       % transmitted ambient (300K) to d
qwt = Fcirc(H1,R)*(1-e_w3(n2+1))*qw_out1; % transmitted window1 (T=T1) to d

% resulting temperature profile 
T_R = tprof2(qw3, T_w3, e_w3(n3+1), k_w3, t, R, hc);
r = linspace(0, R, 500);



[sigma_r,sigma_t] = stresses(T_R,r,cte_w3,E_w3);


% resulting radiation from window 3 to d 
qw_out3 = 2*pi*e_w3(n3+1)*sig*trapz(r, T_R.^4 .* r);
qw = Fcirc(H3,R) * qw_out3;

if n3 == 4
    q_mut = 0; % if window is in the last shield, no mutual radiation
else
    % mutual radiation from s3 to d 
    F3d = Fshield(A3,H34,R);
    q_mut = qrad(T3,T4,A3,A,e,1,F3d);
end 

% total = amb. transmitted + win. transmitted + from window + from shield
q_tot = qat3 + qwt + qw + q_mut;

    q_tot_mat(it, ih) = q_tot;

    end
end

%% plotting of the 3-window config. results
figure; 
plot([0,500],[1.3,1.3], 'Color', col.blue, Linewidth=1.7)
hold on
plot(hcs, q_tot_mat(1,:)*1000, 'Color', col.black, Linewidth=1.7);
hold on;
plot(hcs, q_tot_mat(2,:)*1000, 'Color', col.gray2, Linewidth=1.7);
plot(hcs, q_tot_mat(3,:)*1000, 'Color', col.gray3, Linewidth=1.7);
plot([0,500],[1.3,1.3], 'Color', col.blue, Linewidth=1.7)

ylim([0.2,1.6])
xlim([0,80])

xlabel('Thermal contact conductance [W/m^2K]');
ylabel('Heat load [mW]');
legend('max. allowed heat load Q_d','t = 3 mm','t = 4 mm','t = 5 mm', fontsize=10)
legend boxoff


%% then run the for loop

%% Functions

%view factor between two coaxial circles with radius R, seperated by H
function F = Fcirc(H,R)
    F = 1 + H^2/(2*R^2) - H/(2*R^2)*sqrt(H^2+4*R^2);
end


%view factor between a shield of area As and circle with radius R seperated
%by a distance H
function F = Fshield(As,H,R)
    A = pi*R^2;

    Fp = 1 + H^2/(2*R^2) - H/(2*R^2) * sqrt(H^2+4*R^2);
    F = A/As*(1-Fp);
end 


%view factor between a circle with radius R and test mass, seperated by Htm
function F = Ftm(Htm,R)
    Rtm = 0.075;
    Hd = Htm - 0.25;
    
    Hp = 2*R*Htm/(Rtm + R);

    if Hp > Hd
        F = 1 + Hp^2/(2*R^2) - Hp/(2*R^2)*sqrt(Hp^2+4*R^2);
    else 
         F = 1 + Hd^2/(2*R^2) - Hd/(2*R^2)*sqrt(Hd^2+4*R^2);
    end
end


%temperature profile of a window or radius R, thickness t, emmisivity eps,
%thermal conductivity k. Subject to a radiative heat of q.
function T = tprof(q, T0, eps, k, t, R)
    sigma = 5.67e-8;
    A = pi*R^2;
    qf  = q/A;

    % Linearized radiation
    r = linspace(0, R, 500);      % radial positions

    hrad1 = 4*eps*sigma*T0^3;     % [W/(m^2*K)]
    hrad = 2*hrad1;               % radiating from both surfaces
    
    lambda = sqrt(hrad/(k*t));    % [1/m]
    
    % Constant from boundary condition
    C = (- qf/hrad) / besseli(0, lambda*R);
    
    % Temperature profile
    T = T0 + qf/hrad + C*besseli(0, lambda*r);
end


function T = tprof2(Q, T0, eps, k, t, R,hc)
    sigma  = 5.670374e-8;         % Stefan-Boltzmann constant
    A      = pi*R^2;              % window face area
    qin    = Q/A;                 % absorbed heat flux [W/m^2]
    
    hrad   = 2 * (4*eps*sigma*T0^3);   % 2 surfaces
    
    lambda = sqrt(hrad/(k*t));
    
    I0R = besseli(0, lambda*R);
    I1R = besseli(1, lambda*R);
    
    numerator   = hc * (- qin/hrad);
    denominator = k*lambda*I1R + hc*I0R;
    
    C = numerator / denominator;
    
    r = linspace(0,R,500);
    
    T = T0 + qin/hrad + C*besseli(0, lambda*r);
end 


function Qij = qrad(Ti, Tj, Ai, Aj, eps_i, eps_j, Fij)

    sig = 5.67e-8; % stefan-boltzmann constant

    denominator = ...
        (1 - eps_i) / (Ai * eps_i) + ...
        1 / (Ai * Fij) + ...
        (1 - eps_j) / (Aj * eps_j);

    Qij = sig * (Ti^4 - Tj^4) / denominator;

end

function [sigma_r, sigma_t] = stresses(T,r,alpha,E)

    r       = r(:);          % radial positions [m], column vector
    T       = T(:);          % temperature distribution T(r)
    R0      = max(r);        % outer radius
    
    % -------------------------------
    % Precompute integrals
    % -------------------------------
    
    % I = ∫_0^R0 T(r) r dr
    I = trapz(r, T .* r);
    
    % J(r) = ∫_0^r T(s) s ds   (cumulative integral)
    J = cumtrapz(r, T .* r);
    
    % -------------------------------
    % Stress calculations
    % -------------------------------
    
    sigma_r = alpha*E * ( ...
        I / R0^2 ...
        - J ./ (r.^2) ...
    );
    
    sigma_t = alpha*E * ( ...
        I / R0^2 ...
        + J ./ (r.^2) ...
        - T ...
    );
    
    % -------------------------------
    % Handle r = 0 safely
    % -------------------------------
    sigma_r(1) = alpha*E * (I / R0^2 - T(1)/2);
    sigma_t(1) = sigma_r(1);
end