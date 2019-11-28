from goodreads import client
import re
gc = client.GoodreadsClient('5jzgxilZ4Jf982U4EfmQ', 'oZB7XacxN67XqzLMpZ85eOqwKFxgB7YuL12ObhC8oEo')
gc.authenticate('5jzgxilZ4Jf982U4EfmQ', 'oZB7XacxN67XqzLMpZ85eOqwKFxgB7YuL12ObhC8oEo')

#author_id = '9291'
f = open('book_list_updated.csv','w')
f.write('Author_id'+'|'+'Author' +'|'  + 'ISBN' + '|' + 'ISBN13' + '|' + 'Title' + '|'  + 'Page_no' + '|' + 'Year' + 'Language' + '\n')
#f2 = open('repeat_list.csv','w')
#f2.write('Author_id'+'|'+'Author' +'|'  + 'ISBN' + '|' + 'ISBN13' + '|' + 'Title' + '|'  + 'Page_no' + '|' + 'Year' + '\n')
#author_list = ['16549']
author_list = ['2238','9291','43613','5353','4841825','21625','2989','7576','37449','49699','1025097','1239','147762','19005','233','36492','8154','1730','2887','2384','6098','16272','4432','2617','3447','3617','6251','9972','12915','12545','81011','9432','8178','19706','2929','16961','12546','19696','3075','15412','32498','48913','6104','3389','2387','8685','7625163','858','4636148','12940','10521','19051','9346','11349','811','31095','11728','20704','1055','14610','2609','3517','76671','3504','3989','48867','397','3780','24655','6331','16549','12605','18344','26372','7577','3299','7844','1023510','9598','20258','3530','59445','72932','4043','2345','14255','36857','3499','5246','11075','59972','20950','34850','6941','12606','3887498','6244','24575']
for author_id in author_list:
    author = gc.list_books(author_id,1,200)
    books = author.books
    if len(books) == 0:
        print "No Books for Author ",str(author_id)
    for i in range(len(author.books)):
        try:
            author_name = str(author.name)    
        except (AttributeError,UnicodeEncodeError):
            author_name = ''
            print "Author Name not found for author ",str(author_id)
        try:
            isbn = str(books[i].isbn)
            print dir(books[i])    
        except (AttributeError,UnicodeEncodeError):
            isbn = ''
        try:
            isbn13 = str(books[i].isbn13)    
        except (AttributeError,UnicodeEncodeError):
            isbn13 = ''
        try:
            title = str(books[i].title)    
        except (UnicodeEncodeError,AttributeError):
            title = ''
        try:
            num_pages = str(books[i].num_pages)    
        except (AttributeError,UnicodeEncodeError):
            num_pages = ''
        try:
            year = str(books[i].publication_date[2].encode('utf-8'))    
        except (AttributeError,UnicodeEncodeError):
            year = ''
        try:
            language = str(books[i].language_code)    
        except (AttributeError,UnicodeEncodeError):
            language = ''  
        #with open('sample_list.csv',mode='w') as w:
        #set,collection,review,Pack,giftt,bundle,Audiobook,series,condensed,ebook,Reader's digest
        r_strings = ['set','collection','review','Pack','gift','bundle','Audiobook','condensed','ebook','Reader\'s digest','Box Set','/','\\',';']
        #if len(re.findall(r"(?=("+'|'.join(r_strings)+r"))",title,re.IGNORECASE)) == 0: 
        f.write( author_id + '|' + author_name+ '|'+isbn + '|' + isbn13 + '|'+ title +'|'+ num_pages + '|'+year + '|' + language)
        f.write('\n')
        #else:
        #    f2.write( author_id + '|' + author_name+ '|'+isbn + '|' + isbn13 + '|'+ title +'|'+ num_pages + '|'+year + '\n')

f.close()        
#f2.close()       

            
