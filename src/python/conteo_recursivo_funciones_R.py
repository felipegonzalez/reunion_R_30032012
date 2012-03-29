import sys
import os
import re
import pprint
import csv

function_pat = '(\w+?\.?\w+)\('

## Este código es adaptado del curso de NLP de Stanford (2012)
## http://nlp.class.org

def process_file(name, f):
    res = []
    no_lineas=0
    for line in f:
        if(len(line)>1):
            no_lineas = no_lineas +  1
            matches = re.findall(function_pat,line)
            for m in matches:
                email = m
                res.append(email)
    return (res,no_lineas)


def process_dir(data_path):
    # get candidates
    guess_list = []
    no_lineas = 0
    for fname in os.listdir(data_path):  
        #print('Elemento')
        #print(fname)      
        if os.path.isdir(os.path.join(data_path, fname)):
            #print('Directorio')
            salida = process_dir(os.path.join(data_path, fname))
            guess_list.extend(salida[0])
            no_lineas =  no_lineas + salida[1]
        if (not(os.path.isdir(os.path.join(data_path, fname)))):
            if fname[0] == '.':
                continue
            fileName, fileExtension = os.path.splitext(fname)
            # print(fileExtension)
            if (fileExtension != '.R' or fname=='.Rhistory'):
                continue
            #print(fileName)
            #print(fname)
            path = os.path.join(data_path, fname)
            f = open(path,'r')
            salida = process_file(fname, f)
            f_guesses = salida[0]
            no_lineas = no_lineas + salida[1] 
            #print(f_guesses)
            guess_list.extend(f_guesses)
    return (guess_list, no_lineas)


def main(data_path):
    total_list = []
    print('Procesando archivos')
    salida = process_dir(data_path)
    guess_list = salida[0]
    print(salida[1])
    print('Contando')
    #print(guess_list)
    counts = [(a, guess_list.count(a)) for a in set(guess_list)]
    print('Ordenando')
    counts_sort = sorted(counts, key=lambda x: -x[1])
    # print(counts_sort)
    print('Guardando archivo')
    with open('output.csv', 'wb') as outf:
        outcsv = csv.writer(outf)
        outcsv.writerows(counts_sort)
    #gold_list =  get_gold(gold_path)
    #score(guess_list, gold_list)

if __name__ == '__main__':
    if (len(sys.argv) != 2):
        print 'usage:\tcount_functions.py <data_dir>'
        sys.exit(0)
    main(sys.argv[1])
