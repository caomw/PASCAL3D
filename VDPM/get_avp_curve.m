aps = [];
aas = [];
theta_errors = 0:5:22*5;
for error = theta_errors
    [recall, precision, accuracy, ap, aa] = compute_recall_precision_accuracy_rqi('chair', 16, 16, error);
    aps = [aps ap];
    aas = [aas aa];
end

aas_log = [0.000 0.0046    0.0174    0.0300    0.0405    0.0548    0.0694    0.0810    0.0929    0.1026    0.1042    0.1081    0.1111    0.1148    0.1164    0.1168    0.1176    0.1180    0.1191 0.1192    0.1224    0.1237    0.1238];