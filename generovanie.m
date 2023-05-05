Fs=20000;
t=0:1/Fs:1;
x= sin(2*pi*100*t) + sin(2*pi*200*t);
y= sin(2*pi*100*t) + sin(2*pi*300*t) + 0.9*sin(2*pi*500*t) + 0.8*sin(2*pi*700*t);
x_spek=zeros(1000);y_spek=x_spek;
x_spek(100)=1;x_spek(200)=1;
y_spek(100)=y_spek(300)=1;y_spek(500)=0.9;y_spek(700)=0.8;

audiowrite('x100-200.wav',x,Fs)
audiowrite('y100-700.wav',y,Fs)

subplot(2,2,1);
plot(t(1:800), x(1:800));
xlabel('Cas');
ylabel('Amplituda');
title('100 Hz, 200 Hz');
subplot(2,2,2);
plot(t(1:800), y(1:800));
xlabel('Cas');
ylabel('Amplituda');
title('100 Hz, 300 Hz, 500 Hz, 700 Hz');
subplot(2,2,3);
plot(x_spek)
xlabel('Frekvencia');
ylabel('Amplituda');
ylim([0 1.1])
subplot(2,2,4);
plot(y_spek)
xlabel('Frekvencia');
ylabel('Amplituda');
ylim([0 1.1])

function generovanie(f_vek,T,Fs)
  % funkcia vygeneruje audiosubor a vykresli priebeh a spektrum zvuku / tonu
  % f_vek je vektor frekvencii, z ktorych sa ma signal skladat
  % T je ziadane trvanie signalu
  % Fs je samplovacia frekvencia (odporucane medzi 10000 a 44100)
  % priklad volania funkcie: generovanie([500 600 700], 1, 10000)
t=0:1/Fs:T;
x=zeros(size(t));
x_spek=zeros(max(f_vek)+100);
for i = f_vek
  x=x+sin(2*pi*i*t);
  x_spek(i)=1;
end
subplot(2,1,1)
plot(t,x)
xlabel('Cas');
ylabel('Amplituda');
subplot(2,1,2)
plot(x_spek)
xlabel('Frekvencia')
ylabel('Amplituda')
audiowrite('audiosubor.wav',x,Fs)
end
