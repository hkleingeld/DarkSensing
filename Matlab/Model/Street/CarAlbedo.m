% An albedo can be estimated with the following setup:

%             Light source
%                  |
%                  |                E_lightsensor
%                  |            ../
%                  |         ../
%                  |      ../
%                  |   ../
%                  |../  
%__________________v_Ehor__________________
%//////////////////////////////////////////

% normal formula for light received at the lightsensor
% Ehor * diffuse refl * albedo / d^2 = Elightsensor
% 
% d^2 * Elightsensor = Ehor * diffuse refl * albedo
%
% Formula used for calculating albedo
% d^2 * Elightsensor /(Ehor * diffuse refl) = albedo

EhorMeasured = 50%lx - Ehor @ 0.5m = place holder
Lightsensor_black = 2; %= place holder
Lightsensor_silver = 2; %= place holder
Lightsensor_red = 2; %= place holder
d = 0.5;

dist= @(x,y,z) sqrt(x.*x+y.*y+z.*z);
COSinvalshoek = @(x,y,z,n1,n2,n3) dot([x y z]/dist(x,y,z), [n1 n2 n3]/dist(n1,n2,n3));
COSuitvalshoek = @(x,y,z,n1,n2,n3) COSinvalshoek(x,y,z,n1,n2,n3);

COSinvalshoek_= @(v1,v2) dot(v1/norm(v1),v2/norm(v2));
COSuitvalshoek_= @(v1,v2) COSinvalshoek_(v1,v2);

%L1= (m+1)/(2*pi*d^2) * cos(uitvalshoek)
Lamb =@(x,y,z,v1,v2,v3)  (1/pi) * COSuitvalshoek(-x,-y,z,v1,v2,v3);
Spec =@(x,y,z,n1,s) ((s+1)/(2*pi)) * COSinvalshoek_(R([-x -y z],n1),[-x -y z]);

%phong = @(x,y,z,v1,v2,v3,rd,s) I(x,y,z) * dot([-x,-y,z],[v1,v2,v3]) * (rd * Lamb(x,y,z,v1,v2,v3) + (1-rd) * Spec(x,y,z,v1,v2,v3,s))/norm([x,y,z])^2;
phong = @(x,y,z,v1,v2,v3,rd,s) COSinvalshoek(-x,-y,z,v1,v2,v3) * (rd * Lamb(x,y,z,v1,v2,v3) + (1-rd) * Spec(x,y,z,[v1 v2 v3],20))/norm([x,y,z])^2;

a1 = dist(0.5,0.5,0.5)^2 * Lightsensor_black / (EhorMeasured * phong(0.5,0.5,0.5,0,0,1,1,0))
a2 = dist(0.5,0.5,0.5)^2 * Lightsensor_red / (EhorMeasured * phong(0.5,0.5,0.5,0,0,1,1,0))
a3 = dist(0.5,0.5,0.5)^2 * Lightsensor_silver / (EhorMeasured * phong(0.5,0.5,0.5,0,0,1,1,0))