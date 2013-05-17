function out = SY_dynwin(y)
% METRIC FOR STATIONARITY AS A FUNCTION OF A FEW PARAMETERS (WINDOW SIZE,
% WINDOW OVERLAP)
% Ben Fulcher August 2009
% Ben Fulcher 8/10/2010 fixed an error -- didn't take std of fs before
% doing output... cleared all existing entries for this operation.

nsegr = (2:1:10);
nmov = 1;
nfeat = 11; % number of features
fs = zeros(length(nsegr),nfeat);
taug = CO_fzcac(y); % global tau

for i = 1:length(nsegr)
    nseg = nsegr(i);
    wlen = floor(length(y)/nseg); % window length
    inc = floor(wlen/nmov); % increment to move at each step
    if inc == 0; inc = 1; end

    nsteps = (floor((length(y)-wlen)/inc)+1);
    qs = zeros(nsteps,nfeat);

    for j = 1:nsteps
            ysub = y((j-1)*inc+1:(j-1)*inc+wlen);
            taul = CO_fzcac(ysub);
%             ysubrsl=resample(ysub,1,taul); % resample at tau
%             ysubrsg=resample(ysub,1,taug); % resample
            
            qs(j,1) = mean(ysub); % mean
            qs(j,2) = std(ysub); % standard deviation
            qs(j,3) = skewness(ysub); % skewness
            qs(j,4) = kurtosis(ysub); % kurtosis
%             qs(j,5)=EN_ApEn(ysubrsg,1,0.15); % ApEn_taug
%             qs(j,6)=EN_sampenc(ysubrsg,1,0.15); % SampEn_taug
%             qs(j,7)=EN_ApEn(ysubrsl,taul,0.15); % ApEn_taul
%             qs(j,8)=EN_sampenc(ysubrsl,taul,0.15); % SampEn_taul
            qs(j,5) = EN_ApEn(ysub,1,0.2); % ApEn_1
            qs(j,6) = EN_sampenc(ysub,1,0.2); % SampEn_1
            qs(j,7) = CO_autocorr(ysub,1); % AC1
            qs(j,8) = CO_autocorr(ysub,2); % AC2
            qs(j,9) = CO_autocorr(ysub,taug); % AC_glob_tau
            qs(j,10) = CO_autocorr(ysub,taul); % AC_loc_tau
            qs(j,11) = taul;
    end

% plot(qs,'o-');
% input('what do you think?')
% keyboard

fs(i,1:nfeat) = std(qs);
%     fs(i,nfeat+1:2*nfeat)=std(qs);

% switch meattray
%     case 'std'
%         out=std(qs)/std(y);
%     case 'apen'
%         out=EN_ApEn(qs,1,0.2); % ApEn of the sliding window measures
%     case 'ent'
%         out=DN_kssimp(qs,'entropy'); % distributional entropy
%     case 'lbq' % lbq test for randomness
%         [h p] = lbqtest(y);
%         out=p;
% end
end

% fs contains std of quantities at all different 'scales' (segment lengths)


fs = std(fs); % how much does the 'std stationarity' vary over different scales?

% plot(fs)
out.stdmean = fs(1);
out.stdstd = fs(2);
out.stdskew = fs(3);
out.stdkurt = fs(4);
out.stdapen1_02 = fs(5);
out.stdsampen1_02 = fs(6);
out.stdac1 = fs(7);
out.stdac2 = fs(8);
out.stdactaug = fs(9);
out.stdactaul = fs(10);
out.stdtaul = fs(11);


end