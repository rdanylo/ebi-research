#male scraper
gender = "male"

exec(open("C:/Users/richa/Desktop/research/parse/"+gender+"/go_bio/go_bio_parser.py").read())
print("Go bio complete.")

exec(open("C:/Users/richa/Desktop/research/parse/"+gender+"/go_cell/go_cell_parser.py").read())
print("Go cell complete.")

exec(open("C:/Users/richa/Desktop/research/parse/"+gender+"/go_mole/go_mole_parser.py").read())
print("Go mole complete.")

exec(open("C:/Users/richa/Desktop/research/parse/"+gender+"/kinase/kinase_parser.py").read())
print("Kinase complete.")

exec(open("C:/Users/richa/Desktop/research/parse/"+gender+"/kegg/kegg_parser.py").read())
print("Kegg complete.")

exec(open("C:/Users/richa/Desktop/research/parse/"+gender+"/panther/panther_parser.py").read())
print("Panther complete.")

exec(open("C:/Users/richa/Desktop/research/parse/"+gender+"/wiki/wiki_parser.py").read())
print("Wiki complete.")

print("Process completed successfully.")
