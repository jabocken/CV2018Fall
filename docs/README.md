TODO: abstract

![Given picture and component bounding boxes, isolate components, and using CNN
and other methods, classify!](figures/teaser.png)

# Introduction

# Methodology

# Results

## Color histogram and k-nearest-neighbor search

## Convolutional neural network
The figure below shows training of a basic CNN with three convolutional layers
separated by max-pooling layers and terminated with a soft-max-loss layer over
75 epochs. We used four fifths of the component images, all resized to 32x32,
for the training set and the remaining fifth as the validation set;
in other words, this was one fold of a five-fold cross-validation.
We chose 75 epochs as going beyond that seemed to result in overfitting on the
training data (the objective function value for the validation set began
increasing past that point as well as, to a lesser extent, the top-1 error).
![Training epochs](figures/cnn_train.png)

With full five-fold cross-validation, we obtained an average classification
accuracy of 83.2% for the above-described CNN model.

# Conclusion

# References
