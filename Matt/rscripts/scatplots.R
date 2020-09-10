library(ggplot2)
library(gghighlight)

load(file = "/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvm.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvmb.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvnr.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/vobjanalysisrvnrb.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/vobjanalysisnrvm.Rdata")
load(file = "/home/matthew/Documents/BSPIData/rdata/vobjanalysisnrvmb.Rdata")

x <- vobj_analysis_rvnr_bric[["msviper"]][["es"]][["nes"]]
y <- vobj_analysis_rvnr[["msviper"]][["es"]][["nes"]]

s <- vobj_analysis_rvm_bric[["msviper"]][["es"]][["nes"]]
t <- vobj_analysis_rvm[["msviper"]][["es"]][["nes"]]

p <- vobj_analysis_nrvm_bric[["msviper"]][["es"]][["nes"]]
q <- vobj_analysis_nrvm[["msviper"]][["es"]][["nes"]]

dx <- data.frame(x)
dy <- data.frame(y)

ds <- data.frame(s)
dt <- data.frame(t)

dp <- data.frame(p)
dq <- data.frame(q)

dv1 <- merge(dx,dy, by = "row.names")
row.names(dv1) <- dv1$Row.names

dv2 <- merge(ds,dt, by = "row.names")
row.names(dv2) <- dv2$Row.names

dv3 <- merge(dp,dq, by = "row.names")
row.names(dv3) <- dv3$Row.names

colnames(dv1)[colnames(dv1) == "Row.names"] <- "Names"
colnames(dv2)[colnames(dv2) == "Row.names"] <- "Names"
colnames(dv3)[colnames(dv3) == "Row.names"] <- "Names"


ggplot(dv1, aes(x,y, label=Names)) + theme_light() + geom_point(color="gray") + geom_text(aes(label=ifelse((y>2.0) , as.character(Names), ''))) + ggtitle("Responder vs Non-Responder") + scale_x_continuous("METABRIC") + scale_y_continuous("TGCA") + geom_smooth(method = "lm")


ggplot(dv1, aes(x,y, label=Names)) + theme_light() + geom_point(color="gray") + geom_text(aes(label=ifelse((y<(-2.0)) , as.character(Names), ''))) + ggtitle("Responder vs Non-Responder") + scale_x_continuous("METABRIC") + scale_y_continuous("TGCA") + geom_smooth(method = "lm")


ggplot(dv3, aes(p,q, label=Names)) + theme_light() + geom_point(color="gray") + geom_text(aes(label=ifelse((y>2.0) , as.character(Names), ''))) + ggtitle("Metastasis vs Non-Responder") + scale_x_continuous("METABRIC") + scale_y_continuous("TGCA") + geom_smooth(method = "lm")


ggplot(dv3, aes(p,q, label=Names)) + theme_light() + geom_point(color="gray") + geom_text(aes(label=ifelse((y<(-2.0)) , as.character(Names), ''))) + ggtitle("Metastasis vs Non-Responder") + scale_x_continuous("METABRIC") + scale_y_continuous("TGCA") + geom_smooth(method = "lm")




ggplot(dv2, aes(s,t, label=Names)) + theme_light() + geom_point(color="gray") + geom_text(aes(label=ifelse((y>2.0) , as.character(Names), ''))) + ggtitle("Responder vs Metastasis") + scale_x_continuous("METABRIC") + scale_y_continuous("TGCA") + geom_smooth(method = "lm")


ggplot(dv2, aes(s,t, label=Names)) + theme_light() + geom_point(color="gray") + geom_text(aes(label=ifelse((y<(-2.0)) , as.character(Names), ''))) + ggtitle("Responder vs Metastasis") + scale_x_continuous("METABRIC") + scale_y_continuous("TGCA") + geom_smooth(method = "lm")
