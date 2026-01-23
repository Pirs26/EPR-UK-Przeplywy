%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X-Core v2.0 developed by Piotr Darnowski - all rights reserved
% CHF implementation developed by Edgar Jonczyk 
% Critical heat flux CHF with W-3 correlation
% Rev0 31-12-2024
% TO BE REVIEWED
% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% varargin               = matlab variable inputs
% 1: G = in{1};          % mass flux [kg/m2/s]
% 2: Tsat = in{2};       % saturation temperature [C]
% 3: p = in{3};          % pressure [bar]
% 4: x_e = in{4};        % eqilibrium quality [-]
% 5: h_f = in{5};        % saturation enthalpy of liquid [kJ/kg]
% 6: h_in = in{6};       % inlet enthalpy [kJ/kg]
% 7: Dh  = in{7};        % hydraulic diameter [m]
% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1: q_cr			    - Critical Heat Flux [MW/m2]			      
% DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% EXAMPLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% q_cr = chf_W3(1500, 263.3, 50, -0.15, 1149, 1000, 0.008)
% XSteam('Tsat_p',50) =   263.9429
% XSteam('h_pT',50,263) = 1.1498e+03
% XCore.ThermalHydrualics.CHF.chf_W3(1500, 263.3, 50, -0.15, 1149, 1000, 0.008)
%REFERENCES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% see REFERENCES.m 
% (Todreas, 1991) % this form was used for uniform heat flux
% (Khan, 2023) https://nucet.pensoft.net/article/98452
% (Anglart, 2024) - different form! liekly error
% COMMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% based on term project by Edgar Jonczyk
% VALIDITY:
% p_MPa = Pressure in MPa (5.5 to 16) 
% x_e = Steam quality (–0.15 to 0.15) 
% G_i = Coolant mass flux in kg/m2s (1356 to 6800) OK.
% Dclad_1 = equivalent heated diameter in m (0.005 to 0.018)
% h_f = Saturated liquid enthalpy in kJ/kg 
% h_in = Inlet enthalpy in kJ/kg (>930)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [q_cr] = chf_W3(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num  = numel(varargin);
    in = varargin;
    G = in{1};          % mass flux [kg/m2/s]
    Tsat = in{2};       % saturation temperature [C]
    p = in{3};          % pressure [bar]
    x_e = in{4};        % eqilibrium quality [-]
    h_f = in{5};        % saturation enthalpy of liquid [kJ/kg]
    h_in = in{6};       % inlet enthalpy [kJ/kg]
    Dh  = in{7};        % hydraulic diameter [m]
    
    if (num < 7)
       error('Not enought input arguments');
    end
    
    p_MPa = p*0.1;                              %przeliczenie ciśnienia z [bar] na [MPa]

    q_cr = ((2.022 - 0.06238.*p_MPa) + (0.1722 - 0.01427.*p_MPa).* ...
    exp((18.177 - 0.5987.*p_MPa).*x_e)).* ...
    (0.1484 - 1.596.*x_e + 0.1729.*x_e.*(abs(x_e)).*2.326.*G + 3271).* ...
    (1.157 - 0.869.*x_e).*(0.2664 + 0.8357.*exp(-124.1.*Dh)).* ...
    (0.8258 + 0.0003413.*(h_f - h_in));

q_cr = q_cr./1000; %kW/m2->MW/m2

    % in EJ orginal correlation there was an error 0.5697, it is different
    % in 2011 version of the Todreas
    %q_cr = ((2.022 - 0.06238.*p_MPa) + (0.1722 - 0.01427.*p_MPa).*exp((18.177 - 0.5697.*p_MPa).*x_e)).*(0.1484 - 1.596.*x_e + 0.1729.*x_e.*(abs(x_e)).*2.326.*G_i + 3271).*(1.157 - 0.869.*x_e).*(0.2664 + 0.8357.*exp(-124.1.*Dclad_1)).*(0.8258 + 0.0003413.*(h_f - h_in));
% p_MPa = Pressure in MPa (5.5 to 16) OK.

