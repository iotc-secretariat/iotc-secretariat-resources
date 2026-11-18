docx_to_pdf <- function(docx, pdf = sub("\\.docx$", ".pdf", docx, ignore.case = TRUE)) {

  docx <- normalizePath(docx, winslash = "\\", mustWork = TRUE)
  pdf  <- normalizePath(pdf, winslash = "\\", mustWork = FALSE)

  ps_script <- tempfile(fileext = ".ps1")

  script <- sprintf(
    '$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

try {
    $doc = $word.Documents.Open("%s")

    # 17 = PDF
    # 0  = optimise for print quality
    $doc.ExportAsFixedFormat(
        "%s",
        17,
        $false,
        0
    )

    $doc.Close($false)
}
finally {
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
}',
    gsub("\\\\", "\\\\\\\\", docx),
    gsub("\\\\", "\\\\\\\\", pdf)
  )

  writeLines(script, ps_script)

  result <- system2(
    "powershell",
    c(
      "-NoProfile",
      "-ExecutionPolicy", "Bypass",
      "-File", shQuote(ps_script)
    ),
    stdout = TRUE,
    stderr = TRUE
  )

  unlink(ps_script)

  if (!file.exists(pdf)) {
    stop(
      "PDF conversion  failed:\n",
      paste(result, collapse = "\n"),
      call. = FALSE
    )
  }

  message("PDF created: ", pdf)
  invisible(pdf)
}