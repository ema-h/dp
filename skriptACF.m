pkg load control
pkg load signal
% mozne volanie existujuceho audiosuboru, ktory chceme skumat
% nemal by byt prilis dlhy (tak do 2-3 sekund, najlepsie menej)
%[x, Fs] = audioread('guitarD.wav');
%ak sa pouzije audioread, treba zakomentovat nasledovne 4 riadky
Fs=10000;
dt=1/Fs;
t=0:dt:0.2;
x=sin(2*pi*100*t) + sin(2*pi*500*t) + sin(2*pi*300*t);

% autokorelacia
N = length(x);
ACF = zeros(N,1);
for tau = 1:N
    ACF(tau) = sum(x(1:N-tau) .* x(1+tau:N));
end

subplot(2,1,1)
plot(x(1:N/2))
xlabel('Cas');
ylabel('Amplituda');
title('Zvukovy signal sin(2*pi*100*t) + sin(2*pi*300*t) + sin(2*pi*500*t)');
subplot(2,1,2)
plot(ACF(1:N/2))
xlabel('Lagy')
ylabel('Hodnota')
title('ACF');

%zvyknu sa pouzivat na indikaciu periody / frekvencie len kladne hodnoty peakov
ACF(ACF<0) = 0;

% hladanie peakov
[peaks,locations] = findpeaks(ACF);

M=[peaks,locations];

sortedM=sortrows(M,-1);

f0 = Fs/(sortedM(2,2) - sortedM(1,2))

%tento sposob so sort bol zvoleny z dovodu, ze findpeaks nie vzdy vrati lagy podla velkosti / vyznamnosti
%obzvlast je to citlive na amplitudy jednotlivych harmonickych zloziek tonu (velke amplitudy skresluju a vytvaraju takisto peaky)
%takze sa stane, ze medzi najvacsim a druhym najvacsim peakom su este tri male
%treba ich zoradit a vzdialenost medzi prvymi dvoma najvyznamnejsimi je perioda
