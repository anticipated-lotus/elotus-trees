start <- Sys.time()

#' Packages
packages_cran <-
  c(
    "devtools",
    "dplyr",
    "future",
    "future.apply",
    "ggplot2",
    "gt",
    "htmltools",
    "plotly",
    "progressr",
    "purrr",
    "RCurl",
    "readr",
    "rotl",
    "splitstackshape",
    "tidyr",
    "WikidataQueryServiceR",
    "yaml"
  )
packages_bioconductor <- NULL
packages_github <- c("KarstensLab/microshades")

source(file = "R/check_and_load_packages.R")
source(file = "R/load_lotus.R")
source(file = "R/parse_yaml_params.R")

check_and_load_packages_1()
check_and_load_packages_2()

future::plan(strategy = future::multisession)
handlers(global = TRUE)
handlers("progress")

source(
  "https://raw.githubusercontent.com/taxonomicallyinformedannotation/tima-r/main/R/log_debug.R"
)
source(
  "https://raw.githubusercontent.com/taxonomicallyinformedannotation/tima-r/main/R/parse_yaml_paths.R"
)

source(file = "R/make_3D.R")

source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/colors.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/format_gt.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/make_2D.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/make_chromatographiable.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/hierarchies_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/hierarchies_grouped_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/histograms_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/molinfo.R")
source(file = "R/plot_histograms.R") ## to fix
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/prehistograms_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/prepare_hierarchy.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/prepare_plot.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/prettyTables_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/queries_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/save_histograms_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/save_prettyTables_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/save_prettySubtables_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/save_treemaps_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/subtables_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/tables_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/treemaps_progress.R")
source(file = "https://raw.githubusercontent.com/Adafede/cascade/main/R/wiki_progress.R")

paths <- parse_yaml_paths()
params <- parse_yaml_params()

lotus <- load_lotus()

exports <-
  list(
    paths$data$path,
    paths$data$histograms$path,
    paths$data$sunbursts$path,
    paths$data$tables$path,
    paths$data$treemaps$path
  )

#' TODO clean this
#' As there is no better way than to manually assess if the QID
#' really corresponds to what you want
qids <- list(
  # "Actinobacteria" = "Q26262282"
  # "Asteraceae" = "Q25400",
  # "Simaroubaceae" = "Q156679",
  # "Gentianaceae" = "Q157216",
  # "Picrasma" = "Q135638",
  # "Picrasma quassioides" = "Q855778",
  "Swertia" = "Q163970",
  "Swertia chirayita" = "Q21318003",
  "Gentiana" = "Q144682",
  "Gentiana lutea" = "Q158572",
  "Quassia" = "Q1947702",
  "Quassia amara" = "Q135389",
  "Aloe ferox" = "Q1194889",
  "Sambucus nigra" = "Q22701",
  "Coriandrum sativum" = "Q41611",
  "Juniperus communis" = "Q26325",
  "Piper cubeba" = "Q161927",
  "Aframomum melegueta" = "Q1503476",
  "Angelica archangelica" = "Q207745",
  "Glycyrrhiza glabra" = "Q257106",
  "Cinnamomum cassia" = "Q204148",
  "Iris pallida" = "Q161347",
  "Centaurea benedicta" = "Q792835",
  "Hypericum perforatum" = "Q158289",
  "Prunus dulcis" = "Q39918",
  "Taraxacum officinale" = "Q131219",
  "Rheum palmatum" = "Q1109580",
  "Arnica montana" = "Q207848",
  "Cinchona pubescens" = "Q164574",
  "Ginkgo biloba" = "Q43284",
  "Panax ginseng" = "Q182881",
  "Salvia officinalis" = "Q1111359"
  # "Saxifraga" = "Q156146",
  # "Dendrobium" = "Q133778",
  # "Dendrobium chrysanthum" = "Q5223343",
  # "Dendrobium fimbriatum" = "Q7990065",
  # "Trichoderma" = "Q135322",
  # "Trichoderma yunnanense" = "Q108442404",
  # "Papiliotrema" = "Q7132982",
  # "Papiliotrema rajasthanensis" = "Q27866418"
)

#' TODO clean this
comparison <-
  c(
    "Arnica montana",
    "Cinchona pubescens",
    "Ginkgo biloba",
    "Panax ginseng",
    "Salvia officinalis"
  )
# comparison <- c("Gentiana", "Swertia")
# comparison <- c("Dendrobium", "Trichoderma")

genera <-
  names(qids)[!grepl(
    pattern = " ",
    x = names(qids),
    fixed = TRUE
  )]

query_part_1 <- readr::read_file(paths$inst$scripts$sparql$review_1)
query_part_2 <- readr::read_file(paths$inst$scripts$sparql$review_2)
query_part_3 <- readr::read_file(paths$inst$scripts$sparql$review_3)
query_part_4 <- readr::read_file(paths$inst$scripts$sparql$review_4)

message("Loading LOTUS classified structures")
structures_classified <- lotus |>
  dplyr::select(
    structure_id = structure_inchikey,
    structure_inchi,
    structure_smiles_2D,
    structure_exact_mass,
    structure_xlogp,
    chemical_pathway = structure_taxonomy_npclassifier_01pathway,
    chemical_superclass = structure_taxonomy_npclassifier_02superclass,
    chemical_class = structure_taxonomy_npclassifier_03class
  ) |>
  dplyr::distinct()

# organisms_classified <- readr::read_delim(
#   file = classified_path,
#   col_select = c(
#     "organism" = "organism_wikidata",
#     "taxonLabel" = "organism_name",
#     "taxonId" = "organism_taxonomy_ottid",
#     "taxon_01domain" = "organism_taxonomy_01domain",
#     "taxon_02kingdom" = "organism_taxonomy_02kingdom",
#     "taxon_03phylum" = "organism_taxonomy_03phylum",
#     "taxon_04class" = "organism_taxonomy_04class",
#     "taxon_05order" = "organism_taxonomy_05order",
#     "taxon_06family" = "organism_taxonomy_06family",
#     "taxon_07tribe" = "organism_taxonomy_07tribe",
#     "taxon_08genus" = "organism_taxonomy_08genus",
#     "taxon_09species" = "organism_taxonomy_09species",
#     "taxon_10varietas" = "organism_taxonomy_10varietas"
#   )
# ) |>
#   dplyr::distinct()

message("Building queries")
queries <- queries_progress(qids)

message("Querying Wikidata")
results <- wiki_progress(queries)

message("Cleaning tables and adding columns")
tables <- tables_progress(results)

if (params$structures$dimensionality == 2) {
  tables <- lapply(tables, make_2D)
} else {
  tables <- lapply(tables, make_3D)
}

if (params$structures$c18 == TRUE) {
  tables <- lapply(tables, make_chromatographiable)
}

message("Generating subtables based on chemical classification")
subtables <- subtables_progress(tables)

message("Generating pretty tables")
prettyTables <- prettyTables_progress(tables)

message("Generating pretty subtables")
prettySubtables <- prettyTables_progress(subtables)

message("Generating chemical hierarchies...")
message("... for single taxa")
hierarchies_simple <- hierarchies_progress(tables)
message("... for grouped taxa")
hierarchies_grouped <- hierarchies_grouped_progress(tables)
hierarchies_grouped <- hierarchies_grouped[lengths(hierarchies_grouped) != 0]
message("... combining")
names(hierarchies_grouped) <- ifelse(
  test = !grepl(
    pattern = "\\W+",
    x = names(hierarchies_grouped)
  ),
  yes = paste(names(hierarchies_grouped),
    "grouped",
    sep = "_"
  ),
  no = names(hierarchies_grouped)
)
hierarchies <- append(hierarchies_simple, hierarchies_grouped)

if (!is.null(comparison)) {
  message("Generating special comparison")
  special <- lapply(
    X = 1:length(comparison),
    FUN = function(x) {
      tables[[comparison[[x]]]]
    }
  )
  hierarchies[["special"]] <- prepare_hierarchy(
    dataframe = dplyr::bind_rows(special) |>
      dplyr::rowwise() |>
      dplyr::mutate(
        best_candidate_1 = chemical_pathway,
        best_candidate_2 = chemical_superclass,
        best_candidate_3 = chemical_class,
        organism = ifelse(
          test = all(grepl(pattern = "\\W+", x = comparison)),
          yes = taxaLabels,
          no = gsub(
            pattern = " .*",
            replacement = "",
            x = taxaLabels
          )
        )
      ) |>
      dplyr::mutate(sample = organism, species = organism) |>
      dplyr::select(-taxa, -taxaLabels, -references, -referencesLabels) |>
      dplyr::distinct(),
    type = "literature"
  )
}

message("Generating prehistograms")
prehistograms <- prehistograms_progress(hierarchies)
prehistograms <- prehistograms[!is.na(prehistograms)]

message("Generating histograms")
histograms <- histograms_progress(prehistograms)

message("Generating treemaps")
treemaps <-
  treemaps_progress(xs = names(hierarchies)[!grepl(
    pattern = "_grouped",
    x = names(hierarchies)
  )])

message("Generating sunbursts")
sunbursts <-
  treemaps_progress(
    xs = names(hierarchies)[!grepl(
      pattern = "_grouped",
      x = names(hierarchies)
    )],
    type = "sunburst"
  )

message("Filtering treemaps")
treemaps <-
  within(
    treemaps,
    rm(list = names(treemaps)[grepl(
      pattern = "ae$",
      x = names(treemaps)
    )])
  )

message("Filtering sunbursts")
sunbursts <-
  within(
    sunbursts,
    rm(list = names(sunbursts)[grepl(
      pattern = "ae$",
      x = names(sunbursts)
    )])
  )

lapply(X = exports, FUN = create_dir)

message("Exporting html tables")
save_prettyTables_progress(names(prettyTables))

message("Exporting html subtables")
save_prettySubtables_progress(names(prettySubtables))

message("Adapting histograms dimensions")
dimensions <- future.apply::future_lapply(
  X = names(prehistograms),
  FUN = function(x) {
    nrow(prehistograms[[x]] |> dplyr::ungroup() |> dplyr::distinct(ids)) + 1
  }
)

size <- future.apply::future_lapply(
  X = names(prehistograms),
  FUN = function(x) {
    nrow(prehistograms[[i]] |> dplyr::ungroup() |> dplyr::distinct(species)) + 1
  }
)

message("Exporting histograms")
save_histograms_progress(names(histograms))

# reticulate::install_miniconda()
# reticulate::conda_install('r-reticulate', 'python-kaleido')
# reticulate::conda_install('r-reticulate', 'plotly', channel = 'plotly')
# reticulate::use_miniconda('r-reticulate')

# message("Exporting sunbursts")
# save_treemaps_progress(
#   xs = names(sunbursts),
#   type = "sunburst"
# )

# message("Exporting treemaps")
# save_treemaps_progress(xs = names(treemaps))

end <- Sys.time()

log_debug("Script finished in", format(end - start))
