FlexouilleLaTableMonDalon <- function(DataSet){ 
  
  FT <- 
    DataSet |> 
    data.table::data.table() |>
    flextable::flextable() |> 
    flextable::font(part = "all", fontname = "Calibri") |>  
    flextable::fontsize(part = "all", size = 9) |> 
    flextable::align(part = "header", align = "center") |>  
    flextable::bold(part = "header") |>  
    flextable::bg(part = "header", bg = "gray") |>  
    flextable::border_inner(border = officer::fp_border()) |> 
    flextable::border_outer(border = officer::fp_border(width = 2)) |> 
    flextable::colformat_double(digits = 0) |> 
    flextable::autofit()
  
  return(FT)
}