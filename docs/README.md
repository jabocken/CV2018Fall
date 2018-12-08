TODO: abstract

# Introduction

# Methodology

## Dataset Generation

Before we could perform any form of object classification, we needed to find or
generate a dataset of PCB components. We first searched for existing datasets.
The only candidate we found in our search was the [PCB DSLR
Dataset](https://cvl.tuwien.ac.at/research/cvl-databases/pcb-dslr-dataset/) from
[the Computer Vision Lab at TU Wien](https://cvl.tuwien.ac.at/). This dataset
consists of 748 high-resolution images of PCBs from a recycling facility, as
well as segmentation information and bounding boxes. The authors' stated intent
for this dataset is that it be used to "facilitate research on
computer-vision-based Printed Circuit Board (PCB) analysis, with a focus on
recycling-related applications."

Unfortunately, we decided after some review that this would not suffice for our
purposes for a number of reasons.

*  First, the dataset only contains segmentation information and bounding boxes
   for large integrated circuits (ICs), such as embedded processors and memory
   controllers. We sought to identify a wider variety of components.
*  Next, dust and debris obscure many of the components on the PCBs in these
   images, a result of authors' use of PCBs from a recycling center. This
   complicated our efforts to add our own segmentation information to the
   images.
*  Furthermore, the large size of each image (4928x3280~pixels), meant it would
   be difficult to supplement the included labels with our own in a timely
   fashion. 
*  Finally, without detailed information about the design of the PCBs, we
   realized that we would not be able to generate sufficiently accurate
   annotations on our own.

![Example image from PCB DSLR Dataset. Note the large number of components, as
well as the dust obscuring many of the
components.](figures/pcb_dslr_example.jpg)

Faced with these challenges, and with no other strong candidate datasets, we
decided our best course of action involved generating our own dataset. We
identified three criteria that needed to be met for our purposes:

*  First, the PCBs in the images needed to contain a variety of components,
   including resistors, capacitors, diodes, inductors, LEDs, and ICs, but not in
   such quantities that hand-labeling them required an unreasonable amount of
   time.
*  Next, each PCB needed to be clear of artifacts, whether visual (e.g.,
   blurriness) or physical (e.g., dust).
*  Finally, we needed access to a detailed listing of the components on each
   PCB, including their locations on the board, to allow accurate labeling of
   the ground truths for each image.

The third criterion in particular was a source of difficulty for us until we
settled on the use of *open-source hardware* -- hardware designs that include
all of the necessary design files (e.g., EAGLE source files). As a result, we
decided on constructing a database using images of products from [Adafruit
Industries](https://www.adafruit.com/), an open-source hardware company known
for its support of electronic hobbyists. Adafruit provides the EAGLE source
files for most of its internally-designed PCBs, allowing us to hand-label images
of these PCBs with a high degree of accuracy.

We identified six components for classification: resistors (R), capacitors (C),
inductors (H), diodes (D), LEDs (L), and integrated circuits (ICs). For each
image in our dataset, we used [MATLAB's Image Labeler
tool](https://www.mathworks.com/help/vision/ref/imagelabeler-app.html) to
outline these components. The corresponding EAGLE PCB layout files served as our
reference.  From the resulting `groundTruth` objects, we extracted bounding
boxes and cropped each image to generate our actual dataset of component images
and labels.

## Object Classification

With our dataset generated, we moved onto the object classification problem.
After researching the various methods available, we settled on testing two
different approaches and comparing the accuracies. The first approach generated
color histograms for each image and trained a variety of supervised classifiers
using [MATLAB's Classification
Learner](https://www.mathworks.com/help/stats/classificationlearner-app.html)
tool. Specifically, this tool trains and scores the following types of learners
in parallel:

* Decision Trees
* Linear and Quadratic Discriminant Analysis
* Support Vector Machines
* Nearest-neighbor Classifiers
* Ensemble Classifiers

[//] # (TODO: Josh, can you fill in here?)
The second approach used convolutional neural networks.

# Results

# Conclusion

# References
