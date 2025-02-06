################### PACKAGE INSTALLATION

getOrUpdatePkg <- function(p, minVer = "0") {
  if (!isFALSE(try(packageVersion(p) < minVer, silent = TRUE) )) {
    repo <- c("predictiveecology.r-universe.dev", getOption("repos"))
    install.packages(p, repos = repo)
  }
}
getOrUpdatePkg("Require")
getOrUpdatePkg("SpaDES.project", minVer = "0.1.1.9011")
getOrUpdatePkg("terra")
getOrUpdatePkg("reproducible")
getOrUpdatePkg("googledrive")


################### RUNAME

if (all(any(SpaDES.project::user("tmichele"),
        SpaDES.project::user("Tati")),
        getwd() != "C:/Users/Tati/GitHub/smurfs")) setwd("~/smurfs")

terra::terraOptions(tempdir = "~/scratch/terra")

################ SPADES CALL

out <- SpaDES.project::setupProject(
  runName = "smurfs",
  paths = list(projectPath = "smurfs",
               scratchPath = "~/scratch",
               outputPath = file.path("outputs", runName)),
  modules =c(
    "tati-micheletti/smurfsMovement@main"
  ),
  options = list(spades.allowInitDuringSimInit = TRUE,
                 reproducible.cacheSaveFormat = "rds",
                 gargle_oauth_email = if (any(user("tmichele"), user("Tati"))) "tati.micheletti@gmail.com" else NULL,
                 gargle_oauth_email = if (any(user("tmichele"), user("Tati"))) "tati.micheletti@gmail.com" else NULL,
                 gargle_oauth_cache = ".secrets",
                 gargle_oauth_client_type = "web", # Without this, google authentication didn't work when running non-interactively!
                 use_oob = FALSE,
                 repos = "https://cloud.r-project.org",
                 SpaDES.project.fast = FALSE,
                 reproducible.gdalwarp = TRUE,
                 reproducible.inputPaths = if (user("tmichele")) "~/data" else NULL,
                 reproducible.destinationPath = if (user("tmichele")) "~/data" else NULL,
                 reproducible.useMemoise = TRUE
  ),
  times = list(start = 0,
               end = 500),
  authorizeGDrive = googledrive::drive_auth(cache = ".secrets"),
  params = list(
  ),
  useGit = "sub",
  outputs =  data.frame(objectName = "finalDataset",
                        file = "dataset.rds",
                        saveTime = times$end)
)

snippsim <- do.call(SpaDES.core::simInitAndSpades, out)
