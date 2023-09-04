function SOFAtoWAV(dataFolderPath, recommendedSet)
%SOFAtoWAV MATLAB function to convert Sony HRTFs from .SOFA files to .WAV
%   Folder structure must follow that of Sony measured data

%   dataFolderPath      Path to the top-level folder containing the three
%                       folders 'data', 'Export' and 'Extracted Data'
%   recommendedSet      Recommended take (found in Excel spreadsheet)

% Add SOFA toolbox path
addpath("C:\Users\jtc519\Working Directory\MATLAB Projects\SOFAtoolbox-master\SOFAtoolbox\");

% Add data folder path
addpath(dataFolderPath);
% Select recommended take (50pt Lebadev Grid)
addpath(strcat(dataFolderPath, {'\Export\Set '}, string(recommendedSet), '\0.5m Measured 50pt'))
   
% Make folder to store .WAV files
mkdir(strcat(dataFolderPath, '\Extracted Data\48K_24bit'));
 
% Start toolbox 
SOFAstart();

% Load in HRTF
sofaStruct = SOFAload(strcat(dataFolderPath, {'\Export\Set '}, string(recommendedSet), '\0.5m Measured 50pt\Standard_IR_48000.sofa'));
 
% Extract Data
sofaData = sofaStruct.Data;
IR = sofaData.IR;
Fs = sofaData.SamplingRate;
Info = sofaStruct.SourcePosition;

% Write Audio Files
for i = 1: height(IR)
    azi = round(Info(i, 1), 1);
    aziStr = strrep(sprintf('%.1f', azi), '.', ',');
    ele = round(Info(i, 2), 1);
    eleStr = strrep(sprintf('%.1f', ele), '.', ',');

    % dB Conversion
    dB = -.5;
    lin = 10^(dB/10);
    IR_Nor = lin*IR;

    audiowrite(strcat(dataFolderPath, '\Extracted Data\48K_24bit\azi_', aziStr, '_ele_', eleStr, '.wav'), squeeze(IR_Nor(i, :, :))', Fs);
end

% Copy config file
copyfile('O5_3d_sn3d_50Leb_pinv_basic.config', strcat(dataFolderPath, '\Extracted Data\'));
end