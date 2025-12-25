import pandas
import numpy
import pyreadr

def main():
    # Call primary function
    file_handling()

# Primary function that runs through the logic of the program
# Accepts and returns nothing
def file_handling():
    # Create an empty list for later
    file_list = ()
    # Run functions for reading in files to dataframes
    Voting_Data = read_voting_data()
    # Voting_Data.to_csv("file1.csv", index=False) # Debug
    Header_2017, Incident_2017 = read_2017_data()
    Header_2018, Incident_2018 = read_2018_data()
    Header_2019, Incident_2019 = read_2019_data()
    Header_2020, Incident_2020 = read_2020_data()
    Working_Data = dataframe_setup()
    # Copy voting data to working data
    Working_Data = copy_voting_data(Working_Data, Voting_Data)
    Working_Data.to_csv("complete_file.csv", index=False)  # Debug
    # Add new dataframes to the list
    file_list = [Header_2017, Header_2018, Header_2019, Header_2020, Incident_2017, Incident_2018, Incident_2019,
                 Incident_2020]
    # Send skeleton and files to the integrator
    complete_file = file_integration(Working_Data, file_list)
    complete_file.to_csv("complete_file.csv", index=False)  # Debug

# Defines a blank dataframe to be filled with relevant data as the program runs
# Accepts no arguments
# Returns a dataframe with the correct column names
def dataframe_setup() -> pandas.DataFrame:
    # Set a list of column names to fill the skeleton dataframe with
    column_names = ['FIPS', 'County_Name', 'State_name', 'Winning_Party', 'Democratic_Votes', 'Republican_Votes',
                    '2017_Population', '2017_HC_Flag', '2017_Anti-Lesbian', '2017_Anti-Gay', '2017_Anti-Bisexual',
                    '2017_Anti-General', '2017_Anti-Transgender', '2017_Anti-Gender_Nonconforming', '2017_QTR1',
                    '2017_QTR2', '2017_QTR3', '2017_QTR4', '2017_Total', '2018_Population', '2018_HC_Flag',
                    '2018_Anti-Lesbian', '2018_Anti-Gay', '2018_Anti-Bisexual', '2018_Anti-General',
                    '2018_Anti-Transgender', '2018_Anti-Gender_Nonconforming', '2018_QTR1', '2018_QTR2', '2018_QTR3',
                    '2018_QTR4', '2018_Total', '2019_Population', '2019_HC_Flag', '2019_Anti-Lesbian', '2019_Anti-Gay',
                    '2019_Anti-Bisexual', '2019_Anti-General', '2019_Anti-Transgender','2019_Anti-Gender_Nonconforming',
                    '2019_QTR1', '2019_QTR2', '2019_QTR3', '2019_QTR4', '2019_Total', '2020_Population', '2020_HC_Flag',
                    '2020_Anti-Lesbian', '2020_Anti-Gay', '2020_Anti-Bisexual', '2020_Anti-General',
                    '2020_Anti-Transgender', '2020_Anti-Gender_Nonconforming', '2020_QTR1', '2020_QTR2', '2020_QTR3',
                    '2020_QTR4', '2020_Total'
                    ]
    # Create a new dataframe using the columns assigned with an expected row count of 3155 - the header
    empty_dataframe = pandas.DataFrame(columns=column_names, index=range(3156))
    return empty_dataframe

# Reads in the CSV for the voting data.
# Accepts no arguments
# Returns a dataframe containing election data
def read_voting_data() -> pandas.DataFrame:
    working_file = pandas.read_csv("../../data_raw/2016Vote/countypres_2000-2024.csv")
    working_file = filter_voting_data(working_file)
    return working_file

## TODO Cleanup this series of almost identical functions?
def read_2017_data() -> tuple:
    header_file = pyreadr.read_r("../../data_raw/2017Files/DS0001/37854-0001-Data.rda")
    #header_file = pandas.read_csv("../../data_raw/2017Files/2017Header.csv", sep=",")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    print("Completed Reading 2017 Header File")
    #header_file = fips_adjustments(header_file)
    #header_file.to_csv("header_file1.csv", index=False)
    incident_file = pyreadr.read_r("../../data_raw/2017Files/DS0002/37854-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    print("Completed Reading 2017 Incident File")
    #incident_file = pandas.read_csv("../../data_raw/2017Files/2017incident.csv", sep=",")
    #incident_file = fips_adjustments(incident_file)
    #incident_file.to_csv("incident_file1.csv", index=False)
    header_file.to_csv("header.csv", index=False)  # Debug
    incident_file.to_csv("incident.csv", index=False)  # Debug
    return header_file, incident_file

def read_2018_data() -> tuple:
    header_file = pyreadr.read_r("../../data_raw/2018Files/DS0001/37872-0001-Data.rda")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    print("Completed Reading 2018 Header File")
    incident_file = pyreadr.read_r("../../data_raw/2018Files/DS0002/37872-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    print("Completed Reading 2018 Incident File")
    #header_file = pandas.read_csv("../../data_raw/2017Files/2017Header.csv", sep=",")
    #header_file = fips_adjustments(header_file)
    #incident_file = pandas.read_csv("../../data_raw/2017Files/2017incident.csv", sep=",")
    #incident_file = fips_adjustments(incident_file)
    return header_file, incident_file

def read_2019_data() -> tuple:
    header_file = pyreadr.read_r("../../data_raw/2019Files/DS0001/38782-0001-Data.rda")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    print("Completed Reading 2019 Header File")
    incident_file = pyreadr.read_r("../../data_raw/2019Files/DS0002/38782-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    print("Completed Reading 2019 Incident File")
    #header_file = pandas.read_csv("../../data_raw/2017Files/2017Header.csv", sep=",")
    #header_file = fips_adjustments(header_file)
    #incident_file = pandas.read_csv("../../data_raw/2017Files/2017incident.csv", sep=",")
    #incident_file = fips_adjustments(incident_file)
    return header_file, incident_file

def read_2020_data() -> tuple:
    header_file = pyreadr.read_r("../../data_raw/2020Files/DS0001/38790-0001-Data.rda")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    print("Completed Reading 2020 Header File")
    incident_file = pyreadr.read_r("../../data_raw/2020Files/DS0002/38790-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    print("Completed Reading 2020 Incident File")
    #header_file = pandas.read_csv("../../data_raw/2017Files/2017Header.csv", sep=",")
    #header_file = fips_adjustments(header_file)
    #incident_file = pandas.read_csv("../../data_raw/2017Files/2017incident.csv", sep=",")
    #incident_file = fips_adjustments(incident_file)
    return header_file, incident_file

# Converts a .rda file to a pandas dataframe
# Accepts a .rda file
# Returns a pandas dataframe
def rda_to_panda(rda_file) -> pandas.DataFrame:
    # key_name = (rda_file.keys())
    # converted_file = pandas.DataFrame(key_name)
    # return converted_file
    return next(iter(rda_file.values()))

# Copy data from voting dataframe to working dataframe
# Accepts working dataframe and voting dataframe
# Returns working dataframe with voting data added
def copy_voting_data(working_dataframe: pandas.DataFrame, voting_dataframe: pandas.DataFrame) -> pandas.DataFrame:
    # Copy values from voting data to their equivalents in the skeleton
    working_dataframe['FIPS'] = voting_dataframe['county_fips']
    working_dataframe['County_Name'] = voting_dataframe['county_name']
    working_dataframe['State_name'] = voting_dataframe['state']
    working_dataframe['Winning_Party'] = voting_dataframe['winning_party']
    working_dataframe['Democratic_Votes'] = voting_dataframe['DEMOCRAT']
    working_dataframe['Republican_Votes'] = voting_dataframe['REPUBLICAN']
    return working_dataframe

# Filters the voting data to only include the 2016 voting data, FIPS code, county name, state name, the winning party,
# and the number of votes cast for each party.
# Accepts a dataframe containing voting data
# Returns a dataframe with only the relevant columns
def filter_voting_data(file: pandas.DataFrame) -> pandas.DataFrame:
    # Fill in the 3 missing FIPS codes with NA values
    file['county_fips'] = file['county_fips'].fillna(numpy.nan)
    # Filter file to only include the 2016 election
    file = file[file['year'] == 2016]
    # remove NA values and convert to integer
    file = file[file['county_fips'].notna()]
    file['county_fips'] = file['county_fips'].astype(int)
    # Portions of the voting data are essentially stored in long format, so this pivots a portion of table to wide format
    pivoted = file.pivot_table(
        index=['year', 'state', 'county_name', 'county_fips'],
        columns='party',
        values='candidatevotes',
        ## No values should be missing, but format them as such just in case
        fill_value=numpy.nan
    ).reset_index()
    # Get the winning party
    party_columns = pivoted.columns[4:]  # Skip the index columns
    # Set the winning party to the party with the highest number of votes in a new column
    pivoted['winning_party'] = pivoted[party_columns].idxmax(axis=1)
    return pivoted

# Drops irrelevant columns from a header file leaving only information on the FIPS code, Population, and whether
# the county experienced a bias-motivated incident
# Accepts a header file
# Returns a dataframe with only the relevant columns
def filter_header_file(file: pandas.DataFrame) -> pandas.DataFrame:
    file = fips_adjustments(file)
    file = flag_adjustment(file)
    return file[['CITY', 'MASTERYR', 'STATECOD', 'POP1', 'CFIPS1', 'HC_FLAG']]

# Removes a majority of the incident files contents and only keeps those that are needed
# Accepts a pandas dataframe
# Returns a filtered dataframe
def filter_incident_file(file: pandas.DataFrame) -> pandas.DataFrame:
    file = fips_adjustments(file)
    return file[
        ['CITY', 'MASTERYR', 'STATECOD', 'QTR1ACT', 'QTR2ACT', 'QTR3ACT', 'QTR4ACT', 'QUARTER', 'CFIPS1',
         'BIASMO1', 'BIASMO1_2', 'BIASMO1_3', 'BIASMO1_4', 'BIASMO1_5', 'BIASMO2', 'BIASMO2_2', 'BIASMO2_3',
         'BIASMO2_4', 'BIASMO2_5', 'BIASMO3', 'BIASMO3_2', 'BIASMO3_3', 'BIASMO3_4', 'BIASMO3_5', 'BIASMO4',
         'BIASMO4_2', 'BIASMO4_3', 'BIASMO4_4', 'BIASMO4_5', 'BIASMO5', 'BIASMO5_2', 'BIASMO5_3', 'BIASMO5_4',
         'BIASMO5_5', 'BIASMO6', 'BIASMO6_2', 'BIASMO6_3', 'BIASMO6_4', 'BIASMO6_5', 'BIASMO7', 'BIASMO7_2',
         'BIASMO7_3', 'BIASMO7_4', 'BIASMO7_5', 'BIASMO8', 'BIASMO8_2', 'BIASMO8_3', 'BIASMO8_4', 'BIASMO8_5',
         'BIASMO9', 'BIASMO9_2', 'BIASMO9_3', 'BIASMO9_4', 'BIASMO9_5', 'BIASMO10', 'BIASMO10_2', 'BIASMO10_3',
         'BIASMO10_4', 'BIASMO10_5']]

def flag_adjustment(file: pandas.DataFrame) -> pandas.DataFrame:
    # Replace empty cells with numpy nan then convert categories
    file['HC_FLAG'] = file['HC_FLAG'].fillna(numpy.nan)
    file['HC_FLAG'] = file['HC_FLAG'].cat.rename_categories({'(1) One or more hate crime incidents present': 1,
                                                             '(0) No hate crime incidents present': 0})
    return file

# Adjusts the FIPS codes for each county based on the state they are in. Should handle situations in which the FIPS code
# in a given df is missing, or incorrectly formatted.
# Accepts a dataframe with FIPS codes in the CFIPS1 column
# Returns a dataframe with adjusted FIPS codes
def fips_adjustments(file: pandas.DataFrame) -> pandas.DataFrame:
    state_adjustments = {
        "AL": 1000,  # Alabama
        "AK": 2000,
        "AZ": 4000,
        "AR": 5000,
        "CA": 6000,
        "CO": 8000,
        "CT": 9000,
        "DE": 10000,
        "DC": 11000,
        "FL": 12000,
        "GA": 13000,
        "HI": 15000,
        "ID": 16000,
        "IL": 17000,
        "IN": 18000,
        "IA": 19000,
        "KS": 20000,
        "KY": 21000,
        "LA": 22000,
        "ME": 23000,
        "MD": 24000,
        "MA": 25000,
        "MI": 26000,
        "MN": 27000,
        "MS": 28000,
        "MO": 29000,
        "MT": 30000,
        "NE": 31000,
        "NV": 32000,
        "NH": 33000,
        "NJ": 34000,
        "NM": 35000,
        "NY": 36000,
        "NC": 37000,
        "ND": 38000,
        "OH": 39000,
        "OK": 40000,
        "OR": 41000,
        "PA": 42000,
        "RI": 44000,
        "SC": 45000,
        "SD": 46000,
        "TN": 47000,
        "TX": 48000,
        "UT": 49000,
        "VT": 50000,
        "VA": 51000,  # Virginia
        "WA": 52000,  # Washington
        "WV": 54000,
        "WI": 55000,
        "WY": 56000
    }
    fips_columns = ['CFIPS1']
    for col in fips_columns:
        file[col] = file.apply(
            lambda row: int(row[col].strip()) + state_adjustments.get(row['STATECOD'], 0)
            if pandas.notna(row[col]) and row[col].strip() and row[col].strip() != '000'
            else 0,
            axis=1
        )
    return file

## TODO write
# Sums up the hate crime flags for a given set of regions in the header files, preventing possible situations where the
# flag for a given year in a FIPS region is incorrectly set due to the last value being 0
# Accepts one dataframe
# Returns a dataframe
def flag_sum(file: pandas.DataFrame) -> pandas.DataFrame:
    return file

## TODO
# Similar to the flag_sum function, this function sums up the pop1 values for a given set of regions in the header file
# this may be removed later if I find out what the differing pop1 values mean.
# Accepts one dataframe
# Returns a dataframe
def population_sum(file: pandas.DataFrame) -> pandas.DataFrame:
    return file

# This function should accept a series of working files and integrate them into the skeleton frame
# Accepts the dataframe skeleton and a list of the ucr files
# Returns the complete dataframe
def file_integration(working_dataframe: pandas.DataFrame, file_list: list) -> pandas.DataFrame:
    # Split the list into header and incident files
    header_files = file_list[:4]  # The first 4 are header files
    incident_files = file_list[4:]  # The last 4 are incident files
    # Process header files first
    for year, header_file in zip([2017, 2018, 2019, 2020], header_files):
        for _, header_row in header_file.iterrows():
            # Find matching FIPS code in the skeleton
            #print(header_row['CFIPS1'],"Header") # Debug
            matching_rows = working_dataframe['FIPS'] == header_row['CFIPS1']
            if matching_rows.any():
                print("MATCH")
                # Update population and HC_FLAG for matching rows
                working_dataframe.loc[matching_rows, f'{year}_Population'] = header_row['POP1']
                working_dataframe.loc[matching_rows, f'{year}_HC_Flag'] = header_row['HC_FLAG']
            else:
                pass

    # Process incident files next
    #for year, incident_file in zip([2017, 2018, 2019, 2020], incident_files):
     #   for _, incident_row in incident_file.iterrows():
      #      # Find matching FIPS code skeleton
       #     matching_rows = working_dataframe['FIPS'] == incident_row['CFIPS1']
        #    if matching_rows.any():
         #       # Update quarterly data
          #      working_dataframe.loc[matching_rows, f'{year}_QTR1'] = incident_row['QTR1ACT']
           #     working_dataframe.loc[matching_rows, f'{year}_QTR2'] = incident_row['QTR2ACT']
            #    working_dataframe.loc[matching_rows, f'{year}_QTR3'] = incident_row['QTR3ACT']
             #   working_dataframe.loc[matching_rows, f'{year}_QTR4'] = incident_row['QTR4ACT']
    return working_dataframe

# Integrates a given years header file into the skeleton dataframe
# Accepts the skeleton dataframe, and a header file
# Returns the skeleton frame with the new data
def header_integration(filling_file: pandas.DataFrame, header_file: pandas.DataFrame) -> pandas.DataFrame:
    return filling_file


# Integrates a given years incident file into the skeleton dataframe
# Accepts the skeleton dataframe, and an incident file
# Returns the skeleton frame with the new data
def incident_integration(filling_file: pandas.DataFrame, incident_file: pandas.DataFrame,
                         year: int) -> pandas.DataFrame:
    return filling_file


## Iterates through the header file, checking what values to check for the growing dataset file filling_file based on the
# current iteration of the loop.
## Accepts a dataframe containing header information, a dataframe containing the dataframe that is being filled, and the
# Current iteration of the loop
# Returns the dataframe that is being filled
def header_counting(year_file: pandas.DataFrame, filling_file: pandas.DataFrame, iteration: int) -> pandas.DataFrame:
    ## TODO add code
    return filling_file

main()