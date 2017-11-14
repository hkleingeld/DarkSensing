clear all
H = 1.19;          %hight of the light and PD (located at (0,0,H)


%       Overview                Notes: Car should always drive from left to
%                                      right (-x to x). Yloc should always
%                                      be positive.                                            
%  ^|   
%  ||      
%  Y|        
%   |          Xloc      
%   |<------------------->           
%   |         ___________                       ---> = FrontNorm = [1,0,0] 
%   |        |    CarL   |                      <--- = BackNorm  = [-1,0,0]
%   |     -->|           |CarW                    |
%   |     |  |___________|                        |  = SideNorm  = [0,-1,0]
%   | Yloc|                                       v
%___|_____|____________________________________
%  0,0 (directly under light)       x-axile ->
%
%   Xloc = distance on X-axis in meters to front of the car.
%   Yloc = distance on y-axis in meters to center of the car.
%   0,0  = Coordinate of the light post, its H meters high.

CarW = 0.24; %Lenght of the object
CarL = 0.65; %Whidth of the object
CarH = 0.42; %Hight of the object

%objRefl = 1; %how much of the light is NOT converted to heat on impact.
objRefl = 0.75; %paper
%objRefl = 0.7; %polished aluminum
%objRefl = 0.65; %Paper


s = 150;        %shininess factor, amount of light that is NOT converted to light on impact
%floorRefl = 1;  
floorRefl = 0.375; %EWI Floor (calculated)
%floorRefl = 0.75;  %paper
%floorRefl = 0.11; %Aged asphalt
%floorRefl = 0.85; %Snow


FOV = 120/180*pi; %80 degrees in radians

halfconeapex = (35.4/2*pi)/180; %Angle at Half Power in radiance
m = -1/log2(cos(halfconeapex)); %some index describing the radiation pattern
lumI = 290;
total = 0;
a = 0;
b = 0;
c = 0;
d = 0;
e = 0;
stepsize = 0.05;

for(Yloc = 0) %should always be bigger than 0.5 CarW for shaddows to work properly!
    for(Xloc = CarL:0.05:CarL+0.5) %should always be bigger or euqal to CarL for shaddows to work properly!

%Object:
%Yloc = 0; %Y coordinate of the ojbect, should only be positive!
%Xloc = 0;

%vectors used for angle calculations
NormPD = [0,0,-1];
NormLight = [0,0,-1];
NormTop = [0,0,1];
NormFront =[1,0,0];
NormBack =[-1,0,0];
NormSide =[0,-1,0];

%Windshield = cross([Xloc,Yloc,0] - [Xloc + CarB,Yloc,CarH] , [Xloc,Yloc,0] - [Xloc,Yloc+1,0]);
%NormWindshield = Windshield / norm(Windshield);

%For what X,Y and Z should these the reflections of the object be
%calculated?
TopReflection = @(x,y) (x>Xloc-CarL) * (x<Xloc) * (y > Yloc-CarW/2) * (y < Yloc+CarW/2) *objRefl;
SideReflection = @(x,z) (x<Xloc) * (x>Xloc-CarL) * (z>0) * (z<CarH) * (Yloc-0.5*CarW>0) *objRefl;
BackReflection = @(y,z) (y>Yloc-0.5*CarW) * (y<Yloc+0.5*CarW) * (z>0) * (z<CarH) * (Xloc-CarL>0) *objRefl;
FrontReflection= @(y,z) (y>Yloc-0.5*CarW) * (y<Yloc+0.5*CarW) * (z>0) * (z<CarH) * (Xloc<0) *objRefl;


xborder1 = CarH*Xloc/(H-CarH) + Xloc;
yborder1 = H*(Yloc+0.5*CarW)/(H-CarH)
xr = (Yloc-CarW*0.5)/Xloc; %dy/dx
yr = (Xloc-CarL)/(Yloc+0.5*CarW); %dy/dx

if(Xloc ~= CarL/2)
    if(Yloc ~= 0)
        ObjShaddow= @(x,y) (y > x*xr) * (x > y*yr) * (x < xborder1) * (y > Yloc-0.5*CarW) * (y < yborder1) * (x > Xloc-CarL);
    else
        ObjShaddow= @(x,y)  (x > y*yr) * (x > -y*yr) * (x < xborder1) * (y < yborder1) * (y > -yborder1) * (x > Xloc-CarL);
    end
else
    if(Yloc ~= 0)
        ObjShaddow= @(x,y) (x < xborder1) * (x > -xborder1) * (y < yborder1) * (y > Yloc-0.5*CarW);
    else
        ObjShaddow= @(x,y) (x < xborder1) * (x > -xborder1) * (y < yborder1) * (y > -yborder1);
    end
end
dist= @(x,y,z) sqrt(x.*x+y.*y+z.*z);
COSinvalshoek = @(x,y,z,n1,n2,n3) dot([x y z]/dist(x,y,z), [n1 n2 n3]/dist(n1,n2,n3));
COSuitvalshoek = @(x,y,z,n1,n2,n3) COSinvalshoek(x,y,z,n1,n2,n3);

COSinvalshoek_= @(v1,v2) dot(v1/norm(v1),v2/norm(v2));
COSuitvalshoek_= @(v1,v2) COSinvalshoek_(v1,v2);

R = @(v1,v2) 2 .* dot(v1/norm(v1),v2/norm(v2)) * (v2/norm(v2)) - (v1/norm(v1));

%I = I0 * cos(phi)^m
I = @(x,y,z) lumI .* ((m+1)/(2*pi)) .* COSuitvalshoek(x,y,-z,-0.087/2,0,-1).^m;
I_= @(x,y) I(x,y,H);

Ehor = @(x,y) I(x,y,H) * COSinvalshoek(0,0,1,-x,-y,H) / dist(x,y,H)^2;
Ehor_ = @(x) Ehor(x,0);
%L1= (m+1)/(2*pi*d^2) * cos(uitvalshoek)
Lamb =@(x,y,z,v1,v2,v3)  (1/pi) * COSuitvalshoek(-x,-y,z,v1,v2,v3);
Spec =@(x,y,z,n1,s) ((s+1)/(2*pi)) * COSinvalshoek_(R([-x -y z],n1),[-x -y z]);
    
Lamb_ = @(x,y) Lamb(x,y,1,0,0,1);
Spec_ = @(x,y) Spec(x, y, 1,[0 0 1],10);

%phong = @(x,y,z,v1,v2,v3,rd,s) I(x,y,z) * dot([-x,-y,z],[v1,v2,v3]) * (rd * Lamb(x,y,z,v1,v2,v3) + (1-rd) * Spec(x,y,z,v1,v2,v3,s))/norm([x,y,z])^2;
phong = @(x,y,z,v1,v2,v3,rd,s) COSinvalshoek(-x,-y,z,v1,v2,v3) * (rd * Lamb(x,y,z,v1,v2,v3) + (1-rd) * Spec(x,y,z,[v1 v2 v3],20))/norm([x,y,z])^2;

%PD = 1/d^2 * cos(invalshoek @PD)
rec = @(x,y,z) (acos(dot(NormPD,[x,y,-z]/norm([x,y,-z])))/FOV) < 1;
PD =@(x,y,z) 1/dist(x,y,z)^2 * COSinvalshoek(x,y,-z,0,0,-1); %* rec(x,y,z);
PD_=@(x,y) PD(x,y,1);

NoObj = @(x,y)  I(x,y,H) * phong(x,y,H,NormTop(1),NormTop(2),NormTop(3),1,1) * PD(x,y,H) * floorRefl * ~ObjShaddow(x,y);
ObjTop = @(x,y) I(x,y,H-CarH) * phong(x,y,H-CarH,NormTop(1),NormTop(2),NormTop(3),1,1) * PD(x,y,H-CarH) * TopReflection(x,y);
ObjSide= @(x,z) I(x,Yloc-0.5*CarW,H-z) * phong(x,Yloc-0.5*CarW,H-z,NormSide(1),NormSide(2),NormSide(3),1,1) * PD(x,Yloc-0.5*CarW,H-z) * SideReflection(x,z);
ObjBack= @(y,z) I(Xloc-CarL,y,H-z) * phong(Xloc-CarL,y,H-z,NormBack(1),NormBack(2),NormBack(3),1,1) * PD(Xloc-CarL,y,H-z) * BackReflection(y,z);
%ObjFront=@(y,z) I(Xloc+CarL,y,z) * phong(Xloc,y,z,NormFront(1),NormFront(2),NormFront(3),1,1) * PD(Xloc+CarL,y,z) * FrontReflection(y,z);

a= [a NumericIntegration_(NoObj,-3,3,-3,3,stepsize)];
b= [b NumericIntegration_(ObjTop,-3,3,-3,3,stepsize)];
c= [c NumericIntegration_(ObjSide,-H,H,0,CarH+stepsize*10,stepsize)]; %object is never going to be in the ground and higher than CarH
d= [d NumericIntegration_(ObjBack,-1,1,0,CarH+0.5,stepsize)]; %object is never going to be in the ground and higher than CarH
%e= [e NumericIntegration(ObjFront,-1,1,0,CarH+0.5,0.01)]; %object is never going to be in the ground and higher than CarH
%a+b+c+d+e
c
    end
end

a(1) = [];
b(1) = [];
c(1) = [];
d(1) = [];
e(1) = [];


%a calculation becomes nan if the exit angle > 90 degrees (impossible).
%This happens only if a part of the object is on the shaddow side
a(isnan(a)) = 0;
b(isnan(b)) = 0;
c(isnan(c)) = 0;
d(isnan(d)) = 0;
%e(isnan(e)) = 0;

tot = a+b+d;
plot(0:0.05:0.5,tot,'LineWidth',2,'DisplayName', 'Calculated reflection')

hold on

% measured reflections 
%plot(0:0.05:0.5,[47 45 43 42 40 40 39 39 39 38.5 38],'LineWidth',2,'DisplayName', 'Measured reflection')  %@1.19 cm
%plot(0:0.05:0.5,[69 64 62 58 58 58 54 53 51 51 51],'LineWidth',2,'DisplayName', 'Measured reflection')    %@1m
plot([0 0.1 0.2 0.3 0.4 0.5] ,[34 27 23 22 21 21],'LineWidth',2,'DisplayName', 'Measured reflection')
xlabel('Box displacement (m)')
ylabel('Perceived light (lx)')
title('Model verification floor (\alpha = 0.375)')
legend('show')
print('ModelVerificationResults_floor.png','-dpng')
% measured radiation pattern
%  super = ...
%  [485 520 463 386 294 192; ...
%  537 578 527 407 331 223; ...
%  588 646 564 444 318 338; ...
%  631 675 588 455 336 245; ...
%  624 663 585 461 333 235; ...
%  589 634 564 457 309 235; ...
%  482 570 530 438 0 0; ...
%  443 500 473 386 0 0; ...
%  339 400 385 325 0 0; ...
%  235 293 282 233 0 0; ...
%  169 196 194 178 0 0; ...
%  119 150 140 115 0 0]
%  
%  xaxis = -0.09:0.09:4*0.09;
%  yaxis = -1*0.04:0.04:10*0.04;
%  mesh(xaxis,yaxis,super)
%  hold on
%  fmesh(Ehor,[0 1  0 1 ])
%  xlabel('left right')
%  ylabel('y')
 