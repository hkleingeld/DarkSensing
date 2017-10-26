clear all
H = 1;          %hight of the light and PD (located at (0,0,H)

CarW = 0.24; %Lenght of the object
CarL = 0.65; %Whidth of the object
CarH = 0.42; %Hight of the object

%objRefl = 1; %how much of the light is NOT converted to heat on impact.
objRefl = 0.75; %paper
%objRefl = 0.7; %polished aluminum
%objRefl = 0.65; %Paper

s = 150;        %shininess factor, amount of light that is NOT converted to light on impact
%floorRefl = 1;  
%floorRefl = 0.75*0.48; %EWI Floor (calculated)
floorRefl = 0.75;  %paper
%floorRefl = 0.11; %Aged asphalt
%floorRefl = 0.85; %Snow

halfconeapex = (35.4/2*pi)/180; %Angle at Half Power in radiance
m = -1/log2(cos(halfconeapex)); %some index describing the radiation pattern
lumI = 290;

dist= @(x,y,z) sqrt(x.*x+y.*y+z.*z);
COSinvalshoek = @(x,y,z,n1,n2,n3) dot([x y z]/dist(x,y,z), [n1 n2 n3]/dist(n1,n2,n3));
COSuitvalshoek = @(x,y,z,n1,n2,n3) COSinvalshoek(x,y,z,n1,n2,n3);

COSinvalshoek_= @(v1,v2) dot(v1/norm(v1),v2/norm(v2));
COSuitvalshoek_= @(v1,v2) COSinvalshoek_(v1,v2);

%I = I0 * cos(phi)^m
% Note that the light is tilted 5 degrees. This was found while comparing
% the patterns
I = @(x,y,z) lumI .* ((m+1)/(2*pi)) .* COSuitvalshoek(x,y,-z,-0.087/2,0,-1).^m;
I_= @(x,y) I(x,y,H);

Ehor = @(x,y) I(x,y,H) * COSinvalshoek(0,0,1,-x,-y,H) / dist(x,y,H)^2;
%Ehor_ = @(x) Ehor(x,0);

%Super is the measured illumination pattern
 super = ...
 [485 520 463 386 294 192; ...
 537 578 527 407 331 223; ...
 588 646 564 444 318 338; ...
 631 675 588 455 336 245; ...
 624 663 585 461 333 235; ...
 589 634 564 457 309 235; ...
 482 570 530 438 0 0; ...
 443 500 473 386 0 0; ...
 339 400 385 325 0 0; ...
 235 293 282 233 0 0; ...
 169 196 194 178 0 0; ...
 119 150 140 115 0 0]
 
 xaxis = -0.09:0.09:4*0.09;
 yaxis = -1*0.04:0.04:10*0.04;
 mesh(xaxis,yaxis,super)
 hold on
 
 %fmesh(Ehor,[0 1  0 1 ]) generates the calculated illumination pattern
 fmesh(Ehor,[0 1  0 1 ])
 xlabel('x-axis')
 ylabel('y-axis')
 zlabel('E_h_o_r(lx)')
 title('Measured and calculated illumination patterns overlapped')