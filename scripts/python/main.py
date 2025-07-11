import pandas

def main():
    process_data()

# Run functions
def process_data():
    election_data = read_data()
    election_data = filter_by_year(election_data)
    election_data = calculate_party_totals(election_data)
    save_results(election_data)

# Read in a csv file, save it to a variable, then return that variable
def read_data() -> pandas.DataFrame:
    working_file = pandas.read_csv("../../data_raw/county_results_2000-2020.csv")
    return working_file

# Drop years older than 2016
def filter_by_year(file:pandas.DataFrame) -> pandas.DataFrame:
    return file[file['year'].isin([2016, 2017, 2018, 2019, 2020])]

# Function gathers relevant columns and drops the rest, tabulates votes across medium
def calculate_party_totals(file: pandas.DataFrame) -> pandas.DataFrame:
    # Group by year and county, calculate party vote totals
    grouped = file.groupby(['year', 'state', 'county_name', 'county_fips', 'party'])['candidatevotes'].sum().reset_index()
    # Get the party with max votes for each county
    winning_party = grouped.sort_values('candidatevotes', ascending=False).drop_duplicates(['year', 'county_name'])
    return winning_party

# function outputs the working file to csv
def save_results(file:pandas.DataFrame) -> None:
    file.to_csv("output.csv", index=False)

# Run main
main()