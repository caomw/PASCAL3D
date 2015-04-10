function model = pose_train(cls, n, note)

% model = pose_train(cls, n, note)
% Train a model with n components using the PASCAL3D+ dataset.
% Each component corresponds to a view section.
% note allows you to save a note with the trained model
% example: note = 'testing FRHOG (FRobnicated HOG)

% At every "checkpoint" in the training process we reset the 
% RNG's seed to a fixed value so that experimental results are 
% reproducible.
initrand();

if nargin < 3
  note = '';
end

globals; 
[pos, neg] = pose_data(cls, true, 'train');
% split data according to viewpoints
[spos, index_pose] = pose_split(pos, n);

cachesize = 24000;
maxneg = 200;

% train root filters using warped positives & random negatives
try
  load([cachedir cls '_root']);
catch
  initrand();
  for i = 1:numel(index_pose)
    models{i} = initmodel(cls, spos{index_pose(i)}, note, 'N');
    models{i} = train(cls, models{i}, spos{index_pose(i)}, neg, i, 1, 1, 1, ...
                      cachesize, true, 0.7, false, ['root_' num2str(i)]);
  end
  save([cachedir cls '_root'], 'models');
end

% merge models and train using hard negatives
try 
  load([cachedir cls '_mix']);
catch
  initrand();
  model = mergemodels(models);
  model = train(cls, model, pos, neg(1:maxneg), 0, 0, 1, 5, ...
                cachesize, true, 0.7, false, 'mix');
  save([cachedir cls '_mix'], 'model');
end

% add parts and update models using hard negatives.
try 
  load([cachedir cls '_parts']);
catch
  initrand();
  for i = 1:numel(index_pose)
    model = model_addparts(model, model.start, i, i, 8, [6 6]);
  end
  model = train(cls, model, pos, neg(1:maxneg), 0, 0, 8, 10, ...
                cachesize, true, 0.7, false, 'parts_1');
  model = train(cls, model, pos, neg, 0, 0, 1, 5, ...
                cachesize, true, 0.7, true, 'parts_2');          
  save([cachedir cls '_parts'], 'model');
end

model.view_num = n;
model.index_pose = index_pose;
% model.azimuth_interval = azimuth_interval;
save([cachedir cls '_final'], 'model');