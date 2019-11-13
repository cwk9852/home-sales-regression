#load required packages
require(caret);
require(dplyr)
require(PerformanceAnalytics);

#Import Data
housing.testing <- read.csv(file = "housing.testing.csv");
housing.training <- read.csv(file = "housing.training.csv");
housing.training <- housing.training[,-1]; #removing the ID's
housing.testing <- housing.testing[,-1]; #removing the ID's
housing.combined <- rbind(housing.training, housing.testing); #make a combined dataframe
min(housing.combined$YrSold);
max(housing.combined$YrSold);
dim(housing.training);
str(housing.training);

#Summary Statistics
summary(housing.training);
summary(housing.testing);
sd(housing.training$SalePrice);
sd(housing.testing$SalePrice);

#Histograms
par(mfrow=c(1,2));
hist(housing.training$SalePrice, xlab="Sale Price", main="Histogram for Training");
hist(housing.testing$SalePrice, xlab="Sale Price", main="Histogram for Testing");
par(mfrow=c(1,3));
hist(housing.training$SalePrice, xlab="Sale Price", main="Histogram for Training");
hist(housing.testing$SalePrice, xlab="Sale Price", main="Histogram for Testing");
hist(housing.combined$SalePrice, xlab="Sale Price",main="Histogram for Combined");

#correlation plot for all variables removing NAs
par(mfrow=c(1,1));
cor <- cor(housing.training); #calculate correlation coefficients
cor.sorted <- as.matrix(sort(cor[,'SalePrice'], decreasing = TRUE)); #sorting
cor.final <- names(which(apply(cor.sorted, 1, function(x) abs(x)>0.0))); #removing NAs
cor <- cor[cor.final, cor.final];
corrplot.mixed(cor, tl.col="black", tl.pos = "lt");

#corrplot for with correlation > %50 
cor <- cor(housing.training); #reset cor
cor.sorted <- as.matrix(sort(cor[,'SalePrice'], decreasing = TRUE)); #sorting
cor.high <- names(which(apply(cor.sorted, 1, function(x) abs(x)>=0.1))); #filtering above 0.5.
cor <- cor[cor.high, cor.high];
corrplot.mixed(cor, tl.col="black", tl.pos = "lt");

#Fit linear regresson using training data: 
lin.mod<-lm(SalePrice~., data=housing.training)
summary(lin.mod)
#Predict housing price

housing.testing.completeCases <- housing.testing[complete.cases(housing.testing),]
pred<-predict(lin.mod, housing.testing.completeCases[1:20,])
actual<-housing.testing.completeCases$SalePrice[1:20]
comparison<-cbind(pred, actual)
par(mfrow=c(1,1))
plot(comparison)
