# Snakemake workflow: single-cell-rna-seq

[![Snakemake](https://img.shields.io/badge/snakemake-≥5.1.4-brightgreen.svg)](https://snakemake.readthedocs.io)
[![GitHub actions status](https://github.com/snakemake-workflows/single-cell-rna-seq/workflows/Tests/badge.svg?branch=master)](https://github.com/snakemake-workflows/single-cell-rna-seq/actions?query=branch%3Amaster+workflow%3ATests)
[![Snakemake-Report](https://img.shields.io/badge/snakemake-report-green.svg)](https://koesterlab.github.io/resources/snakemake-workflows/single-cell-rna-seq/report.html)

A single cell RNA-seq workflow following [Lun, McCarthy and Marioni 2016](https://f1000research.com/articles/5-2122/v2) and [Soneson and Robinson 2018](https://doi.org/10.1038/nmeth.4612), with added more recent functionality.

## Authors

* Johannes Köster, https://koesterlab.github.io

## Usage

In any case, if you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and, if already available, its DOI (see above).


#### Step 1: Obtain a copy of this workflow

1. Create a new github repository using this workflow [as a template](https://help.github.com/en/articles/creating-a-repository-from-a-template).
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) the newly created repository to your local system, into the place where you want to perform the data analysis.

#### Step 2: Configure workflow

Configure the workflow according to your needs via editing the file `config.yaml`.

#### Step 3: Execute workflow

Test your configuration by performing a dry-run via

    snakemake --use-conda -n

Execute the workflow locally via

    snakemake --use-conda --cores $N

using `$N` cores or run it in a cluster environment via

    snakemake --use-conda --cluster qsub --jobs 100

or

    snakemake --use-conda --drmaa --jobs 100

If you not only want to fix the software stack but also the underlying OS, use

    snakemake --use-conda --use-singularity

in combination with any of the modes above.
See the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/executable.html) for further details.

#### Step 4: Investigate results

After successful execution, you can create a self-contained interactive HTML report with all results via:

    snakemake --report report.html

This report can, e.g., be forwarded to your collaborators.
An example (using some trivial test data) can be seen [here](https://koesterlab.github.io/resources/snakemake-workflows/single-cell-rna-seq/report.html).

#### Step 5: Commit changes

Whenever you change something, don't forget to commit the changes back to your github copy of the repository:

    git commit -a
    git push


#### Step 6: Obtain updates from upstream

Whenever you want to synchronize your workflow copy with new developments from upstream, do the following.

1. Once, register the upstream repository in your local copy: `git remote add -f upstream git@github.com:snakemake-workflows/single-cell-rna-seq.git` or `git remote add -f upstream https://github.com/snakemake-workflows/single-cell-rna-seq.git` if you do not have setup ssh keys.
2. Update the upstream version: `git fetch upstream`.
3. Create a diff with the current version: `git diff HEAD upstream/master workflow > upstream-changes.diff`.
4. Investigate the changes: `vim upstream-changes.diff`.
5. Apply the modified diff via: `git apply upstream-changes.diff`.
6. Carefully check whether you need to update the config files: `git diff HEAD upstream/master config`. If so, do it manually, and only where necessary, since you would otherwise likely overwrite your settings and samples.

#### Step 7: Contribute back

In case you have also changed or added steps, please consider contributing them back to the original repository:

1. [Fork](https://help.github.com/en/articles/fork-a-repo) the original repo to a personal or lab account.
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) the fork to your local system, to a different place than where you ran your analysis.
3. Copy the modified files from your analysis to the clone of your fork, e.g., `cp -r workflow path/to/fork`. Make sure to **not** accidentally copy config file contents or sample sheets. Instead, manually update the example config files if necessary.
4. Commit and push your changes to your fork.
5. Create a [pull request](https://help.github.com/en/articles/creating-a-pull-request) against the original repository.

## Testing

Test cases are in the subfolder `.test`. They are automtically executed via continuous integration with Travis CI.
