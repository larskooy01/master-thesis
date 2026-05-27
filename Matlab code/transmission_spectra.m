clc;close all;clear
%% importing data
% sapphire
sa_40K  = table2array(importfile1('transmission_data\sapphire_transmission_40K.csv'));
tau_sa_40 = sa_40K(:,2);
lambda_sa_40 = sa_40K(:,1);

sa_300K = table2array(importfile1('transmission_data\sapphire_transmission_300K.csv'));
tau_sa_300 = sa_300K(:,2);
lambda_sa_300 = sa_300K(:,1);

sa_250K = table2array(importfile1('transmission_data\sapphire_transmission_250K.csv'));
tau_sa_250 = sa_250K(:,2);
lambda_sa_250 = sa_250K(:,1);

sa_80K = table2array(importfile1('transmission_data\sapphire_transmission_80K.csv'));
tau_sa_80 = sa_80K(:,2);
lambda_sa_80 = sa_80K(:,1);

sa_15K = table2array(importfile1('transmission_data\sapphire_transmission_15K.csv'));
tau_sa_15 = sa_15K(:,2);
lambda_sa_15 = sa_15K(:,1);

tau_sa_15 = max(tau_sa_15, 0);
tau_sa_40 = max(tau_sa_40, 0);
tau_sa_80 = max(tau_sa_80, 0);
tau_sa_250 = max(tau_sa_250, 0);
tau_sa_300 = max(tau_sa_300, 0);

% fused silica and nbk7
fs = table2array(importfile1('transmission_data\silica_transmission.csv'));
tau_fs = fs(:,2);
lambda_fs = fs(:,1);
tau_fs= max(tau_fs, 0);

nb = table2array(importfile1('transmission_data\nbk7_transmission.csv'));
tau_nb = nb(:,2);
lambda_nb = nb(:,1);
tau_nb= max(tau_nb, 0);

% crystalline quartz
cq_250K = table2array(importfile1('transmission_data\cq_transmission_250K.csv'));
tau_cq_250 = cq_250K(:,2);
lambda_cq_250 = cq_250K(:,1);

cq_80K  = table2array(importfile1('transmission_data\cq_transmission_80K.csv'));
tau_cq_80 = cq_80K(:,2);
lambda_cq_80 = cq_80K(:,1);

cq_40K  = table2array(importfile1('transmission_data\cq_transmission_40K.csv'));
tau_cq_40 = cq_40K(:,2);
lambda_cq_40 = cq_40K(:,1);

cq_15K  = table2array(importfile1('transmission_data\cq_transmission_15K.csv'));
tau_cq_15 = cq_15K(:,2);
lambda_cq_15 = cq_15K(:,1);

%%

%% emission spectra
fs_em  = table2array(importfile1('transmission_data\emittance_fs.csv'));
eps_fs = fs_em(:,2);
lam_fs = fs_em(:,1)*1e-6;

% adding data points
eps_fs = [eps_fs; ones(100,1)*0.97];
tool = linspace(lam_fs(end),1e-4,100);
lam_fs = [lam_fs; tool'];

lam = lam_fs;
lam_fs =logspace(-1,3,400)*1e-6;% if only plotting B
lam = lam_fs;
alpha=eps_fs;
T=[300,250,80,40,15];
h = 6.62607015e-34;
c = 299792458;
k = 1.380649e-23;
B={};
for i = 1:length(T)
    Ti  = T(i);
    B{i} = (2*pi*h*c^2)./lam.^5 ./ (exp(h*c./(lam*k*Ti)) - 1);
end

%% plotting various B (spectral emittance)
% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];   

figure;
loglog(lam_fs*1e6,B{1}*1e-6,'color',col.red,LineWidth=1.7)
hold on
loglog(lam_fs*1e6,B{2}*1e-6,'color',col.gray1,LineWidth=1.7)
loglog(lam_fs*1e6,B{3}*1e-6,'color',col.gray2,LineWidth=1.7)
loglog(lam_fs*1e6,B{4}*1e-6,'color',col.blue,LineWidth=1.7)
%loglog(lam_fs*1e6,B{5}*1e-6,'color',col.blue,LineWidth=1.2)



ylim([0.1*1e-6, 1e8*1e-6])
ylabel('Spectral exitance [W/m^2/\mum]')
legend('300 K', '250 K', '80 K', '40 K', fontsize=10)
legend boxoff

xlabel('Wavelength [\mum]')


%% also emissivity / transmission
eps_eff = [];
for i = 1:length(T)
    eps_eff(i) = trapz(lam, alpha .* B{i}) / trapz(lam, B{i});
end
% emissivity and transmissivity for varying black-body radiatio
% temperatures
eps_eff
tau_eff = 1-eps_eff
% figure emissivity FS
figure;
yyaxis left
loglog(lam_fs*1e6,B{1}*1e-6,LineWidth=1.2)
hold on
loglog(lam_fs*1e6,B{3}*1e-6,LineWidth=1.2)
ylim([0.1*1e-6, 1e8*1e-6])
ylabel('spectral emittance e_{b,\lambda} [W/m^2/\mum]')
%legend(['300K', '250K', '80K', '40K'])

yyaxis right
semilogx(lam_fs*1e6,eps_fs,LineWidth=1.2)
ylabel('spectral emissivity \epsilon_\lambda [-]')
xlim([1,500])
ylim([0.1,1.01])
xlabel('wavelength \lambda [\mum]')

%% calculating tau_eff and alpha_eff
tauw = tau_sa_80;
tau = tauw + (tauw==0)*0.001;
alpha = 1 - tau;
lam = lambda_sa_80*1e-6;

%% manual for report calculating tau_eff and alpha_eff
tau = tau_cq_40;
tau(tau < 0.29) = 0.0000001;
alpha = 1 - tau;

lam = lambda_cq_40*1e-6;

T=[300,250,80,40];
h = 6.62607015e-34;
c = 299792458;
k = 1.380649e-23;

B={};
for i = 1:length(T)
    Ti  = T(i);
    B{i} = (2*h*c^2)./lam.^5 ./ (exp(h*c./(lam*k*Ti)) - 1);
end

eps_eff = [];
for i = 1:length(T)
    eps_eff(i) = trapz(lam, alpha .* B{i}) / trapz(lam, B{i});
end
% emissivity and transmissivity for varying black-body radiatio
% temperatures
eps_eff;
tau_eff = 1-eps_eff



%% transmission spectrum SAPPHIRE

figure;
%semilogx(lambda_sa_40,tau_sa_40)
hold on
%semilogx(lambda_sa_300,tau_sa_300)
%semilogx(lambda_sa_80,tau_sa_80)
semilogx(lambda_fs,tau_fs)
hold on
semilogx(lambda_nb,tau_nb)
legend


%% calculating e_eff or a_eff
lambda = {};
lambda{1}=lambda_sa_300*1e-6;
lambda{2}=lambda_sa_250*1e-6;
lambda{3}=lambda_sa_80*1e-6;
lambda{4}=lambda_sa_40*1e-6;
lambda{5}=lambda_fs*1e-6;

tau = {};
tau{1}=tau_sa_300;
tau{2}=tau_sa_250;
tau{3}=tau_sa_80;
tau{4}=tau_sa_40;
tau{5}=tau_fs;


%alpha = 1 - tau;
T=[300,250,80,40];

h = 6.62607015e-34;
c = 299792458;
k = 1.380649e-23;

B={};
for i = 1:length(T)
    lam = lambda{i};
    Ti  = T(i);
    B{i} = (2*h*c^2)./lam.^5 ./ (exp(h*c./(lam*k*Ti)) - 1);
end

%% transmissivity
figure;
yyaxis left
loglog(lambda{1}*1e6,B{1}*1e-6,LineWidth=1.2)
hold on
%loglog(lambda{2}*1e6,B{2}*1e-6,LineWidth=1.2)
loglog(lambda{3}*1e6,B{3}*1e-6,LineWidth=1.2)
%loglog(lambda{4}*1e6,B{4}*1e-6,LineWidth=1.2)
ylim([0.1*1e-6, 2e7*1e-6])
ylabel('spectral irradiance e_{b,\lambda} [W/m^2/\mum]')
%legend(['300K', '250K', '80K', '40K'])
yyaxis right
semilogx(lambda{1}*1e6,tau{1},LineWidth=1.2)
semilogx(lambda{3}*1e6,tau{3},LineWidth=1.2)
ylabel('spectral transmissivity \epsilon_\lambda [-]')
xlim([1,500])
ylim([-0.01,1])
xlabel('wavelength \lambda [\mum]')

%% transmissivity x spectrum
i = 5; % window temp [300, 250, 80, 40]
j = 5; % radiation temp


%tau_w = tau{j} + (tau{j}==0)*0.005;
%lam_w = lambda{j};

Tj  = T(1);


%% manual plotting for report (replace in report if needed**) (cq 250)

col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];

tau_w = tau_sa_250;
lam_w = lambda_sa_250*1e-6;

tau_w(tau_w < 0.29) = tau_w(tau_w < 0.29)*0.001;
tau_w = tau_w+0.0001;


Tj = 300;

B_w = (2*h*c^2)./lam_w.^5 ./ (exp(h*c./(lam_w*k*Tj)) - 1);

B_t = tau_w.*B_w;


figure;

ax = gca;

yyaxis left
loglog(lam_w*1e6, B_w*1e-6, 'Color', col.red, 'LineWidth', 1.7)
hold on
loglog(lam_w*1e6, B_t*1e-6, 'Color', col.red, 'LineWidth', 1.7)
ylabel('Spectral irradiance [W/m^2/\mum]')
ylim([0.1e-6, 55e7*1e-6])
ax.YColor = col.red;

yyaxis right
semilogx(lam_w*1e6, tau_w, 'Color', col.gray1, 'LineWidth', 1.7)
ylabel('Spectral transmissivity [-]')
ylim([-0.01, 1])
ax.YColor =  col.gray1;

xlim([1, 450])
xlabel('Wavelength [\mum]')

%ax.XColor = [0.2 0.2 0.2];
%grid on
title('sapphire at 250 K', FontSize=14)

legend('irradiation (300K)', 'transmitted radiation', 'sapphire', 'location', 'northeast', fontsize=10)
legend boxoff


%% manual plotting for report (replace in report if needed**) (cq 40)
tau_w = tau_sa_40;
lam_w = lambda_sa_40*1e-6;

tau_w(tau_w < 0.29) = tau_w(tau_w < 0.29)*0.1;
tau_w = tau_w+0.00000001;


Tj = 80;

B_w = (2*h*c^2)./lam_w.^5 ./ (exp(h*c./(lam_w*k*Tj)) - 1);

B_t = tau_w.*B_w;


figure;

ax = gca;

yyaxis left
loglog(lam_w*1e6, B_w*1e-6, 'Color', col.blue, 'LineWidth', 1.7)
hold on
loglog(lam_w*1e6, B_t*1e-6, 'Color', col.blue, 'LineWidth', 1.7)
ylabel('Spectral irradiance [W/m^2/\mum]')
ylim([0.1e-6, 55e7*1e-6])
ax.YColor = col.blue;

yyaxis right
semilogx(lam_w*1e6, tau_w, 'Color', col.gray1, 'LineWidth', 1.7)
ylabel('Spectral transmissivity [-]')
ylim([-0.01, 1])
ax.YColor =  col.gray1;

xlim([1, 450])
xlabel('Wavelength [\mum]')

%ax.XColor = [0.2 0.2 0.2];
%grid on
title('sapphire at 40 K', FontSize=14)

legend('irradiation (80K)', 'transmitted radiation', 'sapphire', 'location', 'northeast', fontsize=10)
legend boxoff
%% manual plotting for report (replace in report if needed**) (fs 40)
tau_w = tau_fs;
lam_w = lambda_fs*1e-6;

tau_w(tau_w < 0.29) = tau_w(tau_w < 0.29)*0.1;
tau_w = tau_w+0.00000001;


Tj = 80;

B_w = (2*h*c^2)./lam_w.^5 ./ (exp(h*c./(lam_w*k*Tj)) - 1);

B_t = tau_w.*B_w;


figure;

ax = gca;

yyaxis left
loglog(lam_w*1e6, B_w*1e-6, 'Color', col.blue, 'LineWidth', 1.7)
hold on
loglog(lam_w*1e6, B_t*1e-6, 'Color', col.blue, 'LineWidth', 1.7)
ylabel('Spectral irradiance [W/m^2/\mum]')
ylim([0.1e-6, 55e7*1e-6])
ax.YColor = col.blue;

yyaxis right
semilogx(lam_w*1e6, tau_w, 'Color', col.gray1, 'LineWidth', 1.7)
ylabel('Spectral transmissivity [-]')
ylim([-0.01, 1])
ax.YColor =  col.gray1;

xlim([1, 100])
xlabel('Wavelength [\mum]')

%ax.XColor = [0.2 0.2 0.2];
%grid on
title('fused silica at 40 K', FontSize=14)

legend('irradiation (80K)', 'transmitted radiation', 'fused silica', 'location', 'northeast', fontsize=10)
legend boxoff
%% manual plotting for report (replace in report if needed**) (fs 250)

col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];

tau_w = tau_fs;
lam_w = lambda_fs*1e-6;

tau_w(tau_w < 0.29) = tau_w(tau_w < 0.29)*0.1;
tau_w = tau_w+0.000000001;


Tj = 300;

B_w = (2*h*c^2)./lam_w.^5 ./ (exp(h*c./(lam_w*k*Tj)) - 1);

B_t = tau_w.*B_w;


figure;

ax = gca;

yyaxis left
loglog(lam_w*1e6, B_w*1e-6, 'Color', col.red, 'LineWidth', 1.7)
hold on
loglog(lam_w*1e6, B_t*1e-6, 'Color', col.red, 'LineWidth', 1.7)
ylabel('Spectral irradiance [W/m^2/\mum]')
ylim([0.1e-6, 55e7*1e-6])
ax.YColor = col.red;

yyaxis right
semilogx(lam_w*1e6, tau_w, 'Color', col.gray1, 'LineWidth', 1.7)
ylabel('Spectral transmissivity [-]')
ylim([-0.01, 1])
ax.YColor =  col.gray1;

xlim([1, 100])
xlabel('Wavelength [\mum]')

%ax.XColor = [0.2 0.2 0.2];
%grid on
title('fused silica at 250 K', FontSize=14)

legend('irradiation (300K)', 'transmitted radiation', 'fused silica', 'location', 'southeast', fontsize=10)
legend boxoff


%%

figure;
yyaxis left
loglog(lam_w*1e6,B_w*1e-6,LineWidth=1.2)
hold on
loglog(lam_w*1e6,B_t*1e-6,LineWidth=1.2)
ylim([0.1*1e-6, 2e7*1e-6])
ylabel('Spectral irradiance [W/m^2/\mum]')
yyaxis right
semilogx(lam_w*1e6,tau_w,LineWidth=1.2)
ylabel('Spectral transmissivity [-]')
xlim([1,500]); ylim([-0.01,1])
xlabel('wavelength \lambda [\mum]')
legend('incident radiation' , 'transmitted radiation', 'c-quartz transmissivity')
legend('boxoff')

%% emissivity
figure;
yyaxis left
loglog(lambda{1}*1e6,B{1}*1e-6,LineWidth=1.2)
hold on
%loglog(lambda{2}*1e6,B{2}*1e-6,LineWidth=1.2)
loglog(lambda{3}*1e6,B{3}*1e-6,LineWidth=1.2)
%loglog(lambda{4}*1e6,B{4}*1e-6,LineWidth=1.2)
ylim([0.1*1e-6, 1e8*1e-6])
ylabel('spectral emittance e_{b,\lambda} [W/m^2/\mum]')
%legend(['300K', '250K', '80K', '40K'])
yyaxis right
semilogx(lambda{1}*1e6,1-tau{1},LineWidth=1.2)
%semilogx(lambda{2}*1e6,1-tau{2},LineWidth=1.2)
semilogx(lambda{3}*1e6,1-tau{3},LineWidth=1.2)
%semilogx(lambda{4}*1e6,1-tau{4},LineWidth=1.2)
ylabel('spectral emissivity \epsilon_\lambda [-]')
xlim([1,500])
ylim([0.1,1.01])
xlabel('wavelength \lambda [\mum]')


%%
% values
j=1; % choose window temperature / transmissivity spectrum

alpha = 1 - tau{j};
lam = lambda{j};


B={};
for i = 1:length(T)
    Ti  = T(i);
    B{i} = (2*h*c^2)./lam.^5 ./ (exp(h*c./(lam*k*Ti)) - 1);
end

eps_eff = [];
for i = 1:length(T)
    eps_eff(i) = trapz(lam, alpha .* B{i}) / trapz(lam, B{i});
end
% emissivity and transmissivity for varying black-body radiatio
% temperatures
eps_eff
tau_eff = 1-eps_eff



%% importfunction

function sapphiretransmission300K = importfile1(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  SAPPHIRETRANSMISSION300K = IMPORTFILE1(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the data as a table.
%
%  SAPPHIRETRANSMISSION300K = IMPORTFILE1(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  sapphiretransmission300K = importfile1("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\Matlab\transmission_data\sapphire_transmission_300K.csv", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 30-Jan-2026 15:18:37

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
sapphiretransmission300K = readtable(filename, opts);

end