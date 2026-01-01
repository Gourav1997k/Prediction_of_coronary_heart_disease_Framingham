library(ggplot2)
library(dplyr)
library(tidyverse)
library(knitr)
library(mlr)
library(dummies)
library(lsr)

#reading the data file and removing all the N/A values
setwd("D:/heart-disease-prediction-using-logistic-regression")


data = read.csv("framingham.csv",header=T)
data1 = na.omit(data)
data1 = tbl_df(data1)




head = head(data1,10)

#Revealing the data about its contents
str(data1)

#visualisation using ggplot
ggplot(data = male, aes(x = as.factor(male)))+geom_bar()

#visualizing the distribution of each of the variables
par(mfrow = c(4,4))
hist(data1$male,col='blue',main='histogram of male and female',xlab='males(0 for female and 1 for male)')

hist(data1$age,col='blue',main='histogram of age',xlab='age')

hist(data1$education,col='blue',main='histogram of education',xlab='education')

hist(data1$currentSmoker,col='blue',main='histogram of current smokers',xlab='current smokers(1 for a current smoker and 0 for non-smoker)')

hist(data1$cigsPerDay,col='blue',main='histogram of cigarretes consumed/day',xlab='cigs/day')

hist(data1$prevalentHyp,col='blue',main='histogram of hypertension',xlab='hypertension( 1 for presence of hyp and 0 for absence)')

hist(data1$diabetes,col='blue',main='histogram of history of diabetes',xlab='diabetes(1 for presence of daibetes and 0 for absence)')

hist(data1$totChol,main='histogram of total cholestrol',xlab='total cholestrol',col='blue')

hist(data1$sysBP,col='blue',main='histogram of systolic BP',xlab='Systolic BP')

hist(data1$diaBP,col='blue',main='histogram of diastolic BP',xlab='diastolic BP')

hist(data1$BMI,col='blue',main='histogram of BMI',xlab='BMI')

hist(data1$heartRate,col='blue',main='histogram of heart rate',xlab='heart rate')

hist(data1$glucose,col='blue',main='histogram of glucose',xlab='glucose content')

hist(data1$TenYearCHD,col = 'blue', main='Histogram of people having CHD', xlab='1 indicates presence of CHD and 0 indicates absence')

hist(data1$BPMeds, col='blue', main='histogram of BP medication', xlab='BPMeds(1 for taking meds and 0 for not taking)')

hist(data1$prevalentStroke,col='blue', main='histogram of Prevalent stroke history', xlab='cases of Stroke(1 for history of strokes and 0 for none)')
#summary of the data 

summ = (summary(data1))
data1 = cbind(data1,dummy(data1$education, sep = '.'))

data1 = data1 %>% select(-education)
data1 = data1 %>% select(-data1.1)


#keeping the categoricals and the numericals in two separate datasets
d1.c = data1 %>%
           select(male, currentSmoker, BPMeds, prevalentStroke,prevalentHyp,diabetes,data1.2,
                  data1.3,data1.4)
cat = c("male", "currentSmoker", "BPMeds", "prevalentStroke","prevalentHyp","diabetes","data1.2",
        "data1.3","data1.4")
d1.n = data1 %>% select(age, cigsPerDay, totChol, sysBP, diaBP, BMI, heartRate, glucose) 


#to find the correlation matrix among the numerical variables
par(mfrow= c(2,1))
library(ggcorrplot)
correlations = cor(d1.n)
ggcorrplot(correlations, hc.order = TRUE, type = "lower",
           lab = TRUE)
d1.n = d1.n %>% select(-sysBP)
data1 = data1 %>% select(-sysBP)
#To find the correlation among the categorical variables using Cramers V
get.V <- function(y) {
      col.y <- ncol(y)
       V <- matrix(ncol=col.y,nrow=col.y)
       for(i in 1:col.y){
             for(j in 1:col.y){
                   V[i,j] <- round(cramersV(y[,i], y[,j]), 2)
               }
         }
       return(V)
   }

rs = get.V(d1.c)
colnames(rs) = c("male", "currentSmoker", "BPMeds", "prevalentStroke","prevalentHyp","diabetes","data1.2",
                 "data1.3","data1.4")

rownames(rs) = c("male", "currentSmoker", "BPMeds", "prevalentStroke","prevalentHyp","diabetes","data1.2",
                 "data1.3","data1.4")

ggcorrplot(rs, hc.order = TRUE, type = "lower",
           lab = TRUE)

#Keeping the significant variables in the dataset
#features = c("male","age","education","cigsPerDay","BPMeds","prevalentStroke",
             "totChol","sysBP","BMI","heartRate","glucose","TenYearCHD")#
#data1 = data1[features]


# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(data1$TenYearCHD, SplitRatio = 0.75)
training_set = subset(data1, split == TRUE)
test_set = subset(data1, split == FALSE)

#Fitting the logistic regression to the training set
model = glm(formula = TenYearCHD ~ .
            ,family = binomial
            ,data = training_set)


#Predicting the test set results
pred = predict(model , type = 'response',newdata = test_set[-15])
y_pred = ifelse(pred>0.5, 1, 0)

#making the confusion matrix
confusion_mat = table(test_set[,15],y_pred)

#checking the accuracy of the model
summary(model)

#visualising the training set results
AIC(model)

#To see which of the explanatory variables are important
library(MASS)

new_model = glm(formula = TenYearCHD ~ .
                ,family = binomial
                ,data = training_set)
summary(new_model)
#Fitting the model by including all the relevant variables
step_model = stepAIC(model,direction = "backward",trace = 1)

#summary of the model
summary(step_model)
#predicting the value from the test set
ypred_1 = predict(step_model , type = 'response',newdata = test_set[-15])
pred_11 = predict(step_model, type='response',newdata = training_set[-15])#Checking for overfitting in the training set
y_pred__test = ifelse(ypred_1>0.5, 1, 0)
y_pred_train= ifelse(pred_11>0.5, 1, 0)#Probabilities for prediction in the training set

confusion_mat_1 = table(test_set[,15],y_pred__test)
confusion_mat_2 = table(training_set[,15],y_pred_train)
#To check for multicollinearity in the new model
library(car)

vif(step_model) #VIF of 5 or 10 indicates serious multicollinearity

#Plotting the ROC AUC curve 
library(Deducer)
rocplot(step_model) #An AUC of 0.737 means that the discrimination is acceptable

#Displaying the Odds ratio
library(epiDisplay)
logistic.display(step_model)

#Displying the sensitivity, specificity, accuracy, misclassification
library(caret)
confusionMatrix(confusion_mat_1,positive='1') #For the confusion matrix of the test set
confusionMatrix(confusion_mat_2, positive = '1') #for confusion matrix of the training set

