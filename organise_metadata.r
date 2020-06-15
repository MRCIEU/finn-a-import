library(jsonlite)
library(dplyr)
library(data.table)


config <- read_json("config.json")
dir.create(file.path(config$datadir, "ready"))
dat <- fread(file.path(config$datadir, "dl", "r2_manifest.tsv"), header=TRUE, stringsAsFactors=FALSE) %>% as_tibble()
dat$filename <- basename(dat$path_bucket)
all(file.exists(file.path(config$datadir, "dl", dat$filename)))

table(duplicated(dat$phenocode))
table(duplicated(dat$name))

a <- tibble(
	id = paste0("finn-a-", dat$phenocode),
	sample.size = dat$n_cases + dat$n_controls,
	ncase = dat$n_cases,
	ncontrol = dat$n_controls,
	sex =  "Males and females",
	category = "Binary",
	subcategory = NA,
	unit = "logOR",
	group_name = "public",
	build = "HG19/GRCh37",
	consortium = "FinnGen",
	year = 2020,
	population = "European",
	trait = dat$name,
	pmid = NA,
	filename = dat$filename,
	nsnp = 16152119,
	delimiter = "tab",
	header = TRUE,
	mr = 1,
	chr_col = 0,
	pos_col = 1,
	oa_col = 2,
	ea_col = 3,
	snp_col = 4,
	pval_col = 6,
	beta_col = 7,
	se_col = 8,
	eaf_col = 9
)

write.csv(a, file="input.csv")
write.csv(a, file=file.path(config$datadir, "ready", "input.csv"))

#chrom  pos     ref     alt     rsids   nearest_genes   pval    beta    sebeta  maf     maf_cases       maf_controls