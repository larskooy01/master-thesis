%% Most realistic force-to-displacement response
% Pendulum with arm length 0.4 [m] and mass 3.2 [kg] (both from testbed paper*)

% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];   
col.black = [0, 0, 0];

L = 0.4;
m = 3.29;
g = 9.81;

% eigenfrequency
w0 = sqrt(g/L)
f = logspace(-1, 5, 1000);   % 0.01 Hz to 100 Hz
w = 2*pi*f;
f0 = 1/(2*pi)*w0
% pendulum response
d = 1e-5;
S = 1 ./ (m*(w0^2 + d/m*w*1i- w.^2));
magS = abs(S);
phaseS = -angle(S)*180/pi;  % convert to degrees

% free mass response
Sf = 1 ./ (m*(- w.^2));
magSf = abs(Sf);
phaseSf = angle(S)*180/pi;  % convert to degrees

% deformation response (comsol data first eigenfrequency)
K = 1.9e-9;     % compliance
k_eff = 1/K;    % effective stiffness
zeta = 1e-4;

f1 = 26.3e3;    % first excited eigenmode (determined using COMSOL)
w1 = 2*pi*f1;

Sd = K ./ (1 - (w./w1).^2 + 2i*zeta*(w./w1));
magSd = abs(Sd);
phaseSd = angle(Sd)*180/pi;  % convert to degrees

% Combined response
C = S + Sd;
magC = abs(C);
phaseC = angle(C)*180/pi;

% Plot pendulum vs. free mass(straight line)
frac = magS./magSf;
figure;
loglog(f,abs(frac*100-100));hold on
yline(1)
xlim([0.1,100])


figure
loglog(f, magSf, '-','Color',col.red, 'LineWidth', 1.7); hold on
loglog(f, magS, '-','Color','k', 'LineWidth', 1.7); hold on
loglog(f, magSf, '-','Color',col.red, 'LineWidth', 1.7); hold on

ylabel('Magnitude [m/N]');xlabel('Frequency [Hz]');
ylim([1e-12,1e-1]); 
xlim([1e0,1e3])
%title('Pendulum Response, Deformation, and Combined');
legend('free-body','mass-spring-damper', fontsize=11);
legend("boxoff")
xlim([0.1,100]);ylim([1e-6, 10])

%% Plotting total response

col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.black = [0, 0, 0];     
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];   
col.gray4 = [0.8, 0.8, 0.8];  

figure;
tiledlayout(2,1);

% Magnitude
nexttile;

loglog(f, magSf, '--','Color',col.red, 'LineWidth', 1.7); hold on;
loglog(f, magSd, '--','Color',col.blue, 'LineWidth', 1.7);
loglog(f, magC,'Color','k', 'LineWidth', 1.6);
loglog(f, magSf, '--','Color',col.red, 'LineWidth', 1.7); 
loglog(f, magSd, '--','Color',col.blue, 'LineWidth', 1.7);
%grid on;
ylabel('Magnitude [m/N]');%xlabel('Frequency [Hz]');
ylim([1e-12,1e-1]); 
xlim([1e0,1e3])
%title('Pendulum Response, Deformation, and Combined');
legend('free-body', 'deformation', 'total response',fontsize=10);
legend("boxoff")

% Phase
nexttile;
semilogx(f, phaseC,'Color','k', 'LineWidth', 1.6);hold on
semilogx(f, phaseSf, '--','Color',col.red, 'LineWidth', 1.7);
semilogx(f, phaseSd, '--','Color',col.blue, 'LineWidth', 1.7);

%grid on;
xlabel('Frequency [Hz]');
ylabel('Phase [deg]');
ylim([-200, 20]);
xlim([1e0,4e4])

linkaxes(findall(gcf,'Type','axes'),'x');

%% ratio
figure()
semilogx(f, magSf./magC,'k', 'LineWidth', 1.5);
ylim([0.98, 1.03])
xlim([1e1,1e3])
yline(1.01,'Color',col.red, 'LineWidth', 1.5)
yline(0.99,'Color',col.red, 'LineWidth', 1.5)
grid on;
title('Discrepancy between reponses')
ylabel('Ratio S_p / S [-]')
xlabel('Frequency [Hz]')

%% uncertainty
figure()
semilogx(f, (magSf./magC-1)*100,'k', 'LineWidth', 1.7);
hold on
ylim([-3, 3])
xlim([1e1,1e3])
semilogx([10,1000], [1,1],'Color',col.red, 'LineWidth', 1.7)
semilogx([10,1000], [-1,-1],'Color',col.red, 'LineWidth', 1.7)
%yline(1,'Color',col.red, 'LineWidth', 1.7)
%yline(-1,'Color',col.red, 'LineWidth', 1.7)


yline(0)
%xline(10)
%xline(1000)
legend('response uncertainty', 'max. allowed uncertainty', fontsize=11,location='northwest')
legend boxoff
%title('Uncertainty of the estimated response S(f)')
ylabel('Error [%]')
xlabel('Frequency [Hz]')

%% Multiple unc. for varying D_eff
figure;
count = 3;
colors = [col.gray3; col.gray2; col.black];
%[5.2e-10,2.5e-10,8.2e-11]
for K = [3.6e-10,6.7e-11,2.3e-11]

Sd = K ./ (1 - (w./w1).^2 + 2i*zeta*(w./w1));
magSd = abs(Sd);
phaseSd = angle(Sd)*180/pi;  % convert to degrees

% Combined response
C = S + Sd;
magC = abs(C);
phaseC = angle(C)*180/pi


semilogx(f, (magSf./magC-1)*100,'color', colors(count,:), 'LineWidth', 1.7);
hold on
count = count-1;
end
semilogx([10,1000], [1,1],'Color',col.red, 'LineWidth', 1.7)
semilogx([10,1000], [-1,-1],'Color',col.red, 'LineWidth', 1.7)
ylim([-0.51, 2])
xlim([1e1,1e3])
legend('d = 5 mm', 'd = 20 mm', 'd = 40 mm', 'max. allowed uncertainty' , Location=' northwest', fontsize=10)
legend boxoff
ylabel('Error [%]')
xlabel('Frequency [Hz]')
%title('Frequency response error', FontSize=14)
%yline(1,'Color',col.red, 'LineWidth', 1.7)
%yline(-1,'Color',col.red, 'LineWidth', 1.7)
%box on

%% total unc
unc = [0.47, 0.2, 0.23, 0.26, 0.17];

prev_unc = sqrt(sum(unc.^2))

def_unc = abs(magSf./magC-1)*100;

tot_unc= sqrt(prev_unc.^2 + def_unc.^2);

figure()
semilogx(f, tot_unc,'k', 'LineWidth', 1.7);
hold on
ylim([0, 2])
xlim([0.5e1,2e3])
semilogx([1,3000], [1,1],'Color',col.red, 'LineWidth', 1.7)
ylabel('Uncertainty [%]')
xlabel('Frequency [Hz]')

legend('calibration uncertainty', 'target cal. uncertainty', fontsize=11,location='northwest')
legend boxoff


%% Interpolated L(f) on log grid

load('ETpathfinder_extracted_smooth.mat')

fi=f_smooth;
di=d_smooth;

logfi = log10(fi);

% Remove duplicates safely
[ulogfi, ~, idx] = unique(logfi);
di_avg = accumarray(idx, di, [], @mean);
% Target grid
logf_new = linspace(0,4,1000);
f_L = 10.^logf_new;
% Interpolation
L = interp1(ulogfi, di_avg, logf_new, 'linear', NaN);


figure;
%loglog(f_smooth, d_smooth, 'k-', 'LineWidth', 1.3);
%hold on
loglog(f_L, L, 'r-', 'LineWidth', 1.3);
%grid on;
xlabel('Frequency [Hz]');
ylabel('Displacement [m/\surd Hz]');
%title('Design Sensitivity of ETpathfinder-A');
xlim([1,1e4]); ylim([1e-21,1e-15]);

%% required integration time
R = 0.18; % [-]
P = 0.8e-3; % [W]
c = 3e8;  % [m/s]
SNR = 100;% [-]
th = 0.59;% [rad] 
Sf = magC;

T=  ( c * SNR * L ./ ((1+R)*P*Sf*cos(th)) ).^2  ;


figure
loglog(f,T,'b-', 'LineWidth', 1.3)
ylabel('Minimal required time T [s]')
xlabel('Frequency [Hz]')

%% Extract and compare
x=617; %334 is f=10 | 500 is f=100 | 667 is f=1000
fi = f(x)
Si = Sf(x);
Li = L(x);
T = 10;

P = c/(2*Si)*Li*SNR/sqrt(T)*1000

%% SNR calculation for SLD
x=591; %334 is f=10 | 500 is f=100 | 667 is f=1000

fi = f(x)
Si = Sf(x);
Li = L(x);



P = 4.6e-3;              % power [W]
theta = deg2rad(35);     % incident angle [rad]

theta_p = asin(sin(theta)/n);   % Snell's law

% define your parameters:
rho = 0.71;        % reflectivity
S_f = Si;        % signal spectrum at f
DeltaL = Li;     % noise spectrum at f
T = 60;          % integration time [s]
c = 3e8;          

SNR = (P *  (1+rho)*cos(theta) * S_f * sqrt(T) )...
      / (DeltaL * c)