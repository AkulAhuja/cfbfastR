

cols <- c(
  "season", "athlete_id", "name", "position", "team", "conference",
  "avg_PPA_all", "avg_PPA_pass",
  "avg_PPA_rush", "avg_PPA_first_down", "avg_PPA_second_down",
  "avg_PPA_third_down", "avg_PPA_standard_downs", "avg_PPA_passing_downs",
  "total_PPA_all", "total_PPA_pass", "total_PPA_rush", "total_PPA_first_down",
  "total_PPA_second_down", "total_PPA_third_down",
  "total_PPA_standard_downs", "total_PPA_passing_downs"
  # "countable_plays"
)

test_that("CFB Metrics PPA Players Season", {
  skip_on_cran()
  x <- cfbd_metrics_ppa_players_season(year = 2019, team = "TCU")

  y <- cfbd_metrics_ppa_players_season(year = 2019, team = "Alabama")
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
