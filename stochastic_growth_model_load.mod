% Econ:801 Macroeconomic Theory
% HW05 24 Assignment Submission by Shirmeen Aslam (11365964)
% Due Date: Nov 08 2024

% To run using DYNARE, use the following command in MATLAB
% dynare stochastic_growth_model_SSA

% File: stochastic_growth_model_SSA.mod
var c k n y z i;
varexo e;

parameters beta delta sigma alpha rho sigeps cbar kbar ybar nbar;

% Parameters
beta = 0.95;              % Initial discount factor
delta = 0.1;              % Depreciation rate
sigma = 1.5;              % Risk aversion (CRRA)
alpha = 0.33;             % Capital share
rho = 0.95;               % AR(1) for productivity shock
sigeps = 0.01;            % Standard deviation of the shock

cbar = (1 - alpha) * kbar^alpha; % Steady-state consumption
kbar = (alpha / (1 / beta - 1 + delta))^(1 / (1 - alpha)); % Steady-state capital
ybar = kbar^alpha;        % Steady-state output
nbar = 1;                 % Steady-state labor

% Model equations
phi_kk = (1 / beta - 1 + delta) / alpha;
phi_ck = ((1 / beta) - phi_kk) * (kbar / cbar);

phi_kz = (beta * rho * (1 - alpha) * kbar / cbar) / (1 + beta * (1 - alpha));
phi_cz = (ybar / cbar) - (kbar / cbar) * phi_kz;

% Household's Euler equation
c = beta * c(+1) * (1 - alpha) * k(+1)^alpha * n(+1)^(1 - alpha);

% Capital accumulation
k = (1 - delta) * k(-1) + i;

% Production function
y = z * k^alpha * n^(1 - alpha);

% Labor supply (as given, no labor choice in the steady state for simplicity)
n = 1;

% AR(1) process for productivity shock
z = rho * z(-1) + e;

% Investment equation
i = k - (1 - delta) * k(-1);

% Shock process for e
e = rho * e(-1) + sigeps * epsilon;

% Calibration and steady state computations
initval;
  z = 1;   % Productivity at steady state
  k = kbar; % Capital at steady state
  c = cbar; % Consumption at steady state
  n = nbar; % Labor supply at steady state
  y = ybar; % Output at steady state
  i = 0;    % Investment at steady state
end;

% Set options for the simulation
stoch_simul(order=1,irf=50,periods=250);

% Option to change beta for the second part of the problem
% Change the discount factor and run the simulation again
beta = 0.97;

% Recompute steady state
kbar = (alpha / (1 / beta - 1 + delta))^(1 / (1 - alpha));
cbar = (1 - alpha) * kbar^alpha;

% Re-run the simulation with updated beta
stoch_simul(order=1,irf=50,periods=250);
