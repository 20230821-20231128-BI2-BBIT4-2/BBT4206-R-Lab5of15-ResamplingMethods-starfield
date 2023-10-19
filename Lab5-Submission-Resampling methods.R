# If renv::restore() did not install the "languageserver" package (required to
# use R for VS Code), then it can be installed manually as follows (restart R
# after executing the command):

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}


# STEP 1. Install and Load the Required Packages ----
## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## klaR ----
if (require("klaR")) {
  require("klaR")
} else {
  install.packages("klaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## LiblineaR ----
if (require("LiblineaR")) {
  require("LiblineaR")
} else {
  install.packages("LiblineaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naivebayes ----
if (require("naivebayes")) {
  require("naivebayes")
} else {
  install.packages("naivebayes", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}


# DATASET 1 (Splitting the dataset): Pima Indians Diabetes ----
if (!is.element("mlbench", installed.packages()[, 1])) {
  install.packages("mlbench", dependencies = TRUE)
}
require("mlbench")

data("PimaIndiansDiabetes")
summary(PimaIndiansDiabetes)

# The str() function is used to compactly display the structure (variables
# and data types) of the dataset
str(PimaIndiansDiabetes)
## 1. Split the dataset ====
# Define a 75:25 train:test data split of the dataset.
# That is, 75% of the original data will be used to train the model and
# 25% of the original data will be used to test the model.
train_index <- createDataPartition(PimaIndiansDiabetes$diabetes,
                                   p = 0.75,
                                   list = FALSE)
Pima_Indians_Diabetes_dataset_train <- PimaIndiansDiabetes[train_index, ]
Pima_Indians_Diabetes_dataset_test <- PimaIndiansDiabetes[-train_index, ]

### 2.a. OPTION 1: naiveBayes() function in the e1071 package ----
# The "naiveBayes()" function (case sensitive) in the "e1071" package
# is less sensitive to missing values hence all the features (variables
# /attributes) are considered as independent variables that have an effect on
# the dependent variable (diabetes).
Pima_Indians_Diabetes_dataset_model_nb_e1071 <- # nolint
  e1071::naiveBayes(diabetes ~ pregnant + glucose + pressure + triceps + insulin + mass +
                      pedigree + age,
                    data = Pima_Indians_Diabetes_dataset_train)

## 3. Test the trained model using the testing dataset ----
### 3.a. Test the trained e1071 Naive Bayes model using the testing dataset ----
predictions_nb_e1071 <-
  predict(Pima_Indians_Diabetes_dataset_model_nb_e1071,
          Pima_Indians_Diabetes_dataset_test[, c("pregnant", "glucose", "pressure", "triceps",
                                     "insulin", "mass", "pedigree",
                                     "age"
                                     )])

## 4. View the Results ----
### 4.a. e1071 Naive Bayes model and test results using a confusion matrix ----
# Please watch the following video first: https://youtu.be/Kdsp6soqA7o
print(predictions_nb_e1071)
caret::confusionMatrix(predictions_nb_e1071,
                       Pima_Indians_Diabetes_dataset_test[,c("pregnant", "glucose", "pressure", "triceps",
                                                             "insulin", "mass", "pedigree",
                                                             "age", "diabetes")]$diabetes)

plot(table(predictions_nb_e1071,
           Pima_Indians_Diabetes_dataset_test[,c ("pregnant", "glucose", "pressure", "triceps",
                                                 "insulin", "mass", "pedigree",
                                                 "age", "diabetes")]$diabetes))
