#Richard Danylo
#Gene Set Parser

#import modules
from http.server import HTTPServer, CGIHTTPRequestHandler
from pandas.io.html import read_html
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import threading
import webbrowser
import pandas as pd
import xlsxwriter
import os

#set working directory to research folder
os.chdir("C:/Users/richa/Desktop/research")

#urls to the report.html file and name of save file
server_url = "http://localhost:8000/raw/female/kinase/report.html"
save_url = "C:/Users/richa/Desktop/research/parse/female/kinase/results_fki_parsed.xlsx"

#start process
print("Starting scraper...")

#function to start server
def startServer():
    httpd = HTTPServer(("localhost", 8000), CGIHTTPRequestHandler)
    print("Starting simple_httpd on port: " + str(httpd.server_port))
    httpd.serve_forever()

#start the server in a background thread
server = threading.Thread(target=startServer, daemon=True)
server.start()

#test the server (only use if you need to check the thread and server start)
#webbrowser.open('http://localhost:8000/male/go_bio/report.html', new=2)

#open and render js
options = webdriver.ChromeOptions()
options.add_argument("start-maximized");
options.add_argument("disable-infobars")
options.add_argument("--disable-extensions")
driver = webdriver.Chrome(chrome_options=options)
driver.get(server_url)

#make table and select visible
driver.find_elements_by_xpath("/html/body/main/div/div[2]/section[3]/div[1]/nav/ul/li[1]/a")[0].click()

#extend the tables results
WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, "/html/body/main/div/div[2]/section[3]/div[1]/section/div[1]/div/div[2]/span/select/option[@value='1000']"))).click()

#sort table by NES
NES_sort_button = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, "/html/body/main/div/div[2]/section[3]/div[1]/section/div[1]/div/div[1]/div[2]/table/thead/tr/th[6]")))
NES_sort_button.click()
NES_sort_button.click()

#get table data
table = driver.find_element_by_xpath("//*[@id='wg-result-table']")
table_html = table.get_attribute("innerHTML")
df = read_html(table_html)[0]

#print gene set table
#print(df)

#write gene set data to excel
write = pd.ExcelWriter(save_url, engine = "xlsxwriter")
df.to_excel(write, sheet_name = "genesets", index = False)

#extend the tables results
WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.XPATH, "/html/body/main/div/div[2]/section[3]/div[2]/div[3]/span/select/option[@value='1000']"))).click()

#get gene set count
gene_set_count = len(df.index)
#print(gene_set_count)

#set gene for loop variables
for i in range(gene_set_count):

    #define data variables
    gene = str(i+1)
    gene_set = df.iloc[i,0]
    sheet = gene_set[3:]

    #extend each table results
    textbox = WebDriverWait(driver, 10).until(EC.visibility_of_element_located((By.XPATH, "/html/body/main/div/div[2]/section[3]/div[2]/div[1]/div[1]/div[1]/div/div[1]/input")))
    textbox.send_keys(Keys.CONTROL + "a")
    textbox.send_keys(Keys.DELETE)
    textbox.send_keys(gene_set)
    textbox.send_keys(Keys.ENTER)

    #get each table data
    table = driver.find_element_by_xpath("//*[@id='wg-gene-table']")
    table_html = table.get_attribute("innerHTML")
    df2 = read_html(table_html)[0]

    #test each table data
    #print(gene_set)
    #print(df2)

    #handle common scraping error
    if (df2.columns[0] != "User ID"):

        #rename (fix) the columns
        df2.columns = ["User ID", "Score", "Gene Symbol", "Gene Name", "Entrez Gene ID"] 

    #write gene data to excel
    df2.to_excel(write, sheet_name = sheet, index = False)

#save excel file
write.save()

#print success
print("Process successfully completed.")

#close driver
driver.quit()
