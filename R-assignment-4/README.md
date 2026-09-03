# Image Recognition & Classification in R (Planes vs Cars)

## Project Title and Objective
This project implements an image classification model in R that distinguishes between
images of **planes** and **cars** using a simple feed-forward Artificial Neural Network (ANN)
built with Keras/TensorFlow. It reproduces the workflow demonstrated in the reference
video tutorial and follows an end-to-end data science pipeline: data loading, preprocessing,
model building, training, evaluation, and result interpretation.

**Reference video:** https://www.youtube.com/watch?v=iExh0qj2Ouo

## Problem Description
Given a small set of labeled images (planes and cars), the goal is to train a neural
network that can correctly classify a new, unseen image as either a **plane (0)** or a
**car (1)**. This is a binary image classification problem solved without using
convolutional layers, to demonstrate how raw pixel data can be fed directly into a
dense neural network.

## Dataset Information
- **Size:** 12 images total — 6 images of planes (`p1.jpg`–`p6.jpg`) and 6 images of
  cars (`c1.jpg`–`c6.jpg`), stored in the `dataset/` folder of this repository.
- **Split:** 10 images used for training (5 planes + 5 cars), 2 images held out for
  testing (1 plane + 1 car).
- **Preprocessing:** every image is resized to 28×28 pixels (3 color channels) and
  reshaped into a flat vector of length 2352 (28 × 28 × 3) before being fed into the
  network.
- **Note:** the images included here are simple generated placeholder graphics
  (not real photographs) so the project can be run and verified end-to-end without
  external downloads. Replace the files in `dataset/` with your own plane/car photos
  (keeping the same filenames) to train on real images.

## R Packages / Libraries Used
- `EBImage` — reading, resizing, and reshaping images
- `keras` — building, compiling, and training the neural network
- `tensorflow` — backend engine used by Keras

## Major Operations Performed
1. Read 12 raw images into R.
2. Explore image properties (dimensions, pixel summary, histogram).
3. Resize all images to a uniform 28×28×3 size.
4. Reshape images into flat numeric vectors.
5. Split data into training (10 images) and test (2 images) sets.
6. One-hot encode the class labels.
7. Build a Sequential ANN: Dense(256, relu) → Dense(128, relu) → Dense(2, softmax).
8. Compile with `binary_crossentropy` loss and `rmsprop` optimizer.
9. Train for 30 epochs with an 80/20 train/validation split.
10. Evaluate the model and generate predictions/confusion matrices on both the
    training and test sets.

## Instructions to Execute the Project
1. Open `image_classification.R` in RStudio, or paste its cells into a
   Google Colab notebook with the **R runtime** selected
   (`Runtime → Change runtime type → R`).
2. Install dependencies (see the commented block at the top of the script):
   `EBImage` (via `BiocManager`) and `keras` (with `install_keras()`).
3. Upload/copy the 12 images from the `dataset/` folder into your working directory
   (`/content` in Colab, or the script's working directory in RStudio).
4. Run the script top to bottom. Training progress and accuracy/loss curves will be
   displayed after the `fit()` step.
5. Confusion matrices for the training and test sets are printed at the end.

## Important Results / Output
- **Model:** Dense(256, relu) → Dense(128, relu) → Dense(2, softmax) — 635,522 total parameters.
- **Training set:** loss = 0.0072, accuracy = **100%** (10/10 images correctly classified: 5 planes, 5 cars).
- **Test set:** loss = 0.0072, accuracy = **100%** (2/2 held-out images correctly classified), with
  prediction confidence above 99.99% for the correct class in both cases.

Full evaluation output, confusion matrices, and predicted probabilities are in
`results/RESULTS.md`.

**Interpretation:** The model perfectly separated planes from cars on this small dataset.
Given the very small sample size (6 images per class), this high accuracy reflects how
easily a network can fit a tiny, visually distinct dataset, and should not be read as
proof of strong generalization — a larger, more varied set of real photographs would be
needed to properly validate the model.

## Screenshots
Add screenshots of:
- The model summary (`summary(model)`)
- The training/validation accuracy and loss plot (`plot(history)`)
- The training-set and test-set confusion matrices

Place them in a `screenshots/` folder and reference them here, e.g.:
```markdown
![Training accuracy/loss](screenshots/training_plot.png)
![Confusion matrix](screenshots/confusion_matrix.png)
```

## Repository Structure
```
.
├── image_classification.R   # Full R script (all pipeline steps)
├── dataset/                 # 12 sample images (p1-p6 planes, c1-c6 cars)
├── results/
│   └── RESULTS.md           # Actual evaluation output, confusion matrices, predictions
├── screenshots/             # Add your execution screenshots here
└── README.md
```
