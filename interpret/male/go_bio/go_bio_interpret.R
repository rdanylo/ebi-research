#Richard Danylo
#Gene Set Interpreter

#load libraries (use install.packages() to download if not installed)
library("readxl")
library("writexl")
library("ggplot2")
library("gridExtra")
library("stringr")

#test type
gender <- "male"
test <- "go_bio"
abr <- "mgb"

#set directories (file locations)
work_dir <- "C:/Users/richa/Desktop/research"

parsed_data <- paste("C:/Users/richa/Desktop/research/parse/",
	gender,"/",test,"/results_",abr,"_parsed.xlsx",sep="")

excel_dir <- paste("C:/Users/richa/Desktop/research/interpret/",
	gender,"/",test,"/results_",abr,"_interpreted.xlsx",sep="")

plot_dir <-  paste("C:/Users/richa/Desktop/research/interpret/",
	gender,"/",test,sep="")

#get gene set data
setwd(work_dir)
df <- read_excel(parsed_data, sheet = "genesets")

#start process
print("Creating interpreted excel...")

#test gene set data
#print(df)

#get number of gene sets
gene_set_count <- nrow(df)

#get gene data (one combined dataframe)
df2 <- c()
for (i in 1:gene_set_count) {
	sheet_name = substring(df$"Gene Set"[i],4)
	temp <- read_excel(parsed_data, sheet = sheet_name)
	df2 <- append(df2, temp)
}

#test gene dataframe to find the first five user ids for 3rd set
#print(df2[2*5+1]$"User ID"[1:5])

#create new blank df3 (and name columns)
df3 <- data.frame("Gene Set" = character(),"User ID" = character(),"Score" = integer(),
"Gene Symbol" = character(),"Gene Name" = character(),
"Entrez Gene ID" = integer(), stringsAsFactors = FALSE)

#get first five genes (and their info) for each set
for (i in 1:gene_set_count) {

	#get gene data
	gene_set_name = c(df$"Gene Set"[i],"","","","")
	user_id = df2[(i-1)*5+1]$"User ID"[1:5]
	score = df2[(i-1)*5+2]$"Score"[1:5]
	symbol = df2[(i-1)*5+3]$"Gene Symbol"[1:5]
	name = df2[(i-1)*5+4]$"Gene Name"[1:5]
	gene_id = df2[(i-1)*5+5]$"Entrez Gene ID"[1:5]
	
	#add to df3
	for (j in 1:5) {
		df3[nrow(df3)+1,] <- c(gene_set_name[j],user_id[j],score[j],symbol[j],name[j],gene_id[j])
	}
}

#test df3
#print(df3)

#create new blank df4 (and name columns)
df4 <- data.frame("Gene_Set" = character(), "Score" = integer(), "Description" = character(), "Tag" = character(), stringsAsFactors = FALSE)
pos_tags <- c()
neg_tags <- c()
first_neg <- 0

#make graph tags for each set
for (i in 1:gene_set_count) {

	#get data for graph
	gene_set_name <- df$"Gene Set"[i]
	gene_set_desc <- df$"Description"[i]
	score <- df$"NES"[i]
	genes <- df2[(i-1)*5+1]$"User ID"[1:5]
	graph_genes <- paste(genes[1], genes[2], genes[3], genes[4], genes[5], sep = ", ")
	
	#create data tag
	if (score >= 0) {
		tag <- graph_genes
		pos_tags <- append(pos_tags, tag)
	} else {
		if (first_neg == 0) {
			first_neg <- i
		}
		#tag <- paste(graph_genes, round(score, digits=2), sep = "   ")
		tag <- graph_genes
		neg_tags <- append(neg_tags, tag)
	}

	#add to df4
	df4[nrow(df4)+1,] <- c(gene_set_name, score, gene_set_desc, tag)
}

#save to excel
write_xlsx(list("firstfive" = df3, "graphtags" = df4), excel_dir)

#print success
print("Process completed successfully.")

#start process
print("Creating plots...")

#create pos/neg dfs
pos <- df[c(1:first_neg-1),]
pos$tag <- paste(pos_tags)

neg <- df[c(first_neg:gene_set_count),]
neg$tag <- paste(neg_tags)

#create plot (pos)
p_plot <- ggplot(data=pos, aes(x=NES, y=reorder(str_wrap(Description, width = 50),
	NES))) + geom_bar(stat="identity", fill="blue") + 
	theme(axis.text.y = element_text(face="bold", color="Black", 
      size=13, angle=0)) + geom_text(aes(label = pos_tags, hjust = 1.06)) +
	labs(x = "Normalized Enrichment Score", y = "") +
	geom_text(aes(label = format(round(NES, digits = 2), nsmall = 2),
	hjust = -0.5)) + xlim(0,3)

#save plot (pos)
ggsave(plot = p_plot, path = plot_dir, filename = "pos_plot.png", width=14, height=8, units='in', dpi=300)

#create plot (neg)
n_plot <- ggplot(data=neg, aes(x=NES, y=reorder(str_wrap(Description, width = 50),
	NES))) + geom_bar(stat="identity", fill="red") +
	theme(axis.text.y = element_text(face="bold", color="Black", 
      size=13, angle=0)) + geom_text(aes(label = neg_tags, hjust = -0.09)) +
	labs(x = "Normalized Enrichment Score", y = "") +
	geom_text(aes(label = format(round(NES, digits = 2), nsmall = 2),
	hjust = 1.3)) + xlim(-3.25,0)

#save plot (neg)
ggsave(plot = n_plot, path = plot_dir, filename = "neg_plot.png", width=14, height=8, units='in', dpi=300)

#print plots to device
#grid.arrange(p_plot, n_plot, ncol=1, nrow=2)

#print success
print("Process completed successfully.")