clc
clear
disp('=============INSTRUCTIONS===================================================================')
fprintf('Only considering Ideal Conditions and Ideal State of all Cycles\n')
disp('============================================================================================')


while true
    A=menu('Select the Cycle','Otto Cycle','Diesel Cycle','Dual Cycle');
    switch A
        
        case 1
            P1=input('Enter Suction Pressure(in kPa): ');
            T1=input('Enter Suction Temperature(in Kelvin): ');
            T3=input('Enter Peak Temperature(in Kelvin): ');
            Cp=input('Enter Value of Cp for Fluid(in kJ/kg.K)(Type 0 if air): ');
            Cv=input('Enter Value of Cv for Fluid(in kJ/kg.K)(Type 0 if air): ');
            CR=input('Enter Compression Ratio: ');
            Otto(P1,T1,T3,Cp,Cv,CR);
        case 2
            P1=input('Enter Suction Pressure(in kPa): ');
            T1=input('Enter Suction Temperature(in Kelvin): ');
            Cp=input('Enter Value of Cp for Fluid(in kJ/kg.K)(Type 0 if air): ');
            Cv=input('Enter Value of Cv for Fluid(in kJ/kg.K)(Type 0 if air): ');
            CR=input('Enter Compression Ratio: ');
            P=input('Enter Cutoff Ratio: ');
            Diesel(P1,T1,Cp,Cv,CR,P);
        case 3
            P1=input('Enter Suction Pressure(in kPa): ');
            T1=input('Enter Suction Temperature(in Kelvin): ');
            Cp=input('Enter Value of Cp for Fluid(in kJ/kg.K)(Type 0 if air): ');
            Cv=input('Enter Value of Cv for Fluid(in kJ/kg.K)(Type 0 if air): ');
            CR=input('Enter Compression Ratio: ');
            P=input('Enter Cutoff Ratio: ');
            P_r=input('Enter Pressure Ratio: ');
            Dual(P1,T1,Cp,Cv,CR,P,P_r);
        case 0
            disp('Closing Program')
            break
    end
end

%Engine
%Otto Cycle
function [W,Q,eff]=Otto(P1,T1,T3,Cp,Cv,CR)%Taking input of inlet conditions, maximum Temperature,Specific heat and Compression ratio 
Cp_air=1.005;
Cv_air=0.718;
if Cp==0
    Cp=Cp_air;
    Cv=Cv_air;
end
R=Cp-Cv;%Ideal Gas Constant
v=Cp/Cv;%Adiabatic coefficient
T2=T1*CR^(v-1);
T4=T3/(CR^(v-1));
V1=(R*T1)/P1;%From Ideal Gas Law, as mass of gas is constant
V2=V1/CR;
P2=P1*(CR^v);
P3=P2*(T3/T2);
P4=P1*(T4/T1);
Q=Cv*(T3-T2);%Heat absorbed
W=Q-Cv*(T4-T1);%Work output(Heat Absorbed-Heat Released
eff=1-(1/(CR^(v-1)));%efficiency of Otto Cycle
disp('============================================================================================')
fprintf('Otto Cycle\nWork Output=%.4f kJ/kg\nHeat Absorbed=%.4f kJ/kg\nEfficiency of Cycle=%.4f%%\n',W,Q,eff*100);
disp('============================================================================================')
%plotting pv graph
v_c=linspace(V1,V2,100);
p_c=P1*(V1./v_c).^v;
v_ex=linspace(V2,V1,100);
p_ex=P3*(V2./v_ex).^v;
figure
plot(v_c,p_c,v_ex,p_ex,[V1 V1],[P4 P1],[V2 V2],[P2 P3])
xlabel('Volume(m^3/kg)')
ylabel('Pressure(kPa)')
end

%Diesel Cycle
function [W,Q,eff]=Diesel(P1,T1,Cp,Cv,CR,P)
Cp_air=1.005;
Cv_air=0.718;
if Cp==0
    Cp=Cp_air;
    Cv=Cv_air;
end
v=Cp/Cv;
R=Cp-Cv;
V1=(R*T1)/P1;
V2=V1/CR;
V3=V2*P;
V4=V1;
T2=T1*CR^(v-1);
T3=P*T2;
T4=T3*((P/CR)^(v-1));
P2=P1*(CR^(v));
P3=P2;
P4=P3*(V3/V4)^v;
Q=Cp*(T3-T2);
eff=1-(1/(CR^(v-1))*((P^v -1)/(v*(P-1))));
W=Cp*(T3-T2)-Cv*(T4-T1);
disp('============================================================================================')
fprintf('Diesel Cycle\nWork Output=%.4f kJ/kg\nHeat Absorbed=%.4f kJ/kg\nEfficiency of Cycle=%.4f%%\n',W,Q,eff*100);
disp('============================================================================================')
%graph plot
v_c=linspace(V1,V2,100);
p_c=P1*(V1./v_c).^v;
v_ex=linspace(V3,V4,100);
p_ex=P3*(V3./v_ex).^v;
figure
plot(v_c,p_c,v_ex,p_ex,[V1 V4],[P1 P4],[V2 V3],[P2 P3]);
xlabel('Volume(m^3/kg)')
ylabel('Pressure(kPa)')
end

%Dual Cycle
function [W,Q,eff]=Dual(P1,T1,Cp,Cv,CR,P,P_r)
Cp_air=1.005;
Cv_air=0.718;
if Cp==0
    Cp=Cp_air;
    Cv=Cv_air;
end
v=Cp/Cv;
R=Cp-Cv;
V1=(R*T1)/P1;
V2=V1/CR;
V3=V2;
V4=V3*P;
V5=V1;
T2=T1*CR^(v-1);
T3=T2*P_r;
T4=T3*P;
T5=T4*(P/CR)^(v-1);
P2=P1*(CR^(v));
P3=P2*P_r;
P4=P3;

P5=P4*(V4/V5)^v;
Q=Cv*(T3-T2)+Cp*(T4-T3);
eff=1-((Cv*((T5-T1))/Q));
W=(Cv*(T3-T2)+Cp*(T4-T3))-Cv*(T5-T1);
disp('============================================================================================')
fprintf('Dual Cycle\nWork Output=%.4f kJ/kg\nHeat Absorbed=%.4f kJ/kg\nEfficiency of Cycle=%.4f\n%%',W,Q,eff*100);
disp('============================================================================================')
%graph plot
v_c=linspace(V1,V2,100);
p_c=P1*(V1./v_c).^v;
v_ex=linspace(V4,V5,100);
p_ex=P3*(V4./v_ex).^v;
figure
plot(v_c,p_c,v_ex,p_ex,[V3 V4],[P3 P4],[V2 V3],[P2 P3],[V5 V1],[P5 P1]);
xlabel('Volume(m^3/kg)')
ylabel('Pressure(kPa)')
end
