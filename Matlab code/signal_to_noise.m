clear; clc; close all;
%% Response
% Parameters
M = 3.29;       % mass (kg)
L = 0.4;        % length (m)
g = 9.81;       % gravity (m/s^2)

% natural frequency
w_n = sqrt(g/L);

% frequency vector (rad/s)
f = logspace(-1, 4, 2000);   % 1 Hz to 10 000 Hz
w = 2*pi*f;

% FRF: horizontal force -> horizontal displacement
HxF = 1 ./ ( M * (w_n^2 - w.^2) );   % complex if you add damping

% If you want to include small damping ratio zeta, uncomment:
% zeta = 0.01;
% HxF = 1 ./ ( M * (omega_n^2 - omega.^2 + 2i*zeta*omega_n.*omega) );

% Magnitude and phase
mag1 = abs(HxF);
phase1 = angle(HxF);


%% Response
M = 3.29;                % mass [kg]
s = tf('s');
H = -1/(M*s^2);         % free-mass transfer function

f = logspace(-1, 4, 2000);   % 1 Hz to 10 000 Hz
w = 2*pi*f;

[mag, pha] = bode(H, w);
mag2 = squeeze(mag);
pha2 = squeeze(pha);

figure;
subplot(2,1,1)
loglog(f, mag1, 'LineWidth', 1.2); grid on;
hold on
loglog(f, mag2,'--', 'LineWidth', 1.2); grid on;
xlabel('Frequency [Hz]'); ylabel('Magnitude [N/m]');
title('Force-to-displacement response');

subplot(2,1,2)
%semilogx(f, pha1, 'LineWidth', 1.2); grid on;
%hold on
semilogx(f, pha2, 'LineWidth', 1.2); grid on;
xlabel('Frequency [Hz]'); ylabel('Phase [deg]');
title('Bode Phase');

%% required power calculation


Lf  = 3e-18;    % [m/sqrt(Hz)]  target sensitivity ETpathfinder
SNR = 100;      % [-]           desired SNR
c   = 3e8;      % [m/s]         speed of light
Sf  = 8e-5;     % [m/N]         force to displacement response 
T   = 10;       % [s]           integration time

%required power [mW]
P = c/(2*Sf)*Lf*SNR/sqrt(T) *1000