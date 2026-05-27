%% Parameters
T0 = 80;          % [K] boundary temperature
k  = 1.39;         % [W/(m*K)] thermal conductivity
t  = 2e-3;        % [m] window thickness
R  = 0.05;        % [m] window radius
Q = 100e-3;       % [W]
A = pi*R^2;
q  = Q/A;          % [W/m^2] absorbed heat flux


r = linspace(0, R, 500);   % radial positions
T = T0 + (q./(4*k*t)) .* (R^2 - r.^2);

% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6];   

%% import COMSOL DATA
opts = delimitedTextImportOptions("NumVariables", 4);
% Specify range and delimiter
opts.DataLines = [10, Inf];
opts.Delimiter = "  ";
% Specify column names and types
opts.VariableNames = ["Model", "Var2", "VarName3", "Var4"];
opts.SelectedVariableNames = ["Model", "VarName3"];
opts.VariableTypes = ["double", "string", "double", "string"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
% Specify variable properties
opts = setvaropts(opts, ["Var2", "Var4"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var4"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["Model", "VarName3"], "ThousandsSeparator", ",");

% Import the data
table = readtable("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\COMSOL\conduction\Tr_only_qi.txt", opts);
rTcom = table2array(table);
rc = rTcom (:,1);
Tc = rTcom (:,2);

%clear opts
%% Compare to comsol data

figure;
plot(r, T, 'r', 'LineWidth', 1.5);
hold on
plot(rc, Tc,'ro', 'LineWidth', 1.5);


xlabel('radius r [m]');
ylabel('temperature T [K]');
legend('analytical (k=1.39)', 'COMSOL (k=1.39)')
%title('Radial temperature profile in window');
xlim([0,0.05])
legend('boxoff')

%% varying k
% at 80K for Fused Silica, N-BK7 and Sapphire, respectively
k  = [0.1; 0.4; 900] ;         % [W/(m*K)] thermal conductivity

T = T0 + (q./(4.*k*t)) .* (R^2 - r.^2);

figure;
plot(r,T)

%% --- INCLUDING RADIATION TO ENVIRONMENT --- 
Tenv = 80;        % [K] environment temperature
T0 = 80;          % [K] boundary temperature

k  = 0.1;         % [W/(m*K)] thermal conductivity
t  = 2e-3;        % [m] window thickness
R  = 0.05;        % [m] window radius
Q = 100e-3;       % [W]
A = pi*R^2;       % [m^2] window area
eps  = 1;             % emissivity
q  = eps*Q/A;          % [W/m^2] absorbed heat flux

sigma = 5.670374e-8;    % Stefan-Boltzmann constant

% Linearized radiation
hrad1 = 4*eps*sigma*Tenv^3;     % [W/(m^2*K)]
hrad = 2*hrad1;                 % radiating from both surfaces

lambda = sqrt(hrad/(k*t));      % [1/m]

% Constant from boundary condition
C = (T0 - Tenv - q/hrad) / besseli(0, lambda*R);

% Temperature profile
T = Tenv + q/hrad + C*besseli(0, lambda*r);
% Comsol data
table = readtable("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\COMSOL\conduction\Tr_qi_and_2qrad_q100_k01.txt", opts);
rTcom = table2array(table);
rc = rTcom (:,1);
Tc_k01 = rTcom (:,2);

table = readtable("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\COMSOL\conduction\Tr_qi_and_2qrad_q100_k04.txt", opts);
rTcom = table2array(table);
Tc_k04 = rTcom (:,2);


table = readtable("C:\Users\larsk\OneDrive\Documents\AA Lars 2025\1. Graduation Project\COMSOL\conduction\Tr_qi_and_2qrad_q100_k900.txt", opts);
rTcom = table2array(table);
Tc_k900 = rTcom (:,2);

% Analytical data
k=0.39;
lambda = sqrt(hrad/(k*t));      % [1/m]
C = (T0 - Tenv - q/hrad) / besseli(0, lambda*R);
T_k04 = Tenv + q/hrad + C*besseli(0, lambda*r);

k=700;
lambda = sqrt(hrad/(k*t));      % [1/m]
C = (T0 - Tenv - q/hrad) / besseli(0, lambda*R);
T_k900 = Tenv + q/hrad + C*besseli(0, lambda*r);

% Plot
figure
plot(r*1e3, T,'color', col.red, 'LineWidth', 1.7)
hold on
plot(rc*1e3, Tc_k01,'--','color', col.red, 'LineWidth', 1.7)

plot(r*1e3,T_k04,'color',col.gray1,  'LineWidth', 1.7)
plot(rc*1e3, Tc_k04,'--','color',col.gray1, 'LineWidth', 1.7)

plot(r*1e3,T_k900,'color', col.blue, 'LineWidth', 1.7)
plot(rc*1e3, Tc_k900,'--','color', col.blue, 'LineWidth', 1.7)

%grid on

xlabel('Test mass radius [mm]')
ylabel('Temperature [K]')
legend('Matlab        k = 0.1','COMSOL   k = 0.1',...
    'Matlab        k = 0.4','COMSOL   k = 0.4', ...
    'Matlab        k = 700','COMSOL   k = 700', 'fontsize', 9.5)
legend('boxoff')

ylim([78,115])
%title('Thin window with distributed radiation (linearized)')

%%
figure
plot(r*1e3, T,'color', col.red, 'LineWidth', 1.7)
hold on
plot(rc*1e3, Tc_k01,'--','color', col.red, 'LineWidth', 1.7)

plot(r*1e3,T_k04,'color',col.gray1,  'LineWidth', 1.7)
plot(rc*1e3, Tc_k04,'--','color',col.gray1, 'LineWidth', 1.7)

plot(r*1e3,T_k900,'color', col.blue, 'LineWidth', 1.7)
plot(rc*1e3, Tc_k900,'--','color', col.blue, 'LineWidth', 1.7)

%grid on

xlabel('Window radius [mm]')
ylabel('Temperature [K]')
legend('Matlab','COMSOL',...
    'Matlab','COMSOL', ...
    'Matlab','COMSOL', 'fontsize', 9.5)
legend('boxoff')

ylim([78,115])
%title('Thin window with distributed radiation (linearized)')