%% CLEAR SECTION
clear all
close all

addpath(genpath('/home/chiara/Documenti/chiaras_thesis/BicRF/'));
rng('default');

%% READ RESULTS
X = zeros(60,10);
labels = {'BicRF17', 'BicRF20', 'BicRF28', 'BicRF40', 'BicRF50', 'ChengChurch', 'LAS', 'Plaid', 'RUBic', 'XMotifs'};

names = {'constant','columnconstant','rowconstant','scaling', 'shifting', 'orderpreserving'};
for n=1:length(names)
    name = names{n};
    path_directory=['~/Documenti/chiaras_thesis/algorithms_biclustering/results/nonbinary/' name]; 
    % Pls note the format of files,change it as required
    original_files=dir([path_directory '/*.csv']); 
    for k=1:length(original_files)
        filename=[path_directory '/' original_files(k).name];
        data = readmatrix(filename);
        data = data(:,2:3);
        idx = n*10;
        X(idx-9:idx,k) = mean(data')';
    end
end

%%
[pv,~,stats]=friedman(1-X,1);
[h,CD]=nemenyi(stats,0.05);
criticaldiagram(CD,stats.meanranks,labels)
