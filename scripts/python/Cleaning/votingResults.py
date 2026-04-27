# Import packages
import pandas
import numpy
import pyreadr

## TODO fix antiquated fillna behavior when adding to the skeleton file
## TODO write orphan functions
## TODO verify quarter and incident counts

# Primary function that runs the entire program
def main():
    # Call primary function
    file_handling()

# The primary function that runs through the logic of the program
# Accepts and returns nothing 
def file_handling():
    # Run functions for reading in files to dataframes
    Working_Data = dataframe_setup()
    Voting_Data = read_voting_data()
    # Voting_Data.to_csv("file1.csv", index=False) # Debug
    header_2017, incident_2017 = read_2017_data()
    header_2018, incident_2018 = read_2018_data()
    header_2019, incident_2019 = read_2019_data()
    header_2020, incident_2020 = read_2020_data()
    # Copy voting data to working data
    Working_Data = copy_voting_data(Working_Data, Voting_Data)
    # Add new dataframes to the list
    header_list = [header_2017, header_2018, header_2019, header_2020]
    incident_list = [incident_2017, incident_2018, incident_2019, incident_2020]
    # Send skeleton and files to the integrator
    complete_file = header_integration(Working_Data, header_list)
    complete_file = incident_integration(complete_file, incident_list, bias_definitions())
    complete_file = quarter_incidents(complete_file, incident_list, bias_definitions(), quarter_definitions())
    ## Run output functions
    # Send the complete file to change party coding. 1 is dummy coding, 2 is effects coding; 3 leaves the variable as
    # a string
    complete_file = party_coding_options(complete_file, 1)
    complete_file = rename_columns_with_y_prefix(complete_file)
    # Create a second file for the mixed effects ANOVA
    file_out(complete_file)

# Thrown together function to add y to column names for running the LGM
# accepts a dataframe and returns that dataframe modified.
def rename_columns_with_y_prefix(workframe: pandas.DataFrame) -> pandas.DataFrame:
    # Create a copy of the dataframe to avoid modifying the original
    # Get all column names
    cols = workframe.columns.tolist()
    # Create a dictionary for column renaming
    # Keep the first 6 columns as is, add Y to the rest
    rename_dict = {}
    for i, col in enumerate(cols):
        # If the column index is 6 or greater (7th column or after)
        if i >= 6:
            rename_dict[col] = 'Y' + str(col)
    # Apply the renaming
    workframe = workframe.rename(columns=rename_dict)
    return workframe

# Function that exports the completed dataframe to a .rda file
# Accepts a dataframe, returns nothing
def file_out(file: pandas.DataFrame) -> None:
    file.to_parquet(f"../../../data_clean/Dataset_clean_WIDE.parquet")
    file.to_csv(f"../../../data_clean/Dataset_clean_WIDE.csv", index=False)


# Defines a blank dataframe to be filled with relevant data as the program runs
# Accepts no arguments, returns a dataframe with the correct column names
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
    # Create a new dataframe using the columns assigned with an expected row count of 3155
    empty_dataframe = pandas.DataFrame(columns=column_names, index=range(3155))
    return empty_dataframe

# Reads in the CSV for the voting data.,
# Accepts no arguments, returns a dataframe containing election data
def read_voting_data() -> pandas.DataFrame:
    working_file = pandas.read_csv("../../../data_raw/2016Vote/countypres_2000-2024.csv")
    working_file = filter_voting_data(working_file)
    return working_file

## TODO Cleanup this series of almost identical functions?
def read_2017_data() -> tuple:
    header_file = pyreadr.read_r("../../../data_raw/2017Files/DS0001/37854-0001-Data.rda")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    incident_file = pyreadr.read_r("../../../data_raw/2017Files/DS0002/37854-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    return header_file, incident_file

def read_2018_data() -> tuple:
    header_file = pyreadr.read_r("../../../data_raw/2018Files/DS0001/37872-0001-Data.rda")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    incident_file = pyreadr.read_r("../../../data_raw/2018Files/DS0002/37872-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    return header_file, incident_file

def read_2019_data() -> tuple:
    header_file = pyreadr.read_r("../../../data_raw/2019Files/DS0001/38782-0001-Data.rda")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    incident_file = pyreadr.read_r("../../../data_raw/2019Files/DS0002/38782-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    return header_file, incident_file

def read_2020_data() -> tuple:
    header_file = pyreadr.read_r("../../../data_raw/2020Files/DS0001/38790-0001-Data.rda")
    header_file = rda_to_panda(header_file)
    header_file = filter_header_file(header_file)
    incident_file = pyreadr.read_r("../../../data_raw/2020Files/DS0002/38790-0002-Data.rda")
    incident_file = rda_to_panda(incident_file)
    incident_file = filter_incident_file(incident_file)
    return header_file, incident_file

def read_data() -> tuple:
    header_2017 = pyreadr.read_r("../../../data_raw/2017Files/DS0001/37854-0001-Data.rda")
    incident_2017 = pyreadr.read_r("../../../data_raw/2017Files/DS0002/37854-0002-Data.rda")
    header_2018 = pyreadr.read_r("../../../data_raw/2018Files/DS0001/37872-0001-Data.rda")
    incident_2018 = pyreadr.read_r("../../../data_raw/2018Files/DS0002/37872-0002-Data.rda")
    header_2019 = pyreadr.read_r("../../../data_raw/2019Files/DS0001/38782-0001-Data.rda")
    incident_2019 = pyreadr.read_r("../../../data_raw/2019Files/DS0002/38782-0002-Data.rda")
    header_2020 = pyreadr.read_r("../../../data_raw/2020Files/DS0001/38790-0001-Data.rda")
    incident_2020 = pyreadr.read_r("../../../data_raw/2020Files/DS0002/38790-0002-Data.rda")
    header_list = [header_2017, header_2018, header_2019, header_2020]
    incident_list = [incident_2017, incident_2018, incident_2019, incident_2020]
    return header_list, incident_list

# Converts a .rda file to a pandas dataframe
# Accepts a .rda file
# Returns a pandas dataframe
def rda_to_panda(rda_file) -> pandas.DataFrame:
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
# Accepts a dataframe containing voting data and returns a dataframe with only the relevant columns
def filter_voting_data(file: pandas.DataFrame) -> pandas.DataFrame:
    # Fill in the 3 missing FIPS codes with NA values
    file['county_fips'] = file['county_fips'].fillna(numpy.nan)
    # Filter file to only include the 2016 election
    file = file[file['year'] == 2016]
    # remove NA values and convert to integer
    file = file[file['county_fips'].notna()]
    file['county_fips'] = file['county_fips'].astype(int)
    # Portions of the voting data are essentially stored in long format, so this pivots a portion of the table to wide format
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
# Accepts a header file returns a dataframe with only the relevant columns
def filter_header_file(file: pandas.DataFrame) -> pandas.DataFrame:
    file = fips_adjustments(file)
    file = flag_adjustment(file)
    return file[['CITY', 'MASTERYR', 'STATECOD', 'POP1', 'CFIPS1', 'CFIPS2', 'CFIPS3', 'CFIPS4', 'HC_FLAG']]

# Removes a majority of the incident files contents and only keeps those that are needed
# Accepts a pandas dataframe and returns a filtered dataframe
def filter_incident_file(file: pandas.DataFrame) -> pandas.DataFrame:
    file = fips_adjustments(file)
    return file[
        ['CITY', 'MASTERYR', 'STATECOD', 'QUARTER', 'CFIPS1', 'CFIPS2', 'CFIPS3', 'CFIPS4',
         'BIASMO1', 'BIASMO1_2', 'BIASMO1_3', 'BIASMO1_4', 'BIASMO1_5', 'BIASMO2', 'BIASMO2_2', 'BIASMO2_3',
         'BIASMO2_4', 'BIASMO2_5', 'BIASMO3', 'BIASMO3_2', 'BIASMO3_3', 'BIASMO3_4', 'BIASMO3_5', 'BIASMO4',
         'BIASMO4_2', 'BIASMO4_3', 'BIASMO4_4', 'BIASMO4_5', 'BIASMO5', 'BIASMO5_2', 'BIASMO5_3', 'BIASMO5_4',
         'BIASMO5_5', 'BIASMO6', 'BIASMO6_2', 'BIASMO6_3', 'BIASMO6_4', 'BIASMO6_5', 'BIASMO7', 'BIASMO7_2',
         'BIASMO7_3', 'BIASMO7_4', 'BIASMO7_5', 'BIASMO8', 'BIASMO8_2', 'BIASMO8_3', 'BIASMO8_4', 'BIASMO8_5',
         'BIASMO9', 'BIASMO9_2', 'BIASMO9_3', 'BIASMO9_4', 'BIASMO9_5', 'BIASMO10', 'BIASMO10_2', 'BIASMO10_3',
         'BIASMO10_4', 'BIASMO10_5']]

def flag_adjustment(file: pandas.DataFrame) -> pandas.DataFrame:
    # Replace empty cells with numpy nan then convert categories
    file['HC_FLAG'] = file['HC_FLAG'].fillna(numpy.nan).infer_objects()
    file['HC_FLAG'] = file['HC_FLAG'].astype('category')
    file['HC_FLAG'] = file['HC_FLAG'].cat.rename_categories({'(1) One or more hate crime incidents present': 1,
                                                             '(0) No hate crime incidents present': 0})
    return file

def quarter_adjustment(file: pandas.DataFrame, quarter_mapping: dict) -> pandas.DataFrame:
    file['QUARTER'] = file['QUARTER'].fillna(numpy.nan).infer_objects()
    file['QUARTER'] = file['QUARTER'].map(quarter_mapping)
    return file

# Logic to implement different types of coding for the party grouping variable
# Accepts the working dataframe and returns the dataframe with changed or unchanged coding
def party_coding_options(file: pandas.DataFrame, coding_option: int) -> pandas.DataFrame:
    file['Winning_Party'] = file['Winning_Party'].astype('category')
    # Dummy coding
    if coding_option == 1:
        file['Winning_Party'] = file['Winning_Party'].cat.rename_categories({'REPUBLICAN': 1,
                                                                             'DEMOCRAT': 0})
    # Effects coding
    if coding_option == 2:
        file['Winning_Party'] = file['Winning_Party'].cat.rename_categories({'REPUBLICAN': 1,
                                                                             'DEMOCRAT': -1})
    # Leave as strings
    else:
        pass
    return file

## TODO implement
def filter_loop(heading_list, incident_list) -> tuple[list, list]:
    new_headings = []
    new_incidents = []
    # Common functions for both types of files
    def common_processing(dataframe):
        dataframe = rda_to_panda(dataframe)
        dataframe = fips_adjustments(dataframe)
        return dataframe
    # Process headers
    for header_frame in heading_list:
        frame = common_processing(header_frame)
        frame = filter_header_file(frame)
        frame = flag_adjustment(frame)
        new_headings.append(frame)
    # Process incidents    
    for incident_frame in incident_list:
        frame = common_processing(incident_frame)
        frame = filter_incident_file(frame)
        frame = quarter_adjustment(frame, quarter_definitions())
        new_incidents.append(frame)
    return new_headings, new_incidents

# Adjusts the FIPS codes for each county based on the state they are in. Should handle situations in which the FIPS code
# in a given df is missing, or incorrectly formatted.
# Accepts a dataframe with FIPS codes in the CFIPS1 column and returns a dataframe with adjusted FIPS codes
## TODO fix to adjust fips columns 2-4 as well.
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
        "NB": 31000,
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
        "WA": 53000,  # Washington
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

def bias_definitions() -> dict:
    # Maps codes expected in the incident file to the corresponding skeleton column name
    bias_motivations = {
        "(42) Anti-Lesbian": "Anti-Lesbian",
        "(41) Anti-Gay (Male)": "Anti-Gay",
        "(45) Anti-Bisexual": "Anti-Bisexual",
        "(43) Anti-Lesbian, Gay, Bisexual, or Transgender, Mixed Group (LGBT)": "Anti-General",
        "(71) Anti-Transgender": "Anti-Transgender",
        "(72) Anti-Gender Non-Conforming": "Anti-Gender_Nonconforming"
    }
    return bias_motivations

# Changes value in the incident file
# called as needed and returns a dictionary containing the map of values
def quarter_definitions() -> dict:
    quarter_map = {
        "(1) Jan to Mar": "QTR1",
        "(2) Apr to Jun": "QTR2",
        "(3) Jul to Sep": "QTR3",
        "(4) Oct to Dec": "QTR4"
    }
    return quarter_map

# Creates a T/F value to check if a dataframe matches the FIPS code of the skeleton file
# Returns Either TRUE or FALSE
def matching_county_rows(skeleton_dataframe, checking_row):
    return skeleton_dataframe['FIPS'] == checking_row['CFIPS1']

def integrator_manager(working_dataframe: pandas.DataFrame, header_list: list, incident_list: list) -> pandas.DataFrame:
    header_integration(working_dataframe, header_list)
    incident_integration(working_dataframe, incident_list, bias_definitions())
    quarter_incidents(working_dataframe, incident_list, bias_definitions())
    return working_dataframe

# This function should accept a series of working files and integrate them into the skeleton frame
# Accepts the dataframe skeleton and a list of the ucr files
# Returns the complete dataframe
def header_integration(working_dataframe: pandas.DataFrame, file_list: list) -> pandas.DataFrame:
    # Process header files first
    for year, header_file in zip([2017, 2018, 2019, 2020], file_list):
        for _, header_row in header_file.iterrows():
            # Find matching FIPS code in the skeleton
            matching_rows = matching_county_rows(working_dataframe, header_row)
            if matching_rows.any():
                # Update population and HC_FLAG for matching rows
                working_dataframe.loc[matching_rows, f'{year}_Population'] = (working_dataframe.loc[
                                                                                  matching_rows, f'{year}_Population']
                                                                              .fillna(0).infer_objects() + header_row[
                                                                                  'POP1'])
                working_dataframe.loc[matching_rows, f'{year}_HC_Flag'] = (working_dataframe.loc[
                                                                               matching_rows, f'{year}_HC_Flag']
                                                                           .fillna(0).infer_objects() + header_row[
                                                                               'HC_FLAG'])
    return working_dataframe

## TODO fix, something is fucked up here
def incident_integration(working_dataframe: pandas.DataFrame, file_list: list, bias_types: dict) -> pandas.DataFrame:
    # First initialize all bias columns and totals based on HC_Flag
    for year in [2017, 2018, 2019, 2020]:
        # Get mask for each type of HC_Flag value
        zero_flags = working_dataframe[f'{year}_HC_Flag'] == 0
        na_flags = working_dataframe[f'{year}_HC_Flag'].isna()
        positive_flags = (working_dataframe[f'{year}_HC_Flag'] > 0) & (~na_flags)
        # Set values for counties with HC_flag = 0
        if zero_flags.any():
            working_dataframe.loc[zero_flags, f'{year}_Total'] = 0
            for bias_type in bias_types.values():
                working_dataframe.loc[zero_flags, f'{year}_{bias_type}'] = 0
        # Set values for counties with a missing HC_flag
        if na_flags.any():
            working_dataframe.loc[na_flags, f'{year}_Total'] = numpy.nan
            for bias_type in bias_types.values():
                working_dataframe.loc[na_flags, f'{year}_{bias_type}'] = numpy.nan
        # Initialize bias columns to 0 for counties with HC_Flag > 0
        if positive_flags.any():
            for bias_type in bias_types.values():
                working_dataframe.loc[positive_flags, f'{year}_{bias_type}'] = working_dataframe.loc[
                    positive_flags, f'{year}_{bias_type}'].fillna(0)
    # Process the incidents to increment the bias counters
    for year, incident_file in zip([2017, 2018, 2019, 2020], file_list):
        for _, incident_row in incident_file.iterrows():
            matching_rows = matching_county_rows(working_dataframe, incident_row)
            if matching_rows.any():
                flag_value = working_dataframe.loc[matching_rows, f'{year}_HC_Flag'].iloc[0]
                # Only process if HC_FLAG > 0
                if flag_value > 0:
                    # Check all BIASMO columns for matches
                    for x in range(1, 11):
                        # Sets the active column
                        bias_col = f'BIASMO{x}'
                        if bias_col in incident_row:
                            bias_value = incident_row[bias_col]
                            if pandas.notna(bias_value) and str(bias_value) in bias_types:
                                bias_type = bias_types[str(bias_value)]
                                working_dataframe.loc[matching_rows, f'{year}_{bias_type}'] += 1
                        # Check sub-columns (BIASMO1_2 through BIASMO1_5)
                        for y in range(2, 6):
                            sub_col = f'{bias_col}_{y}'
                            if sub_col in incident_row:
                                sub_value = incident_row[sub_col]
                                if pandas.notna(sub_value) and str(sub_value) in bias_types:
                                    bias_type = bias_types[str(sub_value)]
                                    working_dataframe.loc[matching_rows, f'{year}_{bias_type}'] += 1
    # Calculate totals for counties with positive HC_Flag after processing all incidents
    for year in [2017, 2018, 2019, 2020]:
        positive_flags = (working_dataframe[f'{year}_HC_Flag'] > 0) & (~working_dataframe[f'{year}_HC_Flag'].isna())
        if positive_flags.any():
            bias_cols = [f'{year}_{bias_type}' for bias_type in bias_types.values()]
            working_dataframe.loc[positive_flags, f'{year}_Total'] = working_dataframe.loc[
                positive_flags, bias_cols].sum(axis=1)
    return working_dataframe


def quarter_incidents(working_dataframe: pandas.DataFrame, file_list: list, bias_types: dict,
                      quarter_mapping: dict) -> pandas.DataFrame:
    # Initialize all quarter columns to 0 or NaN based on HC_Flag value
    for year in [2017, 2018, 2019, 2020]:
        # Create masks for different HC_Flag conditions
        zero_flags = working_dataframe[f'{year}_HC_Flag'] == 0
        na_flags = working_dataframe[f'{year}_HC_Flag'].isna()
        positive_flags = (working_dataframe[f'{year}_HC_Flag'] > 0) & (~na_flags)
        # Initialize quarter columns for counties with HC_flag = 0
        if zero_flags.any():
            working_dataframe.loc[zero_flags, f'{year}_QTR1'] = 0
            working_dataframe.loc[zero_flags, f'{year}_QTR2'] = 0
            working_dataframe.loc[zero_flags, f'{year}_QTR3'] = 0
            working_dataframe.loc[zero_flags, f'{year}_QTR4'] = 0
        # Initialize quarter columns for counties with missing HC_flag
        if na_flags.any():
            working_dataframe.loc[na_flags, f'{year}_QTR1'] = numpy.nan
            working_dataframe.loc[na_flags, f'{year}_QTR2'] = numpy.nan
            working_dataframe.loc[na_flags, f'{year}_QTR3'] = numpy.nan
            working_dataframe.loc[na_flags, f'{year}_QTR4'] = numpy.nan
        # Initialize quarter columns for counties with HC_Flag > 0
        if positive_flags.any():
            # First ensure the columns exist
            for qtr in ['QTR1', 'QTR2', 'QTR3', 'QTR4']:
                if f'{year}_{qtr}' not in working_dataframe.columns:
                    working_dataframe[f'{year}_{qtr}'] = numpy.nan
            # Then initialize them to 0
            working_dataframe.loc[positive_flags, f'{year}_QTR1'] = 0
            working_dataframe.loc[positive_flags, f'{year}_QTR2'] = 0
            working_dataframe.loc[positive_flags, f'{year}_QTR3'] = 0
            working_dataframe.loc[positive_flags, f'{year}_QTR4'] = 0
    # Process the incidents
    for year, incident_file in zip([2017, 2018, 2019, 2020], file_list):
        for _, incident_row in incident_file.iterrows():
            matching_rows = matching_county_rows(working_dataframe, incident_row)
            if matching_rows.any():
                flag_value = working_dataframe.loc[matching_rows, f'{year}_HC_Flag'].iloc[0]
                # Only process if HC_FLAG > 0
                if flag_value > 0:
                    # Check if this is a relevant bias incident
                    is_relevant_incident = False
                    # Check all BIASMO columns for matches
                    for x in range(1, 11):
                        bias_col = f'BIASMO{x}'
                        if bias_col in incident_row:
                            bias_value = incident_row[bias_col]
                            # Check the main bias column
                            if pandas.notna(bias_value) and str(bias_value) in bias_types:
                                is_relevant_incident = True
                                break
                            # Check sub-columns
                            for y in range(2, 6):
                                sub_col = f'{bias_col}_{y}'
                                if sub_col in incident_row:
                                    sub_value = incident_row[sub_col]
                                    if pandas.notna(sub_value) and str(sub_value) in bias_types:
                                        is_relevant_incident = True
                                        break
                            if is_relevant_incident:
                                break
                    # If this is a relevant incident, increment the quarter counter
                    if is_relevant_incident and 'QUARTER' in incident_row and pandas.notna(incident_row['QUARTER']):
                        quarter_col = incident_row['QUARTER']
                        # Make sure we're using the correctly mapped quarter name
                        if quarter_col in quarter_mapping:
                            quarter_name = quarter_mapping[quarter_col]
                            working_dataframe.loc[matching_rows, f'{year}_{quarter_name}'] += 1
    return working_dataframe

def orphan_handler():
    pass
# Run main
main()
