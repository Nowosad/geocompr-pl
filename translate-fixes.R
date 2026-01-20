# note to self: try to translate single sentences with potential problems, not to lose the limits next time...

library(babeldown)
library(purrr)

# Read the Rmd as lines
rmd_lines <- readLines("12-spatial-cv.Rmd")

# Split into blocks of 50 lines (adjust as needed)
block_size <- 50
# rmd_lines <- blocks[[6]]
blocks <- split(rmd_lines, ceiling(seq_along(rmd_lines) / block_size))

# Test each block separately
imap(blocks, ~{
  tryCatch(
    {
      # Write block to temporary file
      tmp_in <- tempfile(fileext = ".Rmd")
      tmp_out <- tempfile(fileext = ".Rmd")
      writeLines(.x, tmp_in)
      
      # Run deepl_translate on this block
      babeldown::deepl_translate(tmp_in, tmp_out, source_lang = "EN", target_lang = "PL")
      TRUE
    },
    error = function(e) {
      message("Failed at block: ", .y)
      message("First lines of block:\n", paste(head(.x, 50), collapse = "\n"))
      message("Error: ", e$message)
      NULL
    }
  )
})
