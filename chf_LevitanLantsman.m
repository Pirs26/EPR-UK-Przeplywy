%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X-Core v2.0 developed by Piotr Darnowski - all rights reserved
% Critical heat flux CHF with Levitan and Lantsman
% Rev1 04-01-2025
% VERSION modified for Classes
% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1: G = m/A            % mass flux [kg/s/m2] 
% 2: p                  % pressure [bar]
% 3: xe                 % eqilibrium quality [-]
% 4: D                  % tube diameter [m]
% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1: q_cr			    - Critical Heat Flux [MW/m2]			      
% DEFAULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D is default
% MODES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% EXAMPLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chf_LevitanLantsman(3000,150,-0.15,0.007)
% XCore.ThermalHydrualics.CHF.chf_LevitanLantsman(3000,150,-0.15,0.007)
%REFERENCES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Anglart, 2019) THiNS  Book
% COMMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for 8 mm tubes
% VALIDITY:
% The correlation given by Eq. (4-138) is valid in ranges 29.4 < p < 196 [bar] and 750 < G < 5000 [kg m-2 s-1] and is
% accurate within ±15%. For correlation given by Eq. (4-139) the ranges are: 9.8 < p <
% 166.6 [bar] and 750 < G < 3000 [kg m-2 s-1], and the accuracy of xcr is within ±0.05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [q_cr] = chf_LevitanLantsman(G,p,xe,D) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q_cr = (10.3 - 7.8 * (p ./ 98) + 1.6 * (p / 98).^2).* ...
       ((G ./ 1000).^(1.2 * (0.25 * (p - 98) / 98 - xe))).* ...
       exp(-1.5 .* xe);

if (D ~= 0.008)
    q_cr = q_cr.*(((8/1000)/D).^0.5);
end