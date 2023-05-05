pkg load control
pkg load signal
%ErbSpace, MakeERBFilters, ERBFilterBank nepouzivame, ale je priklad ich pouzitia zakomentovany
% MeddisHairCell pouzivame, je odkaz na stiahnutie spolu s hore spomenutymi
fs=15000;
dt=1/fs;
t=0:dt:0.1;
x=sin(2*pi*100*t)+sin(2*pi*300*t)+sin(2*pi*500*t);
%fcoefs=MakeERBFilters(fs,100,30);
%gamma = ERBFilterBank(x, fcoefs);
hc = MeddisHairCell(x,fs);

function vektor= hcf(X,dt,tau,Tvek,l)
V = zeros(size(Tvek));
for t = Tvek
  V(t) = sum(X(1:t-l).*X(l+1:t).*exp(-1*dt*(1:t-l)/tau)*dt)/tau;
end
vektor=V';
end

tau = 0.005;
numChannels = size(hc,1)
signalLength = size(hc,2)
% vyber zmysluplnych lagov na znizenie iteracii
% najmensia perioda 1/30 a najvacsia perioda 1/5000
l_lower = find(t >= 1/5000,1);
l_upper = find(t > 1/30, 1) -1;
l_vec = t(l_lower:l_upper); %nie vzdy bude posledny prvok rovny l_upper, ale najblizsi mensi / rovny co vyhovuje deleniu
l_vec_idx = l_lower:l_upper;
H = zeros(signalLength,length(l_vec),numChannels);
for k = 1:numChannels
  for l = 1:length(l_vec)
    H(:,l,k) = hcf(hc(k,:),dt,tau,1:signalLength,l_vec_idx(l));
  endfor
end

SACF = sum(H,3);
[maxval idx] = max(x);
subplot(2,1,1)
plot(x)
xlabel('Cas');
ylabel('Amplituda');
title('Zvukovy signal sin(2*pi*100*t) + sin(2*pi*300*t) + sin(2*pi*500*t)');
subplot(2,1,2)
plot(SACF(idx,:))
xlabel('Lagy')
ylabel('Hodnota')
title('SACF');
SACF(SACF<0)=0;
[peaks, locations] = findpeaks(SACF(idx,:));
M=[peaks', locations'];

sortedM=sortrows(M,-1);

f0 = 1/abs((l_vec(sortedM(2,2))-l_vec(sortedM(1,2))))
