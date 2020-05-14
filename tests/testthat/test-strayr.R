test_that("strayr returns expected output", {

  expect_equal(strayr(1), "NSW")

  expect_equal(strayr("1"), "NSW")

  expect_equal(strayr("NSW", to = "state_abbr"), "NSW")

  expect_equal(strayr("New South Wales", fuzzy_match = FALSE), "NSW")

  expect_equal(strayr("Noo Soth Whales"), "NSW")

  expect_equal(strayr("Noo Soth Whales", fuzzy_match = FALSE), NA_character_)

  expect_equal(class(strayr("NSW", "code")), "character")

  x <- c("western Straya", "w. A ", "new soth wailes", "SA", "tazz")

  expect_length(strayr(x), 5)


  expect_equal(strayr("South Australia"), "SA")
  expect_equal(strayr("Australia"), "Aus")
  expect_equal(strayr("South Aus"), "SA")
  expect_equal(strayr("Aus"), "Aus")

  expect_equal(strayr("other"), "Oth")
  expect_equal(strayr("oth"), "Oth")


  expect_equal(strayr(c("Aus", "NSW", "Vic", "Qld", "WA", "SA", "Tas", "ACT", "NT", "OTH")),
               c("Aus", "NSW", "Vic", "Qld", "WA", "SA", "Tas", "ACT", "NT", "Oth"))

})
