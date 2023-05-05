pkg load statistics
function f_hat = Goldstein(f_vek,max_harmonics)
alpha=0.01;
%pocet vstupnych frekvencii
Fnum = length(f_vek);
% vektor pripustnych poradi v harmonickom spektre
harmonics_vec = [2:max_harmonics-Fnum+1];
%zoradenie frekvencii, keby neboli podla narastajucej vysky
sf_vek = sort(f_vek);
% generovanie matice P, kde sa budu ukladat hodnoty funkcie vierohodnosti
P = zeros(max_harmonics-Fnum+1,2);
sigma=zeros(Fnum,1);
x=sigma;
for i = 1:Fnum
  % generovanie smerodajnych odchylok a reprezentacii frekvencii
  sigma(i) = alpha*sqrt(sf_vek(i));
  x(i) = normrnd(sf_vek(i),sigma(i));
end
% vypocet hodnot matice P pre mozne poradia frekvencii
for i = harmonics_vec
  f0 = sf_vek(1)/i;
  p=1;
  for j = 1:Fnum
    p = p*normpdf(x(j),(i+j-1)*f0,sigma(j));
  end
  P(i,2) = p;
  P(i,1) = i;
end
[max_val, idx] = max(P(:,2));
% f_hat je prva vstupna frekvencia vydelena jej odhadnutym indexom v spektre
f_hat = x(1)/idx;
end

%priklady volania
%f0=Goldstein([200 300 400 500],12) %f0 100
%f0=Goldstein([200 300 400 505],12) %"mistuned" harmonics, nie uplne presne nasobky f0 50
