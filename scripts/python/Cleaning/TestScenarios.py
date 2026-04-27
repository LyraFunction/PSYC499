# Import packages
import pandas
import numpy
import pyreadr

def main() -> None:
    File = file_import()
    test_data_integrity(File)

def file_import() -> pandas.DataFrame:
    working_file = pandas.read_csv("../../../data_clean/Dataset_clean.csv", sep=",")
    return working_file

def test_data_integrity(data: pandas.DataFrame) -> None:
    check_fips_consistency(data)
    check_population_consistency(data)
    check_hc_flag_consistency(data)
    check_quarterly_consistency(data)

def check_fips_consistency(data: pandas.DataFrame) -> None:
    # Verify FIPS codes are unique and within valid range
    assert data['FIPS'].nunique() == len(data), "Duplicate FIPS codes found"
    assert data['FIPS'].min() >= 1000 and data['FIPS'].max() <= 57000, "Invalid FIPS code range"

def check_population_consistency(data: pandas.DataFrame) -> None:
    # Check population values are non-negative
    population_columns = [col for col in data.columns if 'Population' in col]
    for col in population_columns:
        assert (data[col] >= 0).all(), f"Negative population found in {col}"

def check_hc_flag_consistency(data: pandas.DataFrame) -> None:
    # Verify hate crime flags are binary (0 or 1)
    hc_flag_columns = [col for col in data.columns if 'HC_Flag' in col]
    for col in hc_flag_columns:
        assert data[col].isin([0, 1]).all(), f"Invalid HC_Flag values in {col}"

def check_quarterly_consistency(data: pandas.DataFrame) -> None:
    # Verify quarterly totals match annual totals
    years = ['2017', '2018', '2019', '2020']
    for year in years:
        quarterly_sum = data[f'{year}_QTR1'].fillna(0) + \
                        data[f'{year}_QTR2'].fillna(0) + \
                        data[f'{year}_QTR3'].fillna(0) + \
                        data[f'{year}_QTR4'].fillna(0)
        assert (quarterly_sum == data[f'{year}_Total']).all(), f"Quarterly totals mismatch for {year}"

main()