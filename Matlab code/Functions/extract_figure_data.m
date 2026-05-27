%% -------- Extract Data From Log-Log Plot Image --------
% Load the PSD/ASD image
img = imread('etpf_a_asd.jpg');   % rename if needed
figure; imshow(img); hold on;
title('Click two X-axis tick marks (left→right)');

%% --- 1. Calibrate X-axis (log10 scale) ---
% Click two known tick positions on x-axis
[xp, yp] = ginput(2);

% Enter the *actual* values of these ticks (e.g. 1, 10, 100, 1000)
xval1 = input('Enter real X value of first point (Hz): ');
xval2 = input('Enter real X value of second point (Hz): ');

% Convert to log10
lx1 = log10(xval1);
lx2 = log10(xval2);

% Compute pixel → log(x) affine transform
ax = (lx2 - lx1) / (xp(2) - xp(1));
bx = lx1 - ax * xp(1);

%% --- 2. Calibrate Y-axis (log10 scale) ---
title('Click two Y-axis tick marks (bottom→top)');
[xp_y, yp_y] = ginput(2);

yval1 = input('Enter real Y value of first point: ');
yval2 = input('Enter real Y value of second point: ');

% Convert to log10
ly1 = log10(yval1);
ly2 = log10(yval2);

% Pixel → log(y) transform
ay = (ly2 - ly1) / (yp_y(2) - yp_y(1));
by = ly1 - ay * yp_y(1);

%% --- 3. Digitize the curve ---
title('Click points along the BLACK line (press Enter when done)');
[xc, yc] = ginput();   % unlimited clicks

%% --- 4. Convert pixel → real data (inverse log10 transform) ---
f = 10.^(ax * xc + bx);   % frequency in Hz
d = 10.^(ay * yc + by);   % displacement in m/√Hz

%% --- 5. Plot results ---
figure;
loglog(f, d, 'k.-', 'LineWidth', 1.3);
grid on;
xlabel('Frequency [Hz]');
ylabel('Displacement [m/\surd Hz]');
title('Extracted ETpathfinder Sensitivity (Black Curve)');

%% Save to file
save('ETpathfinder_extracted.mat', 'f', 'd');
%% Smooth data
lx = log10(f);
ly = log10(d);
ly_s = smooth(lx, ly, 0.2, 'loess');
d_s = 10.^ly_s;
d_smooth = [d(1); d_s];
f_smooth = [f(1);f];
save('ETpathfinder_extracted_smooth.mat', 'f_smooth', 'd_smooth');
%%
figure;
loglog(f_smooth, d_smooth, 'k-', 'LineWidth', 1.3);
%grid on;
xlabel('Frequency [Hz]');
ylabel('Displacement [m/\surd Hz]');
%title('Design Sensitivity of ETpathfinder-A');
xlim([1,1e4]);ylim([1e-21,1e-15]);
