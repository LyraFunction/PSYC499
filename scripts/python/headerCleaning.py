import pandas

def main():
    read_data()

def read_data() -> pandas.DataFrame:
    working_file = pandas.read_csv("../../data_raw/2017HEADER/DS0001/37854-0001-Data.rda")
    return working_file


