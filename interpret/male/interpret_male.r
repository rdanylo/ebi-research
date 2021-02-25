#Richard Danylo
#Gene Set Interpreter

gender <- "male"

#start process
print("Starting interpreter...")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/go_bio/go_bio_interpret.r",sep=""))
print("Go bio complete.")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/go_cell/go_cell_interpret.r",sep=""))
print("Go cell complete.")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/go_mole/go_mole_interpret.r",sep=""))
print("Go mole complete.")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/kinase/kinase_interpret.r",sep=""))
print("Kinase complete.")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/kegg/kegg_interpret.r",sep=""))
print("Kegg complete.")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/panther/panther_interpret.r",sep=""))
print("Panther complete.")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/wiki/wiki_interpret.r",sep=""))
print("Wiki complete.")

source(paste("C:/Users/richa/Desktop/research/interpret/",gender,"/association/association.r",sep=""))
print("Association complete.")

print("Process completed successfully.")