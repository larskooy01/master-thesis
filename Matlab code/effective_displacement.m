clear; clc; close all;
%%
% Parameters
theta = 0;  % rad
P = 1;      % W
r = 75e-3;  % m
%r_vals = -r:1e-3:r;
r_vals = linspace(-r,r,152);
c = 299792458; % m/s
w = 2.5e-3;  % m

F = 2*cos(theta)*P/c;

F_r = F*exp(-2*r_vals.^2/w^2);


figure()
plot(r_vals,F_r);
xlim([-0.1,0.1])
%% import COMSOL data (GEO 600, fused silica) (displacement over force)
r = 90e-3;  % m
% 3D
deftable = importfile('COMSOL\exports\def_3d_geo.dat');
def = table2array(deftable);
x = def(:,1)-r;
d= def(:,2);


% 2D
def2table = importfile('COMSOL\exports\def_2d_geo.dat');
def2 = table2array(def2table);
x2 = def2(:,1);
d2= def2(:,2);

figure()
plot(x2,d2, LineWidth=1.4)
grid on
hold on
plot(x,d,LineWidth=1.4)
xlabel('Radius [m]')
ylabel('Displacement [m/N]')
xlim([0,0.045])
legend('2D model', '3D model')
title('Deformation of test mass', ' Gaussian distributed force (r=2.5 mm)')

%% CORRECT COMSOL DATA w=0.5, 1, 1.5
% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];   

def2dr05115 = importfiled('COMSOL\exports\deftest.dat');

ar = table2array(def2dr05115);

r = ar(:,1);
d5 = ar(:,2);
d10 = ar(:,3);
d20 = ar(:,4);
d50 = ar(:,5);


figure()
%plot(r*1000,d5,'color', col.red, LineWidth=1.4)
hold on
plot(r*1000,d5,'color', col.red  , LineWidth=1.7)
plot(r*1000,d10,'color',col.blue , LineWidth=1.7)
plot(r*1000,d20,'color', col.black , LineWidth=1.7)
xlabel('Test mass radius [mm]')
ylabel('Deformation [m/N]')
xlim([0,5])
legend('w = 0.5 mm', 'w = 1.0 mm',...
    'w = 1.5 mm', fontsize=10)
legend boxoff
title('test mass deformation', fontsize=14)

box on

%% CORRECT COMSOL DATA w=10, 20, 50
% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];   

def2dr05115 = importfiled('COMSOL\exports\deftest2.dat');

ar = table2array(def2dr05115);

r = ar(:,1);
d5 = ar(:,2);
d10 = ar(:,3);
d20 = ar(:,4);
d50 = ar(:,5);


figure()
%plot(r*1000,d5,'color', col.red, LineWidth=1.4)
hold on
plot(r*1000,d10,'color', col.black  , LineWidth=1.4)
plot(r*1000,d20,'color',col.gray2 , LineWidth=1.4)
plot(r*1000,d50,'color', col.gray3 , LineWidth=1.4)
xlabel('Test mass radius [mm]')
ylabel('Deformation [m/N]')
xlim([0,75])
legend('w = 10 mm \rightarrow D_{eff} = 5.2 \cdot 10^{-10}', 'w = 20 mm \rightarrow D_{eff} = 2.5 \cdot 10^{-10}',...
    'w = 50 mm \rightarrow D_{eff} = 8.2 \cdot 10^{-11}', fontsize=10)
legend boxoff
title('Test mass deformation', fontsize=14)

box on

%% Measured effective displacement
% 2d model results
r = r;
D = d5;


w = 2.2e-3;                % waist radius
I = exp(-2*(r.^2)/w^2);    % intensity profile

% Compute normalization factor kI
num_I = 2*pi*trapz(r, r .* I);   
kI = 1 / num_I;

% Compute D_total
D_tot = 2*pi * kI * trapz(r, r .* I .* D)







%% Changing paramters to ETpf mirrors
r = 75e-3;  % m
% 2D (1 mm beam size)
deftable = importfile('COMSOL\exports\def_2d_etpf_r_0.5.dat');
def = table2array(deftable);
x = def(:,1);
d= def(:,2);


% 2D (10 mm beam size)
def2table = importfile('COMSOL\exports\def_2d_etpf_r_50.dat');
def2 = table2array(def2table);
x2 = def2(:,1);
d2= def2(:,2);



% 2D (50 mm beam size)
def2table = importfile('COMSOL\exports\def_2d_etpf_r_1.5.dat');
def2 = table2array(def2table);
x3 = def2(:,1);
d3= def2(:,2);

figure()
plot(x,d,LineWidth=1.4)
grid on
hold on
plot(x2,d2, LineWidth=1.4)
plot(x3,d3, LineWidth=1.4)
xlabel('Radius [m]')
ylabel('Displacement [m/N]')
xlim([0,0.01])
legend('PCal radius = 1 mm', 'PCal radius = 10 mm', 'PCal radius = 50 mm')
title('Deformation of ETpf test mass', ' Gaussian distributed force')

%% Measured effective displacement
% 2d model results
r = x;
D = d;


w = 2.2e-3;                % waist radius
I = exp(-2*(r.^2)/w^2);    % intensity profile

% Compute normalization factor kI
num_I = 2*pi*trapz(r, r .* I);   
kI = 1 / num_I;

% Compute D_total
D_tot = 2*pi * kI * trapz(r, r .* I .* D)

%% Varying Pcal radii and determining D_tot
r_pcal = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.5]; % [m]
D_total =[3.17, 2.67, 1.83, 1.84, 1.90, 1.91, 1.89, 1.86, 1.83, 1.80, 1.73, 1.66, 1.58, 1.51, 1.44, 1.37, 1.28]*1e-9; % [m]

figure()
plot(r_pcal,D_total, LineWidth=1.4)
xlim([0.6,2.5])
grid on
xlabel('Pcal beam radius [mm]')
ylabel('D_{total} [m/N]')
title('Measured effective displacement for varying Pcal radius')

%% Varying Pcal radii (0.5, 1.0, 1.5 mm)

% 2D
def2table5 = importfile('COMSOL\exports\def_2d_etpf_r_0.5.dat');
def2table1 = importfile('COMSOL\exports\def_2d_etpf_r_1.0.dat');
def2table15 = importfile('COMSOL\exports\def_2d_etpf_r_1.5.dat');
def2 = table2array(def2table5);
x_05 = def2(:,1); d_05= def2(:,2);
def2 = table2array(def2table1);
x_10 = def2(:,1); d_10= def2(:,2);
def2 = table2array(def2table15);
x_15 = def2(:,1); d_15= def2(:,2);


figure()
plot(x_05*1000,d_05, LineWidth=1.4)
grid on
hold on
plot(x_10*1000,d_10, LineWidth=1.4)
plot(x_15*1000,d_15, LineWidth=1.4)
xlabel('Radius [mm]')
ylabel('Displacement [m/N]')
xlim([0,20])
legend('r=0.5 [mm]', 'r=1.0 [mm]','r=1.5 [mm]')
title('Deformation of ETpf test mass', ' Gaussian distributed force')

%% Responses
% Parameters
M = 3.29;           % mass [kg]
f0 = 0.3;           % resonance frequency [Hz]
zeta = 0.0001;      % small damping
omega0 = 2*pi*f0;   % natural angular frequency [rad/s]

% Frequency vector
f = logspace(1, 4, 1000);   % 0.01 Hz to 100 Hz
omega = 2*pi*f;

% Pendulum transfer function H(ω) [m/N]
H = 1 ./ (M*(omega0^2 - omega.^2 + 1i*2*zeta*omega0.*omega));
magH = abs(H);
phaseH = angle(H)*180/pi;  % convert to degrees

% Flat transfer function
H_def = ones(size(H))*2.5e-9;  % effective displacement by deformation
magDef = abs(H_def);
phaseDef = angle(H_def)*180/pi;

% Combined response
HC = H + H_def;
magC = abs(HC);
phaseC = angle(HC)*180/pi;

% Plotting
figure;
tiledlayout(2,1);

% Magnitude
nexttile;
loglog(f, magH, 'b--', 'LineWidth', 1.5); hold on;
loglog(f, magDef, 'r--', 'LineWidth', 1.5);
loglog(f, magC, 'g', 'LineWidth', 1.5);
grid on;
ylabel('Magnitude [m/N]');
title('Pendulum Response, Deformation, and Combined');
legend('Pendulum response', 'Mirror deformation', 'Total displacement');

% Phase
nexttile;
semilogx(f, phaseH, 'b--', 'LineWidth', 1.5); hold on;
semilogx(f, phaseDef, 'r--', 'LineWidth', 1.5);
semilogx(f, phaseC, 'g', 'LineWidth', 1.5);
grid on;
xlabel('Frequency [Hz]');
ylabel('Phase [deg]');
ylim([-200, 20])

linkaxes(findall(gcf,'Type','axes'),'x');

%% ratio
figure()
semilogx(f, magH./magC,'k', 'LineWidth', 1.5);
ylim([0.9, 3])
%xlim([1e2,5e3])
grid on;
title('Discrepancy between reponse with and without deformation')
ylabel('Ratio H_p / H_c [-]')
xlabel('Frequency [Hz]')

%% uncertainty
figure()
semilogx(f, (magH./magC-1)*100,'k', 'LineWidth', 1.5);
ylim([0, 50])
xlim([1e1,1e3])
grid on;
title('Uncertainty of the estimated response S(f)')
ylabel('Error [%]')
xlabel('Frequency [Hz]')


%%
function def2dr05115 = importfiled(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  DEF2DR05115 = IMPORTFILE1(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  DEF2DR05115 = IMPORTFILE1(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  def2dr05115 = importfile1("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\COMSOL\exports\def_2d_r05-1-15.dat", [9, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 16-Apr-2026 13:47:33

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [9, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "  ";

% Specify column names and types
opts.VariableNames = ["Description", "LineGraph", "VarName3", "VarName4", "VarName5"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Import the data
def2dr05115 = readtable(filename, opts);

end