%clc;close all;clear
%% Some COMSOL comparisons of varying thickness, htc and thermal contact
%% importing all data

% %%%%%%%%%%%%% NOTE: all q values should be done +0.0182 (= A sig 80^4) 
% to obtain the actual radiated value. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fully edge cooled (e=1, FS)
tab = importfile1("COMSOL\Varying h_tc\T_80 with qin_2.16\edge_cooled_R50_d1");
edge_R50_d1 = table2array(tab);
tab = importfile1("COMSOL\Varying h_tc\T_80 with qin_2.16\edge_cooled_R50_d1_5");
edge_R50_d15 = table2array(tab);
tab = importfile1("COMSOL\Varying h_tc\T_80 with qin_2.16\edge_cooled_R50_d2");
edge_R50_d2 = table2array(tab);
tab = importfile1("COMSOL\Varying h_tc\T_80 with qin_2.16\edge_cooled_R50_d3");
edge_R50_d3 = table2array(tab);
tab = importfile1("COMSOL\Varying h_tc\T_80 with qin_2.16\edge_cooled_R50_d4");
edge_R50_d4 = table2array(tab);
tab = importfile1("COMSOL\Varying h_tc\T_80 with qin_2.16\edge_cooled_R50_d5");
edge_R50_d5 = table2array(tab);

htc = edge_R50_d1(:,1); 

q_d1   = edge_R50_d1(:,2);
q_d15   = edge_R50_d15(:,2);
q_d2   = edge_R50_d2(:,2);
q_d3   = edge_R50_d3(:,2);
q_d4   = edge_R50_d4(:,2);
q_d5   = edge_R50_d5(:,2);

% plotting colors
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6]; 
col.gray4 = [0.75, 0.75, 0.75]; 
%% sapphire data
% fully edge cooled (e=1, SAPPHIRE, varying htc and d)
tab = importfile_sa("COMSOL\Varying h_tc\T_80 with qin_2.16\" + ...
    "for sapphire (d2,3,5)\sa_edge_cooled_R50");
vals = sortrows(table2array(tab),2);
htc_sa = vals(1:18,1);
sa_q_d2 = vals(1:18,3);
sa_q_d3 = vals(19:36,3);
sa_q_d5 = vals(37:54,3);



%%
% partly cooled (e=0.1)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge01_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e01_q_d = vals(1:17,3);
e01_q_d1_5 = vals(18:34,3);
e01_q_d2 = vals(35:51,3);
e01_q_d3 = vals(52:68,3);
e01_q_d4 = vals(69:85,3);
e01_q_d5 = vals(86:102,3);

% partly cooled (e=0.2)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge02_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e02_q_d1 = vals(1:17,3);
e02_q_d1_5 = vals(18:34,3);
e02_q_d2 = vals(35:51,3);
e02_q_d3 = vals(52:68,3);
e02_q_d4 = vals(69:85,3);
e02_q_d5 = vals(86:102,3);

% partly cooled (e=0.3)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge03_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e03_q_d1 = vals(1:17,3);
e03_q_d1_5 = vals(18:34,3);
e03_q_d2 = vals(35:51,3);
e03_q_d3 = vals(52:68,3);
e03_q_d4 = vals(69:85,3);
e03_q_d5 = vals(86:102,3);

% partly cooled (e=0.4)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge04_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e04_q_d1 = vals(1:17,3);
e04_q_d1_5 = vals(18:34,3);
e04_q_d2 = vals(35:51,3);
e04_q_d3 = vals(52:68,3);
e04_q_d4 = vals(69:85,3);
e04_q_d5 = vals(86:102,3);

% partly cooled (e=0.5)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge05_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e05_q_d1 = vals(1:17,3);
e05_q_d1_5 = vals(18:34,3);
e05_q_d2 = vals(35:51,3);
e05_q_d3 = vals(52:68,3);
e05_q_d4 = vals(69:85,3);
e05_q_d5 = vals(86:102,3);


% partly cooled (e=0.6)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge06_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e06_q_d1 = vals(1:17,3);
e06_q_d1_5 = vals(18:34,3);
e06_q_d2 = vals(35:51,3);
e06_q_d3 = vals(52:68,3);
e06_q_d4 = vals(69:85,3);
e06_q_d5 = vals(86:102,3);

% partly cooled (e=0.7)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge07_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e07_q_d1 = vals(1:17,3);
e07_q_d1_5 = vals(18:34,3);
e07_q_d2 = vals(35:51,3);
e07_q_d3 = vals(52:68,3);
e07_q_d4 = vals(69:85,3);
e07_q_d5 = vals(86:102,3);

% partly cooled (e=0.8)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge08_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e08_q_d1 = vals(1:17,3);
e08_q_d1_5 = vals(18:34,3);
e08_q_d2 = vals(35:51,3);
e08_q_d3 = vals(52:68,3);
e08_q_d4 = vals(69:85,3);
e08_q_d5 = vals(86:102,3);

% partly cooled (e=0.9)
tab = importfile2("COMSOL\Varying h_tc\partly edge cooled\edge09_R50_d1-5.dat");
vals = sortrows(table2array(tab),2);
e09_q_d1 = vals(1:17,3);
e09_q_d1_5 = vals(18:34,3);
e09_q_d2 = vals(35:51,3);
e09_q_d3 = vals(52:68,3);
e09_q_d4 = vals(69:85,3);
e09_q_d5 = vals(86:102,3);

% edge + clamp cooled (e=1 , c = 5,10,15,20 mm )
tab = importfile3("COMSOL\Varying h_tc\clamp and edge cooled\clamp5_20_edge1_d2_4.dat");
vals = sortrows(table2array(tab),[2,3]);

htcc = vals(1:13,1);
vals_d2 = vals(1:52,:);
e1_c5_q_d2 = vals_d2(1:13,4);
e1_c10_q_d2 = vals_d2(14:26,4);
e1_c15_q_d2 = vals_d2(27:39,4);
e1_c20_q_d2 = vals_d2(40:52,4);

% edge + clamp cooled (e=1 , c = 1,2,3,4 mm )
tab = importfile3("COMSOL\Varying h_tc\clamp and edge cooled\clamp1_4_edge1_d235dat.dat");
vals = sortrows(table2array(tab),[2,3]);
htccc = vals(1:17,1);
vals_d2 = vals(1:68,:);
e1_c1_q_d2 = vals_d2(1:17,4);
e1_c2_q_d2 = vals_d2(18:34,4);
e1_c3_q_d2 = vals_d2(35:51,4);
e1_c4_q_d2 = vals_d2(52:68,4);

tab = importfile4("COMSOL\Varying h_tc\clamp and edge cooled\clamp01_edge1_d2.dat");
vals = table2array(tab);
e1_c01_q_d2 = vals(:,2);

% only clamp no edge (e=0, c = 1,2,3,4,5,10,15)
tab = importfile_c("COMSOL\Varying h_tc\clamp and edge cooled\clamp01_15_edge0_d2.dat");
vals = sortrows(table2array(tab),[2,1]);
htc_e0= vals(1:16,1);

e0_c01_q_d2= vals(1:16,3);
e0_c1_q_d2= vals(17:32,3);
e0_c2_q_d2= vals(33:48,3);
e0_c3_q_d2= vals(49:64,3);
e0_c4_q_d2= vals(65:80,3);
e0_c5_q_d2= vals(81:96,3);
e0_c10_q_d2= vals(97:112,3);
e0_c15_q_d2= vals(113:128,3);
%% Edge fully cooled 
% (T=80 K, R=50 mm)
% Varying thickness d, thermal contact conductance htc


figure;
%plot(htc,q_d1)
hold on
plot(htc,q_d2, 'k', LineWidth=1)
%plot(htc,q_d3)
%plot(htc,q_d4)
%plot(htc,q_d5)
xlim([50,500])
ylabel('q_{out} [W]')
xlabel('h_{tc} [W/m^2K]')
title('Net outward radiation vs. thermal contact')
%legend('d = 1 [mm]', 'd = 2 [mm]','d = 3 [mm]','d = 4 [mm]','d = 5 [mm]' )
%legend('boxoff')


%% fs sapphire comparison

figure;
plot(htc,q_d2, '--', 'Color',col.red, 'LineWidth', 1.7)
hold on
plot(htc_sa,sa_q_d2,'--','Color',col.blue, 'LineWidth', 1.7)
plot(htc,q_d5,'Color',col.red, 'LineWidth', 1.7)


plot(htc_sa,sa_q_d5,'Color',col.blue, 'LineWidth', 1.7)


xlim([40,200])
ylabel('Radiative heat [W]')
legend( '2 mm fused silica' ,'2 mm sapphire', '5 mm fused silica' , '5 mm sapphire' )
legend('boxoff')


%% partly edge-cooled (three-way mounting)

figure;
plot(htc,e07_q_d1)
hold on
plot(htc,e07_q_d2)
plot(htc,e07_q_d3)
plot(htc,e07_q_d4)
plot(htc,e07_q_d5)
xlim([50,1000])
ylabel('Radiative heat [W]')
xlabel('h_{tc} [W/m^2K]')
title('Net outward radiation vs. thermal contact')
legend('d = 1 [mm]', 'd = 2 [mm]','d = 3 [mm]','d = 4 [mm]','d = 5 [mm]' )
legend('boxoff')

%% same thickness (varying edge, and htc)
col.red   = [0.89, 0.21, 0.19];  
col.blue  = [0.27, 0.38, 0.89];  
col.gray1 = [0.2, 0.2, 0.2];  
col.gray2 = [0.4, 0.4, 0.4];     
col.gray3 = [0.6, 0.6, 0.6]; 
col.gray4 = [0.78, 0.78, 0.78]; 

figure;
plot(htc,e05_q_d2,'color', 'k', LineWidth=1.7)
hold on
plot(htc,e07_q_d2,'color', col.gray2, LineWidth=1.7)
plot(htc,e09_q_d2,'color', col.gray3, LineWidth=1.7)
plot(htc,q_d2,'color', col.gray4, LineWidth=1.7)

plot([0,1000],[0.138,0.138],'color', col.blue, LineWidth=1.5)
%yline(0.39, 'k', LineWidth=1) % lead to 5% of third shield's cooling power

xlim([50,500])
ylim([0.05,0.3])
ylabel('Radiative heat [W]')
xlabel('Thermal contact conductance [W/m^2K]')
%title('Net outward radiation vs. thermal contact')
legend('e = 0.5', 'e = 0.7','e = 0.9','e = 1', fontsize=10)
legend('boxoff')


%% same thickness, same edge (varying clamp and htc)
figure;
plot(htc,e1_c01_q_d2)
hold on
plot(htc,e1_c2_q_d2)
plot(htc,e1_c4_q_d2)
plot(htcc,e1_c15_q_d2)

yline(0.1383, 'k', LineWidth=1)

xlim([50,500])
ylim([0.05,0.3])
ylabel('Radiative heat [W]')
xlabel('h_{tc} [W/m^2K]')
title('Net outward radiation vs. thermal contact')
legend('c = 0 mm','c = 2 mm','c = 4 mm','c = 15 mm' )
legend('boxoff')


%% only clamp, no edge, d=2 (varying c and htc)
figure;

plot(htc_e0,e0_c2_q_d2,'color', 'k', LineWidth=1.7)
hold on
plot(htc_e0,e0_c3_q_d2,'color', col.gray2, LineWidth=1.7)
plot(htc_e0,e0_c5_q_d2,'color', col.gray3, LineWidth=1.7)
plot(htc_e0,e0_c15_q_d2,'color', col.gray4, LineWidth=1.7)

plot([0,1000],[0.138,0.138],'color', col.blue, LineWidth=1.5)

xlim([50,500])
ylim([0.05,0.3])
ylabel('Radiative heat [W]')
xlabel('h_{tc} [W/m^2K]')
%title('Net outward radiation vs. thermal contact')
legend('c = 2 mm','c = 3 mm','c = 5 mm','c = 15 mm', fontsize=10)
legend('boxoff')


%% functions

function val = importfile1(filename,dataLines)

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [6, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "  ";

% Specify column names and types
opts.VariableNames = ["Model", "Untitledmph"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Import the data
val = readtable(filename, opts);

end

function val2 = importfile2(filename, dataLines)

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [6, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "  ";

% Specify column names and types
opts.VariableNames = ["Model", "partly_edge_cooled_R50_modelmph", "VarName3"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Import the data
val2 = readtable(filename, opts);

end

function clamp520edge1d24 = importfile3(filename, dataLines)


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [6, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "  ";

% Specify column names and types
opts.VariableNames = ["Model", "clamp_cooled_Rover50_modelmph", "VarName3", "VarName4"];
opts.VariableTypes = ["double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Import the data
clamp520edge1d24 = readtable(filename, opts);

end


function clamp01edge1d2 = importfile4(filename, dataLines)


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [6, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "  ";

% Specify column names and types
opts.VariableNames = ["Model", "clamp_cooled_Rover50_modelmph"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Import the data
clamp01edge1d2 = readtable(filename, opts);

end

function saedgecooledR50 = importfile_sa(filename, dataLines)


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [6, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "  ";

% Specify column names and types
opts.VariableNames = ["Model", "edge_cooled_R50_modelmph", "VarName3"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Import the data
saedgecooledR50 = readtable(filename, opts);

end

function clamp0115edge0d2 = importfile_c(filename, dataLines)

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [6, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "  ";

% Specify column names and types
opts.VariableNames = ["Model", "clamp_cooled_Rover50_modelmph", "VarName3"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Import the data
clamp0115edge0d2 = readtable(filename, opts);

end