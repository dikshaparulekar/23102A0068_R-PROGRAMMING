# Results

## Model Summary
```
Model: "sequential"
________________________________________________________________________________
 Layer (type)                       Output Shape                    Param #     
================================================================================
 dense_2 (Dense)                    (None, 256)                     602368      
 dense_1 (Dense)                    (None, 128)                     32896       
 dense (Dense)                      (None, 2)                       258         
================================================================================
Total params: 635522 (2.42 MB)
Trainable params: 635522 (2.42 MB)
Non-trainable params: 0 (0.00 Byte)
________________________________________________________________________________
```

## Training Set Evaluation
```
       loss    accuracy 
0.007203209 1.000000000 
```

### Training Set Confusion Matrix
```
         Actual
Predicted 0 1
        0 5 0
        1 0 5
```

### Training Set Predicted Probabilities
```
                                Predicted Actual
 [1,] 9.999757e-01 2.425701e-05 0         0     
 [2,] 9.999757e-01 2.425701e-05 0         0     
 [3,] 9.999757e-01 2.425701e-05 0         0     
 [4,] 9.999757e-01 2.425701e-05 0         0     
 [5,] 9.999757e-01 2.425701e-05 0         0     
 [6,] 8.518453e-05 9.999147e-01 1         1     
 [7,] 8.518453e-05 9.999147e-01 1         1     
 [8,] 8.518453e-05 9.999147e-01 1         1     
 [9,] 8.518453e-05 9.999148e-01 1         1     
[10,] 8.518453e-05 9.999148e-01 1         1     
```

## Test Set Evaluation
```
       loss    accuracy 
0.007203206 1.000000000 
```

### Test Set Confusion Matrix
```
         Actual
Predicted 0 1
        0 1 0
        1 0 1
```

### Test Set Predicted Probabilities
```
                               Predicted Actual
[1,] 9.999758e-01 2.425697e-05 0         0     
[2,] 8.518453e-05 9.999148e-01 1         1     
```

## Interpretation
The model achieved 100% accuracy on both the training set (10/10 images correctly
classified) and the test set (2/2 images correctly classified), with prediction
confidence above 99.99% for the correct class in every case.

This perfect accuracy is expected given the very small, visually distinct dataset
(only 6 images per class). It demonstrates that the network correctly learned to
separate the two classes, but it does **not** by itself prove the model would
generalize well to new, real-world images of planes and cars — with so few examples,
the model may simply be memorizing the specific images rather than learning
robust, general features. A meaningful next step would be to retrain on a larger,
more varied dataset of real photographs (dozens or hundreds of images per class)
and/or introduce convolutional layers, to check whether accuracy holds up under
more realistic conditions.
