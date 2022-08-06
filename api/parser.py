import bs4
import json

import re

# read file
import unicodedata


def read_file(file_name):
    with open(file_name, 'r') as f:
        return f.read()


# parse html
def parse_html(html):
    soup = bs4.BeautifulSoup(html, 'html.parser')
    return soup


def normalise_all(ls):
    new_list = []
    for i in ls:
        new_list.append(unicodedata.normalize('NFKD', i).replace('\n', '').replace('\t', '').replace('\r', ''))
    return new_list


def get_json(txt):
    try:
        soup = parse_html(txt)
        table_data = [[cell.text for cell in row("td")]
                      for row in soup("tr")]
 
        listOfDates = []
        month = ""
        first_row = True
        for row in table_data:
            clean_row = normalise_all(row)
            if (len(clean_row) == 2):
                # print(clean_row[1])
                # print(re.sub(r'(\d+)', '\n\\1', clean_row[1]))

                if clean_row[0] is not None and clean_row[0] != "" and len(clean_row[0]) != 0:
                    if clean_row[1] is not None and clean_row[1] != "" and len(clean_row[1]) != 0:
                        if first_row:
                            #dic['month'] = clean_row[0].strip()
                            month = clean_row[0].strip()
                            first_row = False
                        else:
                            # dic[int(clean_row[0])] = clean_row[1].replace(' +', ' ').strip()
                            #dic[int(clean_row[0])] = re.sub(' +', ' ', str(clean_row[1])).strip()
                            listOfDates.append(
                                {
                                    "day": int(clean_row[0]),
                                    "status": re.sub(' +', ' ', str(clean_row[1])).strip()
                                }
                            )
    except Exception:
        return {'error': 'error parsing'}

    
    return {month: listOfDates}




# run
if __name__ == '__main__':
    txt = read_file('424376.html')
    print(get_json(txt))