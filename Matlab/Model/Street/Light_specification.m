clear all
H = 7;          %hight of the light and PD (located at (0,0,H)

s = 150;        %shininess factor
floorRefl = 1;  %amount of light that is NOT converted to light on impact
FOV = 120/180*pi; %80 degrees in radians
step = 0.1;

halfconeapex = (60*pi)/180; %Angle at Half Power in radiance
m = -1/log2(cos(halfconeapex)); %some index describing the radiation pattern
lumI = 800;


dist= @(x,y,z) sqrt(x.*x+y.*y+z.*z);
COSinvalshoek = @(x,y,z,n1,n2,n3) dot([x y z]./dist(x,y,z), [n1 n2 n3]./dist(n1,n2,n3));
COSuitvalshoek = @(x,y,z,n1,n2,n3) COSinvalshoek(x,y,z,n1,n2,n3);

%I = I0 * cos(phi)^m
I = @(x,y,z) lumI .* ((m+1)/(2*pi)) .* COSuitvalshoek(x,y,-z,0,0,-1).^m;
I_= @(x,y) I(x,y,H);

Ehor = @(x,y,z) I(x,y,z) .* COSinvalshoek(0,0,1,-x,-y,z) / dist(x,y,z)^2;
Ehor_= @(x,y) Ehor(x,y,H);

MultipleLightPosts = @(x,y) Ehor(x-15,y,H) + Ehor(x-30,y,H) + Ehor(x,y,H) + Ehor(x-45,y,H) + Ehor(x+15,y,H);

[integral mean ratio] = NumericIntegration(MultipleLightPosts,0, 30, -2, 6,step);

mean = mean*100; %convert mean from lux/dm^2 to lux/m^2

mean % mean should be higher than 3 lx (Ehor mean)
ratio %ratio should be higher than 0.2 Uh
fmesh(MultipleLightPosts,[-5 35 -2 6])
title('Illumination pattern of the street model')
zlabel('E_h_o_r (lx)')
xlabel ('x-axis')
ylabel('y-axis')