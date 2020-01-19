import io
import os

dirname=os.path.dirname
read_filepath = dirname(dirname(__file__)) + "/data/raw/AviationData.txt"
write_filepath = dirname(dirname(__file__)) + "/data/raw/AviationDataCleaned.csv"

with io.open(write_filepath, "w", encoding="UTF-8") as output:
    with io.open(read_filepath, "r", encoding="UTF-8") as master:
        for i in master:
            x = i.split('|')
            for idx, y in enumerate(x[:-1]): # Ignore latest pipe at the end of each line
                z = y.strip() # Remove trailing white spaces
                if idx == len(x)-2: # If last iteration
                    output.write("%s\n" % z)
                else:
                    output.write("%s\t" % z)
