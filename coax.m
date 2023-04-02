clear
clc

j = sqrt(-1);

innerRadius = input('Radius (in meters) of the cable''s inner conductor. ');
outerRadius = input('Radius (in meters) of the cable''s outer conductor. ');
er = input('Electric permittivity (\epsilon_{r}) of the dielectric. ');
sig_D = input('Conductance (\sigma_{d}, in S/m) of the dielectric. ');
mu_D = input('Permeability (\mu_{d}) of the conductor. ');
ZL = input('Impedance of the load (Z_{L}, in \Omega) of the laod to be connected to the coaxial cable. ');
len = input('Length (in meters) of the coaxial cable. ');
Ebr = input ('Electric Field Breakdown (E_{br}, in V/m). ');
freq = input('Frequency (in Hz). ');

a = innerRadius;
b = outerRadius;
w = 2*pi*freq;

%%subscripts may be wrong

R = (1/(2*pi))*(1/a + 1/b)*sqrt(pi*freq*mu_D/sig_D);
L = mu_D/(2*pi)*log(b/a);
C = 2*pi*er/log(b/a);
G = 2*pi*sig_D/log(b/a);

gamma = sqrt((R + j*w*L)*(G + j*w*C)); 

alpha = real(gamma);
beta = imag(gamma);

Z0 = (R + j*w*L)/gamma;

refCoeff = (ZL - Z0)/(ZL + Z0);
VSWR = (1 + abs(refCoeff))/(1 - abs(refCoeff));
Zin = Z0*(ZL + Z0*tanh(gamma*len))/(Z0 + ZL*tanh(gamma*len));
fcutoff = 11.8/(sqrt(er)*pi*(b + a)*0.5);
Vbr = Ebr*(b - a);

