# A-EEG-based-PD-Classification-Model
This is the source code for the EEG-based PD classification model.
The code is performed on the environment of MATLAB2021B.

The raw EEG data are saved in "RawData_Iowa" file.

The pre-processed data are saved in "Preprocessed" file.

The extracted PSD features are saved in "PSD_6s" file.

Execut "GetPSD_6sSegment.m" to extract the PSD features of each subject.

Execut "PSD_6s_10FoldCrossValidation.m" to perform the classification and get the evaluation.
