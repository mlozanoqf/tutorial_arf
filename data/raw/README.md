# NGFS/IIASA Raw Climate Credit Data

This folder stores the raw NGFS/IIASA CLIMACRED files used in Chapter 6.

The files were downloaded from the NGFS Phase 5 Short Term Scenario Explorer
using the public IIASA API. The download code is in:

`R/download-ngfs-climate-credit-data.R`

To refresh the data from R:

```r
source("R/download-ngfs-climate-credit-data.R")
```

The refresh script requires internet access and the R packages `httr` and
`jsonlite`.

The script requests a guest token, sends a JSON query to the time-series
endpoint, and writes the API response before the chapter performs any cleaning
or financial calculations.

Files:

- `ngfs_climacred_global_raw.csv`: global CLIMACRED observations for the main
  sector portfolio analysis.
- `ngfs_climacred_daps_raw.csv`: regional DAPS physical-stress observations
  used for the physical-risk diagnostic.
- `ngfs_climacred_download_manifest.csv`: file names, row counts, endpoint, and
  download timestamp.

The CSV files are raw for the purpose of the chapter. They preserve the API
columns such as `runId`, `model`, `scenario`, `region`, `variable`, `unit`,
`year`, and `value`. The chapter then separates metrics from sectors, joins the
teaching portfolio, converts percentage-point values into decimal PDs, and
calculates expected loss, spread, price, and portfolio risk quantities.
