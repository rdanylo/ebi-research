#Richard Danylo
#Gene Set Presentation

#load libraries (use install.packages() to download if not installed)
library("officer", warn.conflicts = FALSE)
library("ggplot2")

#set directories (file locations and necessary information)
gender <- "female"
go_bio <- c("go_bio","GO Analysis: Biological Process")
go_cell <- c("go_cell","GO Analysis: Cellular Component")
go_mole <- c("go_mole","GO Analysis: Molecular Function")
kinase <- c("kinase","Kinase Target")
kegg <- c("kegg","KEGG Pathway")
panther <- c("panther","Panther Pathway")
wiki <- c("wiki","Wiki Pathway")
save_dir <- paste("C:/Users/richa/Desktop/research/presentation/",gender,"/PAAD_",gender,".pptx",sep = "")
save_dir2 <- paste("C:/Users/richa/Desktop/research/results/PAAD_",gender,".pptx",sep="")

#positive plot slide function
create_pos_slide <- function(doc, gender, img_dir, title_str) {
	src_dir <- paste("C:/Users/richa/Desktop/research/interpret/",gender,"/",img_dir,"/pos_plot.png",sep = "")
	doc <- add_slide(x = doc, layout = "Title and Content")
	doc <- ph_with(x = doc, "slide 2", value = c(title_str), location = ph_location_type(type = "title"))
	pos_img <- external_img(src = src_dir, height = 5.5, width = 9)
	doc <- ph_with(x = doc, value = pos_img, location = ph_location_type(type = "body"), use_loc_size = FALSE)
}

#negative plot slide function
create_neg_slide <- function(doc, gender, img_dir, title_str) {
	src_dir <- paste("C:/Users/richa/Desktop/research/interpret/",gender,"/",img_dir,"/neg_plot.png",sep = "")
	doc <- add_slide(x = doc, layout = "Title and Content")
	doc <- ph_with(x = doc, "slide 2", value = c(title_str), location = ph_location_type(type = "title"))
	neg_img <- external_img(src = src_dir, height = 5.5, width = 9)
	doc <- ph_with(x = doc, value = neg_img, location = ph_location_type(type = "body"), use_loc_size = FALSE)
}

#combined plot slides function
plot_slides <- function(doc, test) {
	doc <- create_pos_slide(doc, gender, test[1], test[2])
	doc <- create_neg_slide(doc, gender, test[1], test[2])
}

#start process
print("Creating powerpoint...")

#create powerpoint
doc <- read_pptx()

#add title slide
doc <- add_slide(x = doc, layout = "Title Slide")
doc <- ph_with(x = doc, "slide 1", value = c("PAAD Analysis"), location = ph_location_type(type = "ctrTitle"))
doc <- ph_with(x = doc, "slide 1", value = c(paste(toupper(gender)," Subject")), location = ph_location_type(type = "subTitle"))

#add association plot slide
a_dir <- paste("C:/Users/richa/Desktop/research/interpret/",gender,"/association/a_plot.png",sep = "")
doc <- add_slide(x = doc, layout = "Title and Content")
doc <- ph_with(x = doc, "slide 2", value = c("GHR Association Results"), location = ph_location_type(type = "title"))
a_img <- external_img(src = a_dir, height = 5, width = 6)
doc <- ph_with(x = doc, value = a_img, location = ph_location_type(type = "body"), use_loc_size = FALSE)

#add go_bio slides
plot_slides(doc, go_bio)
plot_slides(doc, go_cell)
plot_slides(doc, go_mole)
plot_slides(doc, kinase)
plot_slides(doc, kegg)
plot_slides(doc, panther)
plot_slides(doc, wiki)

#save powerpoint
print(doc, target = save_dir)
print(doc, target = save_dir2)

#check for success
print("Process completed successfully.")
