Visual analysis of the components on a printed circuit board (PCB) can provide
additional security and quality assurance. For this reason, we decided to use
computer vision techniques to classify PCB components by type (resistor,
capacitor, etc.), achieving around 80% accuracy with the methodologies we tried.

![Given picture and component bounding boxes, isolate components, and using CNN
and other methods, classify!](figures/teaser.png)

# Introduction
[Recent events in the field of hardware security](https://www.bloomberg.com/news/features/2018-10-04/the-big-hack-how-china-used-a-tiny-chip-to-infiltrate-america-s-top-companies),
[whether true or not](https://www.zdnet.com/article/super-micro-trashes-bloomberg-chip-hack-story-in-recent-customer-letter/),
have shined light on the issue of ensuring hardware security in a world where
supply chains are not necessarily secure. In that light, ensuring that the
components on a PCB are only those that are supposed to be there can improve
security guarantees and, more prosaically, be useful for quality-assurance
purposes. For this reason, we investigated visual classification of the
components on PCBs using photographs taken with standard cameras. Previous work
in this area includes defect analysis
[[1](https://ijarcsse.com/docs/papers/Volume_7/6_June2017/V7I6-0176.pdf),
[2](https://research.ijcaonline.org/ncfaaiia/number2/ncfaaiia1014.pdf)]
and identification of specific integrated circuits (ICs) for recycling purposes
[[3](https://cvl.tuwien.ac.at/research/cvl-databases/pcb-dslr-dataset/)].

# Methodology

# Results

## Color histogram and k-nearest-neighbor search

## Convolutional neural network (CNN)
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
