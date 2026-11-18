replace_header <- function(docx, header_text){
  
  tmp <- tempfile()
  dir.create(tmp)
  
  unzip(docx, exdir = tmp)
  
  headers <- list.files(
    file.path(tmp, "word"),
    pattern = "^header[0-9]+\\.xml$",
    full.names = TRUE
  )
  
  for (hdr in headers) {
    
    x <- readLines(hdr, encoding = "UTF-8", warn = FALSE)
    
    x <- gsub(
      "HEADERPLACEHOLDER",
      header_text,
      x,
      fixed = TRUE
    )
    
    writeLines(enc2utf8(x), hdr, useBytes = TRUE)
  }
  
  oldwd <- getwd()
  on.exit(setwd(oldwd))
  
  setwd(tmp)
  
  zip::zip(
    zipfile = file.path(oldwd, docx),
    files = list.files(
      recursive = TRUE,
      all.files = TRUE,
      no.. = TRUE
    )
  )
}