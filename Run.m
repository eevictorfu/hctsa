% Example time-series data
timeSeriesData = {
    rand(10000, 1);
    rand(10000, 1);
    rand(10000, 1);
};

labels = {
    'IRPPG';
    'PPW';
    'ECG'
};

keywords = {
    'IRPPG';
    'PPW';
    'ECG'
};

% Save the variables in a .mat file
save('TS.mat', 'timeSeriesData', 'labels', 'keywords');

TS_Init('TS.mat', 'hctsa', 1 , 'HCTSA.mat');

TS_Compute();