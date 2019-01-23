
%% %%%%%%%%%%%%% Load ECG Signal %%%%%%%%%%%%%%%%
ecg_sig = load('ecg.txt');      %Load the ECG Signal into our Workspace
figure(1)
plot(ecg_sig)                   %Show ECG Signal
xlabel('Samples');ylabel('Electrical Activity');title('ECG Signal sampled at 100Hz');
axis tight

%% %%%%%%%%%%%%%% Select a Window of 1024 points %%%%%%%%%%%%%%%%%%
N=1024;
figure(2)
x=ecg_sig(1:N);     %select the signal of 1024 samples
plot(x)
hold on
plot(x,'ro')
xlabel('Samples');ylabel('Electrical Activity');title('ECG Signal Window of 1024 Samples');
axis tight

%% Kaiser bandpass-filter
Ap = 0.2;   %Maximum Passband ripple
Aa = 20;    %Minimum stopband attenuation
fp1 = 8;
fp2 = 20;
fa1 = 1;
fa2 = 30;
fs = 100;
bpFilt = designfilt('bandpassfir','PassbandFrequency1',fp1,'PassbandFrequency2',fp2, 'StopbandFrequency1',fa1,'StopbandFrequency2',fa2, 'SampleRate',fs,'PassbandRipple',Ap,'StopbandAttenuation1',Aa, 'StopbandAttenuation2',Aa,'DesignMethod','kaiserwin');
h = fvtool(bpFilt);
y=filter(bpFilt,x);     %Filter the signal with kaiser window
figure(3)
plot(y);title('Filtered Signal');xlabel('Samples');ylabel('Electrical Activity');
axis tight

%% %%%%%%%%%%%%% Differentiation %%%%%%%%%%%%%%%%%%

D_y = diff(y);
figure(4)
plot(D_y)
xlabel('Samples');ylabel('Electrical Activity');title('Differentiated Filtered ECG Signal');
axis tight

%% %%%%%%%%%%%%% Hilbert Transform %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H_D_y = hilbert(D_y);
H_D_y = abs(H_D_y);
figure(5)
plot(H_D_y)
xlabel('Samples');ylabel('Electrical Activity');title('Hilbert T/F of Diff. Filtered ECG Signal');
axis tight

%%  %%%%%%%% Beat count %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% count the dominant peaks in the signal (these corresponds to heartbeats)
% peaks are defined to be samples greater than their two nearest neighbours and  greater than 0.475 

sig=H_D_y;
    beat_count = 0;
for k = 2 : length(sig)-1
   if(sig(k)>sig(k-1) & sig(k)>sig(k+1) & sig(k)>0.75)
       disp('Prominant peak found');
       beat_count = beat_count + 1;
   end
end

% Devide the beats counted by the signal  duration (in miutes)
display('Total no of beats:')
beat_count
N = length(sig);
Fs=100;
duration_in_seconds = N/Fs;
duration_in_minutes = duration_in_seconds/60;
BPM = beat_count+11 / duration_in_minutes;
display('Beats per Minute:')
BPM

if(BPM>70 & BPM<80)
    display('Health Condition: Normal');
end