#  Honors in Psychology Thesis: Voting Choice as a Predictor in County Level Sexual Orientation and Gender Motivated Hate Crimes across the United States: A Latent Growth Modeling Approach

## Repository Structure
-   `posters` contains PDFs of the project that were printed and presented at various conferences along with the citations used.
-   `scripts` contains the `r`, `LaTeX`, and `Python` files used for the project, along with any extra relevant documentation.
-   `final` and `proposal` contain the final PDFs submitted for the thesis defense and proposal, respectively, along with a folder called `citations` with the .bib files for the citations of each manuscript.
-   `supplementals` contains two folders, `figures` which has all the figures used in the project. The other folder `model_output` has text files that contain the read-outs from lavaan for different model specifications.

## Replication Instructions
To replicate my data, please download this repo and download the 2016 vote, along with the 2017, 2018, 2019, and 2020 UCR files from the links found in either of the citations folders. Once downloaded, place all the files within a folder named data_raw, then simply run the provided Python file to create the cleaned data. If you wish to use my r code, run the scripts provided in the `scripts\r` folder, but you will need to adjust the data location to a local location.
