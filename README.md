# Audiovisual-Association_2017

Purpose: this script was developed by Shutian Xue for her thesis study "Does learning an audiovisual association affect within-modal sensitivities?" at The University of Hong Kong (HKU) during 2017-2018. 
©️ Shutian Xue vivianxuest@outlook.com

%% Aim
This experiment aims to study whether forming audiovisual (cross-modal) associations would affect unimodal discrimination of visual brightness and auditory pitch.

%% Methodology: discrimination + training
1. Discrimination task
Conducted before and after training for both modalities (visual and auditory). We adopted a staircase paradigm.

2. Training
Three types of associations amde three groups:

-Intuitive: higher B, higher P (vice versa)

- Counterintuitive: higher B, lower P (vice versa)

- Not associated [control]: random pairing (serve as control group)

%% Structure of experiment

Day 1 (~50 min)

1. Pre-tests for both brightness and pitch (10 min for each modality)


2. Training session #1-4 (each takes around 5 min)

3. Intermediate task (4 min)

Day 2 (~50 min)

1. Training session #5-8 

2. Intermediate task

3. Post-tests

%% How to conduct experiment

Task                  Function name & Inputs

Discrimination test   QUEST(subjectID,modality,block)

Training              RunExp_training(subjectID,condition,block) 

Intermediate task     RunExp_inter(subjectID,condition,block)

% For what inputs should be entered, please refer to "Description" in each function script.

