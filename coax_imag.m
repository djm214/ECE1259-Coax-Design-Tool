clear
clc

j = sqrt(-1);

conductorMaterial = lower(input('Conductor Material: ','s'));

switch conductorMaterial
    case 'aluminum'
        sig_C = 38e6;
        mu_R = 1.00002;
    
    case 'carbon'
        sig_C = 30000;
        mu_R = 1;
    
    case 'copper'
        sig_C = 58e6;
        mu_R = 0.999991;

    case 'gold'
        sig_C = 41000000;
        mu_R = 0.99986;
    
    case 'graphite'
        sig_C = 70000;
        mu_R = 1;

    case 'iron (99.8%)'
        sig_C = 10e6;
        mu_R = 5000;

    case 'iron (99.96%)'
        sig_C = 10e6;
        mu_R = 280000;
    
    case 'lead'
        sig_C = 5e6;
        mu_R = 1;
   
    case 'nichrome'
        sig_C = 1e6;
        mu_R = 1;
    
    case 'nickel'
        sig_C = 15e6;
        mu_R = 600;
    
    case 'silver'
        sig_C = 62e6;
        mu_R = 0.99998;
    
    case 'solder'
        sig_C = 7e6;
        mu_R = 1;
    
    case 'stainless steel'
        sig_C = 1.1e6;
        mu_R = 1;
    
    case 'tin'
        sig_C = 8.8e6;
        mu_R = 1;
    
    case 'tungsten'
        sig_C = 1.8e7;
        mu_R = 1;
    
    otherwise
        printf("Conductor Material Was Not Found in the Database! Please Enter Custom Values...")
        sig_C = input('Conductance (\sigma_{c}, in S/m) of the conductor: ');
        mu_R = input('Relative permeability (\mu_{r}) of the conductor: ');

end

dielectricMaterial = lower(input('Dielectric Material: ','s'));

switch dielectricMaterial
    case 'air'
        er = 1.0005;
        Ebr = 3e6;
        sig_D = 3e-15;
    
    case 'alumina'
        er = 9.9;
        Ebr = 8.3e3;
        sig_D = 10e-14;

    case 'barium titanate'
        er = 1200;
        Ebr = 7.5e6;
        sig_D = 0; %//Could not find

    case 'glass'
        er = 10;
        Ebr = 30e6;
        sig_D = 1e-12;
    
    case 'ice'
        er = 4.2;
        Ebr = 65e6; %//Could not find
        sig_D = 10e-9;

    case 'mica'
        er = 5.4;
        Ebr = 200e6;
        sig_D = 1e-15;

    case 'polyethylene'
        er = 2.26;
        Ebr = 47e6;
        sig_D = 1e-16;
    
    case 'polystyrene'
        er = 2.56;
        Ebr = 20e6;
        sig_D = 1e-17;
   
    case 'quartz'
        er = 3.8;
        Ebr = 30e6;
        sig_D = 1e-17;
    
    case 'silicon'
        er = 11.8;
        Ebr = 370;
        sig_D = 0.00044;
    
    case 'soil'
        er = 3.5;
        Ebr = 0;
        sig_D = 0.002;
    
    case 'teflon'
        er = 2.1;
        Ebr = 60e6;
        sig_D = 1e-15;
    
    case 'water'
        er = 81;
        Ebr = 65e6; 
        sig_D = 0.0001;
    
    case 'seawater'
        er = 72;
        Ebr = 0; %//Could not find
        sig_D = 5;
    
    otherwise
        printf("Dielectric Material Was Not Found in the Database! Please Enter Custom Values...")
        er = input('Electric permittivity (\epsilon_{r}) of the dielectric: ');
        Ebr = input ('Electric Field Breakdown (E_{br}, in V/m): ');
        sig_D = input('Conductance (\sigma_{d}, in S/m) of the dielectric: ');

end

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

%er = input('Electric permittivity (\epsilon_{r}) of the dielectric: ');
%Error checking if er < er(free space)
if er < 1
    error('ERROR!!! The value of er is impossible');
end

%sig_C = input('Conductance (\sigma_{c}, in S/m) of the conductor: ');
%Error checking if sig_C <= 0
if sig_C <= 0
    error('ERROR!!! Value of conductance is invalid');
end
    
%sig_D = input('Conductance (\sigma_{d}, in S/m) of the dielectric: ');
%Error checking if sig_D <= 0
if sig_D <= 0
    error('ERROR!!! Value of conductance is invalid');
end

%mu_R = input('Relative permeability (\mu_{r}) of the conductor: ');
%Error checking if mu_D < mu_free space
if mu_R < 0
    error('ERROR!!! The value of relative permeability is impossible');
end

ZL_R = input('Real impedance of the load (R_{L}, in \Omega) of the load to be connected to the coaxial cable: ');
%Error checking if there is a negaitive resistance
if ZL_R < 0
    error('ERROR!!! Cannot have a negative resistance');
end
ZL_I = j*input('Imaginary impedance of the load (X_{L}, in \Omega) of the load to be connected to the coaxial cable: ');

ZL = ZL_R + ZL_I; %real and imaginary parts combined

len = input('Length (in meters) of the coaxial cable: ');
%Error checking if line length <= 0
if len <= 0
    error('ERROR!!! Cannot have zero or negative line length');
end

%Ebr = input ('Electric Field Breakdown (E_{br}, in V/m): ');
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
e_0 = 8.85e-12;

%%subscripts may be wrong

R = (1/(2*pi))*(1/a + 1/b)*sqrt(pi*freq*mu/sig_C);
L = mu/(2*pi)*log(b/a);
C = 2*pi*er*e_0/log(b/a);
G = 2*pi*sig_D/log(b/a);

%{
This was used for testing the characteristic impedance, gamma, input impedance,
and reflection coefficient via direct control of distributed parameters

Q = lower(input('is RLCG know? Y/N',"s"));
if Q=='y'
    R=input('Put in R: ');
    L=input('Put in L: ');
    C=input('Put in C: ');
    G=input('Put in G: ');
elseif Q=='n'
else
    error('Innapropriate entry');
end
%}

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
fprintf('Beta is %d\n\n', beta);

%Zo, Zin, RefCoeff, VSWR
fprintf('Zo is %d + j(%d) Ohms\n', Z0,imag(Z0));
fprintf('Zin is %d with angle %d Ohms\n', abs(Zin),(180/3.14)*angle(Zin));
fprintf('Reflection Coefficient is %d with angle %d\n', abs(refCoeff),(180/3.14)*angle(refCoeff));
fprintf('VSWR is %d\n\n', VSWR);

%fcutoff, Vbr
fprintf('Cutoff frequency is %d Hz\n', fcutoff);
fprintf('Vbr is %d Volts\n', Vbr);
