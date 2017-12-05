clear all
H = 11;          %hight of the light and PD (located at (0,0,H)


%       Overview                Notes: Obj should always move from left to
%                                      right (-x to x). Yloc should always
%                                      be positive.                                            
%  ^|   
%  ||      
%  Y|        
%   |          Xloc      
%   |<------------------->           
%   |         ___________                       ---> = FrontNorm = [1,0,0] 
%   |        |    ObjL   |                      <--- = BackNorm  = [-1,0,0]
%   |     -->|           |ObjW                    |
%   |     |  |___________|                        |  = SideNorm  = [0,-1,0]
%   | Yloc|                                       v
%___|_____|____________________________________
%  0,0 (lightpost)                  x-axile ->
%
%   Xloc = distance on X-axis in meters to front of the car.
%   Yloc = distance on y-axis in meters to center of the car.
%   0,0  = Coordinate of the light post, its H meters high.
scale = 1
%volkswagen golf
CarW = 1.8/scale; %Lenght of the object
CarL = 4.56/scale; %Whidth of the object
CarH = 1.5/scale; %Hight of the object

alb = 0.5; %some clore object
floorRefl = 0.11; %old alphalt albedo

FOV = 120/180*pi; %120 degrees in radians = FOV of the PD

halfconeapex = (35/2*pi)/180; %Angle at Half Power in radiance
m = -1/log2(cos(halfconeapex)); %some index describing the radiation pattern
lumI = 290; %Measured light intensity during verification
stepsize = 0.2;

yloc = 0;
for yloc_ = 1  %should always be 0 or bigger than 0.5 CarW for shaddows to work properly!
   for alb_ = 1    
total = 0;
a = 0;
b = 0;
c = 0;
d = 0;
e = 0;
z = 0;

    for Xloc = CarL/2:CarL/2:CarL*5 %should always be bigger than CarL for shaddows to work properly!
    objRefl = alb(alb_)
    Yloc = yloc(yloc_)
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
xborder2 = H*(CarL-Xloc)/(H - CarH);
%yborder1 = CarH*(Yloc+CarW)/(H-CarH) + Yloc+CarW;
yborder1 = H*(Yloc+0.5*CarW)/(H-CarH);
xr = (Yloc-CarW*0.5)/Xloc; %dy/dx
yr = (Xloc-CarL)/(Yloc+0.5*CarW); %dy/dx

if(Xloc == CarL/2)
    ObjShaddow= @(x,y) (y > Yloc-0.5*CarW) * (y < yborder1) * (x < xborder1) * (x > -xborder1);
elseif (Xloc < CarL)
    ObjShaddow= @(x,y) (y > Yloc-0.5*CarW) * (y < yborder1) * (x < xborder1) * (x > -xborder2);
else
    ObjShaddow= @(x,y) (y > Yloc-0.5*CarW) * (y < yborder1) * (y > x*xr) * (x > y*yr) * (x < xborder1) * (x > Xloc-CarL);
end

dist= @(x,y,z) sqrt(x.*x+y.*y+z.*z);
COSinvalshoek = @(x,y,z,n1,n2,n3) dot([x y z]/dist(x,y,z), [n1 n2 n3]/dist(n1,n2,n3));
COSuitvalshoek = @(x,y,z,n1,n2,n3) COSinvalshoek(x,y,z,n1,n2,n3);

COSinvalshoek_= @(v1,v2) dot(v1/norm(v1),v2/norm(v2));
COSuitvalshoek_= @(v1,v2) COSinvalshoek_(v1,v2);

R = @(v1,v2) 2 .* dot(v1/norm(v1),v2/norm(v2)) * (v2/norm(v2)) - (v1/norm(v1));

%I = I0 * cos(phi)^m
I = @(x,y,z) lumI .* ((m+1)/(2*pi)) .* COSuitvalshoek(x,y,-z,0,0,-1).^m;
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

a= [a NumericIntegration_(NoObj  ,-10 ,10 ,-10 ,10            ,stepsize)];
b= [b NumericIntegration_(ObjTop ,-10 ,10 ,-10 ,10            ,stepsize)]; %human will only walk in the center of the sidewalk (tus between 0 and 2 m)
c= [c NumericIntegration_(ObjSide,-10 ,10 ,0  ,CarH+stepsize*10 ,stepsize)]; %object is never going to be in the ground and higher than CarH
d= [d NumericIntegration_(ObjBack,-10 ,10 ,0  ,CarH+0.5         ,stepsize)]; %object is never going to be in the ground and higher than CarH
%e= [e NumericIntegration_(ObjFront,-1,1,0,CarH+0.5,0.01)]; %object is never going to be in the ground and higher than CarH
%a+b+c+d+e
c
    end
a(1) = [];
b(1) = [];
c(1) = [];
d(1) = [];
e(1) = [];
z(1) = [];

a(isnan(a)) = 0;
b(isnan(b)) = 0;
c(isnan(c)) = 0;
d(isnan(d)) = 0;
%e(isnan(e)) = 0;

tot = a+b+d+c;

%the scenario would be exaclty the same if the car would move in the other
%direction, thus the obtained results can be mirrored to make calculation
%faster.
% tot = [fliplr(tot(2:9)) tot];
   M(yloc_,1,alb_,:) = tot;
   end
end

save('Car drives By Results')