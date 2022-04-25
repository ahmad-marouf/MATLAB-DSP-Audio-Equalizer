%% input time domain
[y,Fs] = audioread('music.wav');
%figure; plot(y); title('Input Signal');
%% Create Filter
wn = [6000/(Fs/2), 12000/(Fs/2)];
[N,~] = cheb2ord(wn(1),wn(2),1,10);                 %Rp = 1, Rs = 10, taken by trial
% N is order
[num,den] = cheby2(N,0.5,wn,'bandpass');             
%[num,den] = butter(N,wn,'bandpass');
%% Filtered Band Time domain
yFiltered = filter(num,den,y);
t = linspace(0,50,length(yFiltered));
figure; plot(t,yFiltered); title('Filtered Band Signal Time Domain');    
%% Filtered Band Frequency domain
Y = fftshift(fft(yFiltered));
F = linspace(-Fs/2,Fs/2,length(yFiltered));
figure; plot(F,real(Y)); title('Filtered Band Signal Frequency Domain');
%% add the amplified gain
GainDB = 10;
Gain = db2mag(GainDB);
yAmp = Gain * yFiltered; %for each band
%% form composite signal
% yTotal = yAmp1 + yAmp2 + yAmp3 .... yAmp9
% plot composite signal in time and freq
%% plot input signal in time and freq and compare
%% plot magnitude and phase
[H,w] = freqz(num,den);
mag = abs(H);
phase = angle(H);
figure; plot(w,mag); title('Magnitude');    
figure; plot(w,phase); title('Phase'); 
%% plot impulse and step response
imp = [1, zeros(1,length(y)/1000)];
impRes = filter(num,den,imp);
step = [1, ones(1,length(y)/1000)];
stepRes = filter(num,den,step);
figure; plot(impRes); title('Impulse Response'); 
figure; plot(stepRes); title('Step Response'); 
%% plot poles and zeros
z = roots(num);
p = roots(den);
[z,p,k]=butter(N,wn); 
figure; zplane(z,p); title('Pole-Zero Plot');
% k is gain