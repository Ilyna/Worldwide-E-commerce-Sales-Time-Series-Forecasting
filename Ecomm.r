
library(forecast)
setwd("/Users/Yann-bor Wen/Documents/Graduate School/Econ 5337")
getwd()

temp=read.csv("ecomm.csv")
temp

ecomm=ts(temp[,2],start=c(1999,3),end=c(2018,3),frequency=4)
ecomm
ecommHOLD=ts(temp[,2],start=c(1999,3),end=c(2017,3),frequency=4)
ecommHOLD

plot(ecomm)
seasonplot(ecomm)

#Perform Unit root test on original data
library(urca)
summary(ur.df(ecommHOLD,type="trend",selectlags="AIC",lags=32))

acf(diff(ecommHOLD),40)
pacf(diff(ecommHOLD),40)

#Perform Unit root test on differenced data
summary(ur.df(diff(ecommHOLD),type="trend",selectlags="AIC",lags=32))

#Binding the seasonally differenced data before performing unit root test
z=c(diff(ecommHOLD),4)
z

#Perform Unit root test on the seasonally differenced data
library(urca)
summary(ur.df(z,type="trend",selectlags="AIC",lags=32))

#plot acf and pacf of differenced and seasonally differenced data
acf(diff(diff(ecommHOLD),4),40)
pacf(diff(diff(ecommHOLD),4),40)

Initial=Arima(ecommHOLD,order=c(1,1,1),seasonal=c(0,0,1),method="ML")
acf(Initial$residuals,40)
pacf(Initial$residuals,40)

Model1=Arima(ecommHOLD,order=c(2,1,1),seasonal=c(1,1,1))
acf(Model1$residuals,40)
pacf(Model1$residuals,40)

Model=Arima(ecommHOLD,order=c(1,1,1),seasonal=c(1,0,1),method="ML")
acf(Model$residuals,40)
pacf(Model$residuals,40)

Model3=Arima(ecommHOLD,order=c(1,1,1),seasonal=c(1,1,1))
acf(Model3$residuals,40)
pacf(Model3$residuals,40)

Model4=Arima(ecommHOLD,order=c(2,1,1),seasonal=c(1,0,1))
acf(Model4$residuals,40)
pacf(Mode4$residuals,40)

Model3

Model5=Arima(ecommHOLD,order=c(1,1,1),seasonal=c(1,1,2))
acf(Model4$residuals,40)
pacf(Mode4$residuals,40)
Model5

Box.test(Model3$residuals,40,type="Ljung-Box")

# Make predictions
pred = forecast(Model3,h=4)
pred
upper=ts(pred$upper[,1],start=c(2017,4),frequency=4)
lower=ts(pred$lower[,1],start=c(2017,4),frequency=4)
winDATA=window(ecomm,start=c(2015,4),end=c(2018,3))         
plot(cbind(winDATA,pred$mean,upper,lower),plot.type="single",ylab="Forecast %",main="Forecast % Digital Sales",col=c("BLACK","BLUE","RED","GREEN"))

# Compare with ets
e = ets(diff(ecommHOLD))
f = forecast(e,h=4)
e

# Compare with hw
holt = hw(ecommHOLD,h=4,trend="additive",seasonal="additive")
holt


w = window(ecomm,start=c(2017,4),end=c(2018,3))
predi = forecast(Initial,h=4)
predm = forecast(Model,h=4)
data.table(w)

data.table(
  Error = c("RMSE","ME"),
  HoltWinters = c(sqrt(sum((holt$mean-w)^2)/4),sum(holt$mean-w)/4),
  InitialSARIMA = c(sqrt(sum((predi$mean-w)^2)/4),sum(predi$mean-w)/4),
  FinalSARIMA = c(sqrt(sum((pred$mean-w)^2)/4),sum(pred$mean-w)/4)
)

upper=ts(holt$upper[,1],start=c(2017,4),frequency=4)
lower=ts(holt$lower[,1],start=c(2017,4),frequency=4)
plot(cbind(winDATA,holt$mean,upper,lower),plot.type="single",ylab="Forecast %",main="Forecast % Digital Sales",col=c("BLACK","BLUE","RED","GREEN"))

Model4=Arima(ecomm,order=c(1,1,1),seasonal=c(1,1,1))
pred = forecast(Model4,h=4)
upper=ts(pred$upper[,1],start=c(2018,4),frequency=4)
lower=ts(pred$lower[,1],start=c(2018,4),frequency=4)
winDATA=window(ecomm,start=c(2010,4),end=c(2018,4))         
plot(cbind(winDATA,pred$mean,upper,lower),plot.type="single",ylab="Forecast %",main="Forecast % Digital Sales",col=c("BLACK","BLUE","RED","GREEN"))

