# Download NGFS/IIASA short-term climate credit-risk data.
#
# This script creates the raw input files used in Chapter 6.
# It intentionally saves the API response before the book chapter cleans or
# reshapes the data. That keeps the download step auditable and reproducible.

required_packages <- c("httr", "jsonlite")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Install these packages before downloading NGFS data: ",
    paste(missing_packages, collapse = ", ")
  )
}

ngfs_database <- "IXSE_NGFS_PHASE_5_SHORT_TERM"
ngfs_auth_url <- "https://api.manager.ece.iiasa.ac.at/legacy"
ngfs_base_url <- "https://db1.ene.iiasa.ac.at/ngfs-phase-5-short-term-api/rest/v2.1"

output_dir <- file.path("data", "raw")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

ngfs_get_guest_token <- function(max_tries = 5, wait_seconds = 1) {
  token_url <- paste0(ngfs_auth_url, "/anonym/", ngfs_database)

  for (try_id in seq_len(max_tries)) {
    response <- try(
      httr::GET(
        token_url,
        query = list(algorithm = "HS256"),
        httr::timeout(30)
      ),
      silent = TRUE
    )

    if (!inherits(response, "try-error") &&
        httr::status_code(response) == 200) {
      token <- httr::content(response, as = "text", encoding = "UTF-8")
      token <- gsub('^"|"$', "", token)

      if (nzchar(token)) {
        return(token)
      }
    }

    Sys.sleep(wait_seconds)
  }

  stop("The NGFS guest token could not be obtained.")
}

ngfs_post_timeseries <- function(runs, regions, variables, years = integer()) {
  token <- ngfs_get_guest_token()

  request_body <- list(
    filters = list(
      runs = as.list(as.integer(runs)),
      regions = as.list(regions),
      variables = as.list(variables),
      units = list(),
      years = as.list(as.integer(years)),
      timeslices = list("Year")
    )
  )

  response <- httr::POST(
    paste0(ngfs_base_url, "/runs/bulk/ts"),
    httr::add_headers(Authorization = paste("Bearer", token)),
    httr::content_type_json(),
    body = jsonlite::toJSON(request_body, auto_unbox = TRUE),
    encode = "raw",
    httr::timeout(120)
  )

  response_text <- httr::content(response, as = "text", encoding = "UTF-8")

  if (httr::status_code(response) != 200) {
    stop(response_text)
  }

  data <- jsonlite::fromJSON(response_text, flatten = TRUE)

  if (length(data) == 0) {
    stop("The NGFS query returned no observations.")
  }

  as.data.frame(data, stringsAsFactors = FALSE)
}

global_runs <- c(
  "Diverging Realities" = 74,
  "Highway to Paris" = 75,
  "Sudden Wake-up Call" = 76
)

ngfs_sectors <- c(
  "Coal",
  "Oil",
  "Gas",
  "Power Supply",
  "Land transport",
  "Air transport",
  "Construction",
  "Agriculture",
  "Chemical Products",
  "Computer, electronic and optical products"
)

metric_names <- c(
  "baseline_pd",
  "pd_adjustment",
  "corporate_bond_spread_adjustment",
  "corporate_bond_price_rel_adjustment",
  "wacc_adjustment"
)

global_variables <- as.vector(
  outer(metric_names, ngfs_sectors, paste, sep = "|")
)

global_raw <- ngfs_post_timeseries(
  runs = unname(global_runs),
  regions = "World",
  variables = global_variables,
  years = 2022:2030
)

global_file <- file.path(output_dir, "ngfs_climacred_global_raw.csv")
utils::write.csv(global_raw, global_file, row.names = FALSE, na = "")

daps_runs <- c(
  DAPS_AFR_R = 68,
  DAPS_ASIA = 69,
  DAPS_EUR = 70,
  DAPS_NAM = 71,
  DAPS_OCE = 72,
  DAPS_SAM = 73
)

daps_regions <- c(
  "Africa",
  "Asia",
  "Euro Area",
  "North America",
  "Oceania",
  "South America"
)

daps_variables <- as.vector(
  outer(
    "pd_adjustment",
    c("Agriculture", "Coal", "Power Supply"),
    paste,
    sep = "|"
  )
)

daps_raw <- ngfs_post_timeseries(
  runs = unname(daps_runs),
  regions = daps_regions,
  variables = daps_variables,
  years = 2024:2030
)

daps_file <- file.path(output_dir, "ngfs_climacred_daps_raw.csv")
utils::write.csv(daps_raw, daps_file, row.names = FALSE, na = "")

manifest <- data.frame(
  file = c(global_file, daps_file),
  rows = c(nrow(global_raw), nrow(daps_raw)),
  database = ngfs_database,
  endpoint = paste0(ngfs_base_url, "/runs/bulk/ts"),
  downloaded_at_utc = format(Sys.time(), tz = "UTC", usetz = TRUE),
  stringsAsFactors = FALSE
)

manifest_file <- file.path(output_dir, "ngfs_climacred_download_manifest.csv")
utils::write.csv(manifest, manifest_file, row.names = FALSE, na = "")

message("Wrote ", normalizePath(global_file, winslash = "/"))
message("Wrote ", normalizePath(daps_file, winslash = "/"))
message("Wrote ", normalizePath(manifest_file, winslash = "/"))
