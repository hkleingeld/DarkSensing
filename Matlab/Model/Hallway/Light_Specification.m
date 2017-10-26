%         Based on hallway 9th floor EWI
%   
% Wall 1               I0               Wall 2
% ^ |                                     | ^
% | |                                     | |   
% z |                                     | |
% - |                                     | |        
% a |                                     | |            
% x |                                     | | H = 280 cm             
% i |                                     | |       
% s |                                     | |             
%   |               W = 222cm             | |
%   |<---------------- W ---------------->| |
%___|_____________________________________| v
%//////////////////////////////////////////
%                   x-axis ------>
% y axis positive goes "In the screen", y negative comes "out of the screen"
clear all
NrOfSteps = 25;

lightDist = 1;
xoffset = 0.65;

FOV = 120/180*pi;                   %120 degrees in radians
halfconeapex = (35.4/2*pi)/180;     %Angle at Half Power in radiance
m = -1/log2(cos(halfconeapex));     %some index describing the radiation pattern
lumI = 290;

%light was hung slightly lower than 2.8m, as the light would hang under the ceiling.
H = 2.7; 
W = 2.2;
step = (W-2*0.01)/NrOfSteps;

%albedos, floor albedoe does not realy matter for this calculation
Alb_Floor = 0.35;
Alb_Wall = 0.95;

%areas where the surfaces reflect
Floor = @(x,y) (x<W/2+0.001) .* (x>-W/2+0.001);
Wall_1= @(x,z) (z > 0) .* (z < H);
Wall_2= @(x,z) (z > 0) .* (z < H);

%direction of all lights in the calculation
Norm_Floor  = [0 0 1];
Norm_Wall_1 = [1 0 0];
Norm_Wall_2 = [-1 0 0];
Norm_Light = [0 0 -1];

%formulas for distance, incidience angle (invalshoek) and exit angle (uitvalshoek).
dist = @(x,y,z) sqrt(x.*x+y.*y+z.*z);
COSinvalshoek = @(x,y,z,n1,n2,n3) dot([x y z]/dist(x,y,z), [n1 n2 n3]/dist(n1,n2,n3));
COSuitvalshoek = @(x,y,z,n1,n2,n3) COSinvalshoek(x,y,z,n1,n2,n3);

COSinvalshoek_= @(v1,v2) dot(v1/norm(v1),v2/norm(v2));
COSuitvalshoek_= @(v1,v2) COSinvalshoek_(v1,v2);

%formula for calculating ideal reflection
R = @(v1,v2) 2 .* dot(v1/norm(v1),v2/norm(v2)) * (v2/norm(v2)) - (v1/norm(v1));

%I = I0 * cos(phi)^m
I = @(x,y,z) lumI .* ((m+1)/(2*pi)) .* COSuitvalshoek_([x y -(H-z)],Norm_Light).^m;
I_= @(x,y) I(x,y,H);

Ehor = @(x,y,z,n1) I(x,y,z) .* COSinvalshoek_([-x -y H-z],n1) ./ dist(x,y,H-z).^2;
Ehor_ = @(x,y) Ehor(x,y,0,[0 0 1])


%L1= (m+1)/(2*pi*d^2) * cos(uitvalshoek)
Lamb =@(x,y,z,n1)  (1/pi) * COSuitvalshoek_([-x,-y,z],n1);
Spec =@(x,y,z,n1,s) ((s+1)/(2*pi)) * COSinvalshoek_(R([-x -y z],n1),[-x -y z]);
    
Lamb_ = @(x,y) Lamb(x,y,1,0,0,1);
Spec_ = @(x,y) Spec(x, y, 1,[0 0 1],10);

%phong = @(x,y,z,v1,v2,v3,rd,s) I(x,y,z) * dot([-x,-y,z],[v1,v2,v3]) * (rd * Lamb(x,y,z,v1,v2,v3) + (1-rd) * Spec(x,y,z,v1,v2,v3,s))/norm([x,y,z])^2;
phong = @(x,y,z,v1,v2,v3,rd,s) COSinvalshoek(-x,-y,z,v1,v2,v3) * (rd * Lamb(x,y,z,v1,v2,v3) + (0) * Spec(x,y,z,[v1 v2 v3],20))/norm([x,y,z])^2;

%PD = 1/d^2 * cos(invalshoek @PD)
rec = @(x,y,z) (acos(dot(NormPD,[x,y,-z]/norm([x,y,-z])))/FOV) < 1;
PD =@(x,y,z) 1/dist(x,y,z)^2 * COSinvalshoek(x,y,-z,0,0,-1) * rec(x,y,z);
PD_=@(x,y) PD(x,y,1);

%formulas for illumination off walls and floors
I_Floor = @(x,y)  Floor(x,y)   *(Ehor(x+xoffset,y,0,Norm_Floor)     + Ehor(x-xoffset,y-1*lightDist,0,Norm_Floor) + Ehor(x-xoffset,y+1*lightDist,0,Norm_Floor)     + Ehor(x+xoffset,y-2*lightDist,0,Norm_Floor)     + Ehor(x+xoffset,y+2*lightDist,0,Norm_Floor)     + Ehor(x-xoffset,y-3*lightDist,0,Norm_Floor)     + Ehor(x-xoffset,y+3*lightDist,0,Norm_Floor)+ Ehor(x+xoffset,y-4*lightDist,0,Norm_Floor)+ Ehor(x+xoffset,y+4*lightDist,0,Norm_Floor)+ Ehor(x-xoffset,y-5*lightDist,0,Norm_Floor)+ Ehor(x-xoffset,y+5*lightDist,0,Norm_Floor));
I_Wall_1=@(y,z) Wall_1(-W/2,z) * (Ehor(-W/2+xoffset,y,z,Norm_Wall_1)+ Ehor(-W/2-xoffset,y-lightDist,z,Norm_Wall_1) + Ehor(-W/2-xoffset,y+lightDist,z,Norm_Wall_1) + Ehor(-W/2+xoffset,y-2*lightDist,z,Norm_Wall_1) + Ehor(-W/2+xoffset,y+2*lightDist,z,Norm_Wall_1) + Ehor(-W/2-xoffset,y-3*lightDist,z,Norm_Wall_1) + Ehor(-W/2-xoffset,y+3*lightDist,z,Norm_Wall_1)+ Ehor(-W/2 +xoffset,y-4*lightDist,z,Norm_Wall_1) + Ehor(-W/2+xoffset,y+4*lightDist,z,Norm_Wall_1)+ Ehor(-W/2 -xoffset,y-5*lightDist,z,Norm_Wall_1) + Ehor(-W/2-xoffset,y+5*lightDist,z,Norm_Wall_1));
I_Wall_2=@(y,z) Wall_1(W/2,z)  * (Ehor(W/2+xoffset,y,z,Norm_Wall_2) + Ehor(W/2-xoffset,y-lightDist,z,Norm_Wall_2) + Ehor(W/2-xoffset,y+lightDist,z,Norm_Wall_2) + Ehor(W/2+xoffset,y-2*lightDist,z,Norm_Wall_2) + Ehor(W/2+xoffset,y+2*lightDist,z,Norm_Wall_2) + Ehor(W/2-xoffset,y-3*lightDist,z,Norm_Wall_2) + Ehor(W/2-xoffset,y+3*lightDist,z,Norm_Wall_2) + Ehor(W/2+xoffset,y-4*lightDist,z,Norm_Wall_2) + Ehor(W/2+xoffset,y+4*lightDist,z,Norm_Wall_2)+ Ehor(W/2-xoffset,y-5*lightDist,z,Norm_Wall_2) + Ehor(W/2-xoffset,y+5*lightDist,z,Norm_Wall_2));

%calculated Ehor for each area
[Ehor_Floor floorx floory] = HalfNumericIntegration(I_Floor, -W/2+0.01,W/2-0.01,-5,5,step);
[Ehor_Wall1 wally wallz] = HalfNumericIntegration(I_Wall_1,-5,5,0.01,H-step,step);
[Ehor_Wall2 wally wallz] = HalfNumericIntegration(I_Wall_2,-5,5,0.01,H-step,step);

Ehor_Floor_Via_1 = zeros(floory,floorx);
Ehor_Floor_Via_2 = zeros(floory,floorx);

%Calculate how much light from each point on wall 1, shines on each point
%on the floor
parfor fx = 1:floorx
    for fy = 1:floory
        for wy = 1:wally
            for wz = 1:wallz
                if wz == 1 && fx == 1 && fy == 58 && wy == 58
                    yay = 1;
                end
                x = (fx-1)*step+0.01;
                y = ((fy-1) - (wy-1)) * step;
                z = (wz-1)*step + 0.01;
                Ehor_Floor_Via_1(fy,fx) = Ehor_Floor_Via_1(fy,fx) + Alb_Wall * Ehor_Wall1(wz,wy) * 1/pi * COSuitvalshoek_(Norm_Wall_1,[x y -z]) * COSinvalshoek_(Norm_Floor,[-x -y z])/dist(x,y,z).^2;
            end
        end
    end
end

parfor fx = 1:floorx
    for fy = 1:floory
        for wy = 1:wally
            for wz = 1:wallz
                x = (fx-1)*step - W;
                y = ((fy-1) - (wy-1)) * step;
                z = (wz-1)*step + 0.01;
                Ehor_Floor_Via_2(fy,fx) = Ehor_Floor_Via_2(fy,fx) + Alb_Wall * Ehor_Wall2(wz,wy) * 1/pi * COSuitvalshoek_(Norm_Wall_2,[x y -z]) * COSinvalshoek_(Norm_Floor,[-x -y z])/dist(x,y,z).^2 *step^2;
            end
        end
    end
end

%removing outer edges of second reflection, as the distance between
%reflection points are near zero, leading to unrealistic results (1/d^2 = near infinite)
Ehor_Floor_Via_1(:,1) = 0;
Ehor_Floor_Via_2(:,26)= 0;
tot = (Ehor_Floor_Via_1+Ehor_Floor_Via_2)*step*step+Ehor_Floor;

%calculate average Ehor, should be higher than 100 lx
average = mean(mean(tot(47:70,:)))

%find minimum illumination of center light bulb
minimum = tot(58,26)

%calculated Uo
UH = minimum/average
surf(((Ehor_Floor_Via_1+Ehor_Floor_Via_2)*step*step+Ehor_Floor))

