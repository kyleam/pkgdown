meta_development <- function(meta, version) {
  development <- purrr::pluck(meta, "development", .default = list())

  destination <- purrr::pluck(development, "destination", .default = "dev")

  mode <- purrr::pluck(development, "mode", .default = "default")
  mode <- switch(mode,
    auto = dev_mode(version),
    default = ,
    release = ,
    devel = ,
    unreleased = mode,
    stop(
      "development$mode` in `_pkgdown.yml must be one of auto, release, devel, or unreleased",
      call. = FALSE
    )
  )

  version_label <- purrr::pluck(development, "version_label")
  if (is.null(version_label)) {
    version_label <- if (mode %in% c("release", "default")) "default" else "danger"
  }

  version_tooltip <- purrr::pluck(development, "version_tooltip")
  if (is.null(version_tooltip)) {
    version_tooltip <- switch(mode,
      default = "",
      release = "Released version",
      devel = "In-development version",
      unreleased = "Unreleased version"
    )
  }

  in_dev <- mode == "devel"

  list(
    destination = destination,
    mode = mode,
    version_label = version_label,
    version_tooltip = version_tooltip,
    in_dev = in_dev
  )
}

dev_mode <- function(version) {
  version <- unclass(package_version(version))[[1]]

  if (length(version) < 3) {
    "release"
  } else if (length(version) == 3) {
    if (version[3] >= 9000) {
      "devel"
    } else {
      "release"
    }
  } else if (identical(version[1:3], c(0L, 0L, 0L))) {
    "unreleased"
  } else {
    "devel"
  }
}
