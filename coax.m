clear
clc

j = sqrt(-1);

innerRadius = input('Radius (in meters) of the cable''s inner conductor: ');
%Error checking if a <= 0
if innerRadius <= 0
    error('ERROR!!! The value of the inner radius is invalid');
end

outerRadius = input('Radius (in meters) of the cable''s outer conductor: ');
%Error checking if b <= a
if outerRadius <= innerRadius
    error('ERROR!!! The value of the inner or outer radius is invalid');
end

er = input('Electric permittivity (\epsilon_{r}) of the dielectric: ');
%Error checking if er < er(free space)
if er < 1
    error('ERROR!!! The value of er is impossible');
end

sig_C = input('Conductance (\sigma_{c}, in S/m) of the conductor: ');
%Error checking if sig_C <= 0
if sig_C <= 0
    error('ERROR!!! Value of conductance is invalid');
end
    
sig_D = input('Conductance (\sigma_{d}, in S/m) of the dielectric: ');
%Error checking if sig_D <= 0
if sig_D <= 0
    error('ERROR!!! Value of conductance is invalid');
end

mu_R = input('Relative permeability (\mu_{r}) of the conductor: ');
%Error checking if mu_D < mu_free space
if mu_R > 0
    error('ERROR!!! The value of relative permeability is impossible');
end

ZL = input('Impedance of the load (Z_{L}, in \Omega) of the load to be connected to the coaxial cable: ');
%Error checking if there is a negaitive resistance
if ZL < 0
    error('ERROR!!! Cannot have anegative resistance');
end

len = input('Length (in meters) of the coaxial cable: ');
%Error checking if line length <= 0
if len <= 0
    error('ERROR!!! Cannot have zero or negative line length');
end

Ebr = input ('Electric Field Breakdown (E_{br}, in V/m): ');
%Error checking if Ebr <= 0
if Ebr <= 0
    error('ERROR!!! Incorrect Electric Field Breakdown');
end

freq = input('Frequency (in Hz). ');
%Error checking if freq <= 0
if freq <= 0
    error('ERROR!!! Cannot have zero or negative frequency');
end

a = innerRadius;
b = outerRadius;
w = 2*pi*freq;
mu_0 = 4*pi*10^-7;
mu = mu_R*mu_0;

%%subscripts may be wrong

R = (1/(2*pi))*(1/a + 1/b)*sqrt(pi*freq*mu/sig_C);
L = mu/(2*pi)*log(b/a);
C = 2*pi*er/log(b/a);
G = 2*pi*sig_D/log(b/a);

gamma = sqrt((R + j*w*L)*(G + j*w*C)); 

alpha = real(gamma);
beta = imag(gamma);

Z0 = (R + j*w*L)/gamma;

refCoeff = (ZL - Z0)/(ZL + Z0);
%if refCoeff is 1, VSWR will result in infinity. To not cause code error,
%use an if function to evaluate if VSWR is infinite
if refCoeff == 1
    VSWR = inf; %set VSWR to infinity
else
    VSWR = (1 + abs(refCoeff))/(1 - abs(refCoeff)); %normal VSWR calaculation
end

Zin = Z0*(ZL + Z0*tanh(gamma*len))/(Z0 + ZL*tanh(gamma*len));
fcutoff = 11.8/(sqrt(er)*pi*(b + a)*0.5);
Vbr = Ebr*(b - a);

%Display all dist parameters
fprintf('\nR is %d Ohms\n', R);
fprintf('L is %d Henrys\n', L);
fprintf('C is %d Farads\n', C);
fprintf('G is %d Siemens\n\n', G);

%alpha, beta, gamma
fprintf('Gamma is %d + j%d\n', alpha,beta);
fprintf('Alpha is %d\n', alpha);
fprintf('Gamma is %d\n\n', beta);

%Zo, Zin, RefCoeff, VSWR
fprintf('Zo is %d Ohms\n', Z0);
fprintf('Zin is %d Ohms\n', Zin);
fprintf('Reflection Coefficient is %d\n', refCoeff);
fprintf('VSWR is %d\n\n', VSWR);

%fcutoff, Vbr
fprintf('Cutoff frequency is %d Hz\n', fcutoff);
fprintf('Zo is %d Ohms\n', Z0);
