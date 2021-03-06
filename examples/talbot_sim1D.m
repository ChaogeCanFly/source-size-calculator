% simple calculation of Talbot-carpet for "paralell" (set r > 1e6) and
% "cone-beam" impinging wave-front for a pure phase grating
%--------------------------------------------------------------------------
% Name: Talbot-simulation
% Date: 2013-12-13
% Author: Goran Lovric
%--------------------------------------------------------------------------
close all;clc;clear;
addpath('../classes');
addpath('../classes/xray-interaction-constants');
a = simulation;               % load classes for calculation
%--------------------------------------------------------------------------
% 1.) PATHS (m-files & src-files) and CONSTANTS
%--------------------------------------------------------------------------
a.a       = 6.84e-6;               % [m] grating period
a.R       = 25;%1e11;              % [m] radius of incidient wave curvature
a.E       = 21;                    % [keV]
a.sigma   = 53e-6;                 % TOMCAT vertical src size

a.periods = 8;                     % grating-size (in terms of periods)
a.N       = 2^13;                  % number of particles --> 2^n !!!
a.psize   = 0.38e-6;               % [m] px size of detector

% Grating parameters
% a.h       = 3.39e-6;             % height of grating structure
a.alpha   = 4.2;                   % angle of bump's slope
a.dc      = sqrt(0.285);           % duty cycle

a.z = linspace(0,a.D_def*2,501);   % [m] propagation distance in meters

%--------------------------------------------------------------------------
% 2.) GRID creation
%--------------------------------------------------------------------------
gra = a.talbotGrid1D;

%--------------------------------------------------------------------------
% 3.) Wave field @ Grid and Plot
%--------------------------------------------------------------------------
% a.calcRefracAbsorb('Au',17);
a.phShift = pi;
a.absorb  = 0;
f = a.waveFieldGrat(gra);
fig1=figure(1);
    set(fig1,'Position',[100 600 1024 400],'Color','white')
    area(a.y0,gra);colormap summer;
    hold on;
    plot(a.y0,angle(f),'ro');
    plot(a.y0,abs(f).^2,'b*');
    line([0 a.a],[1.02 1.02],'Color','g','LineWidth',3);
    legend('grating','phase shift','absorbtion')
    hold off
    title('grating')

%--------------------------------------------------------------------------
% 4.) Propagation along z-axis
%--------------------------------------------------------------------------

for ii=1:length(a.z)
    calc = a.waveFieldPropMutual(a.z(ii),f);
    crop = a.scale2Det(calc);   % scale to detector resolution
    pwav(:,ii) = crop;
    %--- Plot ---
    if (mod(ii,100) == 0)
        fig2=figure(2);
        set(fig2,'Position',[100 100 1024 400],'Color','white')
        sb1 = subplot (1,2,1);
        plot(calc);
        title('vertical mean')
    end
end

sb2 = subplot (1,2,2);
figure(2)
imagesc(a.z*1000,[],pwav);
colormap(gray);
line(a.D_R.*1e3.*[1 1],[0 a.N],'Color','r','LineWidth',2);
line(a.D_T.*1e3.*[1 1],[0 a.N],'Color','r','LineWidth',2);
line(a.D_defr.*1e3.*[1 1],[0 a.N],'Color','b','LineWidth',2);
line(a.D_def.*1e3.*[1 1],[0 a.N],'Color','b','LineWidth',2);
xlabel('propagation distance [mm]');
legend('D_R','D_T','D_R (defocussed)','D_T (defocussed)');