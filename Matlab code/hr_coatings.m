clear; clc; close all;
%% Import data from spreadsheet

% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];  
col.black = [0, 0, 0];  

%%
opts = spreadsheetImportOptions("NumVariables", 4);

% Specify sheet and range
opts.Sheet = "HR";
opts.DataRange = "A2:D2421";

% Specify column names and types
opts.VariableNames = ["Wlgth", "Ra0", "Rs45", "Rp45"];
opts.VariableTypes = ["double", "double", "double", "double"];

% Import the data
HR_tab = readtable("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\Matlab\Data\251124 - HR and AR reflectance spectrum - 400-2100 nm - AOI 0° and 45° .xlsx", opts, "UseExcel", false);
HR =  table2array(HR_tab);

wl      = HR(:,1);
Ra0     = HR(:,2);
Rs45    = HR(:,3);
Rp45    = HR(:,4);
clear opts

%% Plot coatings


% Parameters
mu = 670;        % mean
sigma = 3;      % standard deviation

x = linspace(mu - 4*sigma, mu + 4*sigma, 1000);
% Gaussian distribution
y = (1/(sigma*sqrt(2*pi))) * exp(-0.5*((x - mu)/sigma).^2);

% Plot
figure;
plot(wl,Ra0,'Color',[.4 .4 .4],LineWidth=1.5)
hold on
plot(wl,Rp45,'b',LineWidth=1.5)
plot(wl,Rs45,'r',LineWidth=1.5)


%plot(wl,Rs45,'r',LineWidth=1.5)
%plot(wl,Rp45,'b',LineWidth=1.5)
%plot(wl,Ra0,'Color',[.4 .4 .4],LineWidth=1.5)
%plot(x, 300*y, 'LineWidth', 2);
title( 'Test mass HR coating')
legend(' 0\circ arbitrary polarization', '45\circ p-polarized','45\circ s-polarized', 'Fontsize', 10)
%legend('45\circ s-polarized', 'Fontsize', 10)
legend('boxoff')
xlabel('Wavelength [nm]'); ylabel('Reflectivity [%]')
xlim([400,1900])
%xlim([400,600])


%% 35 degrees AOI

opts = spreadsheetImportOptions("NumVariables", 5);

% Specify sheet and range
opts.Sheet = "HR datas";
opts.DataRange = "A2:E2472";

% Specify column names and types
opts.VariableNames = ["Wlgth", "Ta0", "Ra0", "Rp35", "Rs35"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Import the data
%HR2 = readtable("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\Matlab\Data\260305 - HR and AR T&R spectrum - 400-2100 nm - AOI 35° .xlsx", opts, "UseExcel", false);
%HR =  table2array(HR2);
%clear opts

% Import the NEW UPDATED SPECTRUM data
HR2 = readtable("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\Matlab\Data\260320 - HR and AR simulations V4.xlsx", opts, "UseExcel", false);
HR =  table2array(HR2);
clear opts


wl2      =HR(:,1);
Rp35    = HR(:,4);
Rs35    = HR(:,5);
%%
% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];  
col.black = [0,0,0];  
% Parameters
mu = 1460;      % mean
sigma = 1;      % standard deviation

x = linspace(mu - 400*sigma, mu + 400*sigma, 8000);
% Gaussian distribution
y = (1/(sigma*sqrt(2*pi))) * exp(-0.5*((x - mu)/sigma).^2);

figure;
%plot(wl,Ra0,'Color',[.4 .4 .4],LineWidth=1.5)
hold on
colororder([col.black; col.red])

yyaxis left
plot(wl2,Rs35,'Color', col.black,LineWidth=1.5)
plot(wl2,Rp35,'--','Color', col.black,LineWidth=1.5)



%plot(wl,Rp45,'r',LineWidth=1.5)
%plot(wl,Rs45,'r',LineWidth=1.5)


%legend('45\circ s-polarized', 'Fontsize', 10)
legend boxoff
xlabel('Wavelength [nm]'); ylabel('Reflectivity [%]')
%xlim([400,1900])
xlim([1000,1800]);ylim([0,100])


yyaxis right

plot(x,y*(1/max(y)),'Color', col.red,LineWidth=1.5)
ylabel('Intensity [-]')
ylim([0,1])
%title( 'Test mass HR coating')
legend('35\circ s-polarized','35\circ p-polarized','\lambda = 1460 nm' , 'Fontsize', 10, location='northwest')
box on
% rho calc

% Reflectivity data:
wlgth = wl2;
R     = Rp35;
I=y;

% Interpolate reflectivity onto beam wavelength grid
R_interp = interp1(wlgth, R, x, 'linear', 0);

% Weighted reflectance
R_eff = trapz(x, R_interp .* I) / trapz(x, I);

fprintf('Effective reflectance = %.6f\n', R_eff);

