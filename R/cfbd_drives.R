
#' @title
#' **CFBD Drives Endpoint**
#' @description
#' **Get college football game drives**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, or both
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (*String* optional): D-I Team
#' @param offense_team (*String* optional): Offense D-I Team
#' @param defense_team (*String* optional): Defense D-I Team
#' @param conference (*String* optional): DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param offense_conference (*String* optional): Offense DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param defense_conference (*String* optional): Defense DI Conference abbreviation - Select a valid FBS conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#' @return [cfbd_drives()] - A data frame with 23 variables as follows:
#' \describe{
#'   \item{`offense`:character.}{Drive offense.}
#'   \item{`offense_conference`:character.}{Drive offense's conference.}
#'   \item{`defense`:character.}{Drive defense.}
#'   \item{`defense_conference`:character.}{Drive defense's conference.}
#'   \item{`game_id`:integer.}{Unique game identifier - `game_id`.}
#'   \item{`drive_id`:character.}{Unique drive identifier - `drive_id`.}
#'   \item{`drive_number`:integer.}{Drive number in game.}
#'   \item{`scoring`:logical.}{Drive ends in a score.}
#'   \item{`start_period`:integer.}{Period (or Quarter) in which the drive starts.}
#'   \item{`start_yardline`:integer.}{Yard line at the drive start.}
#'   \item{`start_yards_to_goal`:integer.}{Yards-to-Goal at the drive start.}
#'   \item{`end_period`:integer.}{Period (or Quarter) in which the drive ends.}
#'   \item{`end_yardline`:integer.}{Yard line at drive end.}
#'   \item{`end_yards_to_goal`:integer.}{Yards-to-Goal at drive end.}
#'   \item{`plays`:integer.}{Number of drive plays.}
#'   \item{`yards`:integer.}{Total drive yards.}
#'   \item{`drive_result`:character.}{Result of the drive description.}
#'   \item{`is_home_offense`:logical.}{Flag for if the offense on the field is the home offense}
#'   \item{`start_offense_score`:numeric.}{Offense score at the start of the drive.}
#'   \item{`start_defense_score`:numeric.}{Defense score at the start of the drive.}
#'   \item{`end_offense_score`:numeric.}{Offense score at the end of the drive.}
#'   \item{`end_defense_score`:numeric.}{Defense score at the end of the drive.}
#'   \item{`time_minutes_start`:integer.}{Minutes at drive start.}
#'   \item{`time_seconds_start`:integer.}{Seconds at drive start.}
#'   \item{`time_minutes_end`:integer.}{Minutes at drive end.}
#'   \item{`time_seconds_end`:integer.}{Seconds at drive end.}
#'   \item{`time_minutes_elapsed`:double.}{Minutes elapsed during drive.}
#'   \item{`time_seconds_elapsed`:integer.}{Seconds elapsed during drive.}
#' }
#' @keywords Drives
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_drives(2018, week = 1, team = "TCU"))
#'
#'   try(cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC"))
#' }
cfbd_drives <- function(year,
                        season_type = "regular",
                        week = NULL,
                        team = NULL,
                        offense_team = NULL,
                        defense_team = NULL,
                        conference = NULL,
                        offense_conference = NULL,
                        defense_conference = NULL,
                        division = 'fbs') {

  # Check if year is numeric
  if(!is.numeric(year) && !nchar(year) == 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }

  if (!(season_type %in% c("regular","postseason","both"))){
    # Check if season_type is appropriate, if not regular
    cli::cli_abort("Enter valid season_type: regular, postseason, or both")
  }
  if (!is.null(week)&& !nchar(week) <= 2) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week 1-15 \n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(offense_team)) {
    if (offense_team == "San Jose State") {
      offense_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      offense_team <- utils::URLencode(offense_team, reserved = TRUE)
    }
  }
  if (!is.null(defense_team)) {
    if (defense_team == "San Jose State") {
      defense_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      defense_team <- utils::URLencode(defense_team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(offense_conference)) {
    # # Check offense_conference parameter in conference abbreviations, if not NULL
    # Encode offense_conference parameter for URL, if not NULL
    offense_conference <- utils::URLencode(offense_conference, reserved = TRUE)
  }
  if (!is.null(defense_conference)) {
    # # Check defense_conference parameter in conference abbreviations, if not NULL
    # Encode defense_conference parameter for URL, if not NULL
    defense_conference <- utils::URLencode(defense_conference, reserved = TRUE)
  }
  if (!is.null(division)) {
    # # Check division parameter
    division <- utils::URLencode(division, reserved = TRUE)
  }

  add_elapsed_time_columns <- function(df, start_min_col, start_sec_col, end_min_col, end_sec_col) {

    # Use dplyr's mutate and across to perform the calculation for each row
    df <- df %>%
      mutate(
        start_total_seconds = ({{start_min_col}} * 60) + {{start_sec_col}},
        end_total_seconds = ({{end_min_col}} * 60) + {{end_sec_col}},
        total_elapsed_seconds = start_total_seconds - end_total_seconds,
        elapsed_minutes = total_elapsed_seconds %/% 60,
        elapsed_seconds = total_elapsed_seconds %% 60
      ) %>%
      # Remove the intermediate calculation columns
      select(-start_total_seconds, -end_total_seconds, -total_elapsed_seconds)

    return(df)
  }

  base_url <- "https://api.collegefootballdata.com/drives?"

  params <- list(
    year = year,
    season_type = season_type,
    week = week,
    team = team,
    offense_team = offense_team,
    defense_team = defense_team,
    conference = conference,
    offense_conference = offense_conference,
    defense_conference = defense_conference,
    division = division
  )
  params <- Filter(function(x) !is.null(x) && !is.na(x) && nzchar(x), params)
  full_url <- base_url
  if (length(params) > 0) {
    # URL-encode the parameter values and collapse into a query string
    query_string <- paste(
      names(params),
      params,
      sep = "=",
      collapse = "&"
    )
    full_url <- paste0(base_url, query_string)
  }

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY(
        "GET", full_url,
        httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
      )

      # Check the result
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        janitor::clean_names() %>%
        add_elapsed_time_columns(
          start_time_minutes,
          start_time_seconds,
          end_time_minutes,
          end_time_seconds
        ) %>%
        dplyr::rename(
          "drive_id" = "id",
          "time_minutes_start" = "start_time_minutes",
          "time_seconds_start" = "start_time_seconds",
          "time_minutes_end" = "end_time_minutes",
          "time_seconds_end" = "end_time_seconds",
          "time_minutes_elapsed" = "elapsed_minutes",
          "time_seconds_elapsed" = "elapsed_seconds"
        ) %>%
        dplyr::mutate(
          time_minutes_elapsed = ifelse(is.na(.data$time_minutes_elapsed), 0, .data$time_minutes_elapsed),
          time_seconds_elapsed = ifelse(is.na(.data$time_seconds_elapsed), 0, .data$time_seconds_elapsed)
        )

      # 2021 games with pbp data from another (non-ESPN) source include extra unclear columns for hours.
      # Minutes and seconds from these games are also suspect
      if ("startTime.hours" %in% names(df)) {
        df <- df %>%
          dplyr::select(-"startTime.hours")
      }
      if ("endTime.hours" %in% names(df)) {
        df <- df %>%
          dplyr::select(-"endTime.hours")
      }

      df <- df %>%
        make_cfbfastR_data("Drives data from CollegeFootballData.com",Sys.time())

      print("DRIVE DATA\n")
      print(colnames(df))
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no drives data available!{e}"))
    },
    finally = {
    }
  )
  return(df)
}
