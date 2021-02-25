#Richard Danylo
#Gene Set Interpreter

#load libraries (use install.packages() to download if not installed)
library("readxl")
library("ggplot2")
library("gridExtra")

#gender
gender <- "female"

#set directories (file locations)
work_dir <- "C:/Users/richa/Desktop/research"
raw_data <- paste("C:/Users/richa/Desktop/research/raw/",gender,"/association/association.xlsx",sep="")
plot_dir <- paste("C:/Users/richa/Desktop/research/interpret/",gender,"/association",sep="")

#get gene set data
setwd(work_dir)
df <- read_excel(raw_data)

#correct pvalue column name
colnames(df)[3] <- "P_value"

#test gene set data
#print(df)

#get number of genes
#gene_count <- nrow(df)

#start process
print("Creating association result plot...")

#create plot
a_plot <- ggplot(data=df, aes(x=Statistic, y=-log10(P_value), colour=Statistic>0))
a_plot <- a_plot + geom_point() + geom_text(aes(label=Query, colour="Black"),size=2,nudge_x=ifelse(df$Statistic>0,0.1,-0.1))
a_plot <- a_plot + scale_colour_manual(values = c("Black","Green","Red"))
a_plot <- a_plot + xlab("Pearson Correlation Coefficient") + ylab("-log10(pvalue)")
a_plot <- a_plot + theme(legend.position = "none")

#print association plot to device
#print(a_plot)

#save plot
ggsave(plot = a_plot, path = plot_dir, filename = "a_plot.png", width=6, height=5, units='in', dpi=300)

#print all plots to device
#grid.arrange(a_plot, ncol=1, nrow=1)

#add in heatmap functionality!!!!!!!!!!!!!!!

#print success
print("Process completed successfully.")