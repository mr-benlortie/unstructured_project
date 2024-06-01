load_comments <- function(prof_url) {
  prof_data <- data.frame(name = character(), comment = character(), stringsAsFactors = FALSE)
  
  total_ratings <- as.numeric(read_html(url(prof_url)) %>% 
                                html_element("a[href='#ratingsList']") %>% 
                                html_text() %>% 
                                str_extract("\\d+"))
  
  if (total_ratings < 20) {
    comment <- read_html(url(prof_url)) %>%
      html_elements(".Comments__StyledComments-dzzyvm-0") %>% 
      html_text()
    
    if (length(comment) > 0) {
      prof_data <- data.frame(name = rep("Professor Name", length(comment)), comment = comment)
      
      load_button <- remDr$findElement(using = "css selector", value = ".PaginationButton__StyledPaginationButton-txi1dr-1")
      
      if (length(load_button) > 0) {
        load_button$clickElement()
        
        updated_html <- remDr$getPageSource()[[1]]
        
        updated_comments <- read_html(updated_html) %>%
          html_elements(".Comments__StyledComments-dzzyvm-0") %>% 
          html_text()
        
        prof_data <- rbind(prof_data, data.frame(name = rep("Professor Name", length(updated_comments)), comment = updated_comments))
      }
    }
  }
  
  return(prof_data)
}

prof_url <- glue::glue("https://www.ratemyprofessors.com/professor/{id[4]}")


load_comments(prof_url)


<button class="Buttons__Button-sc-19xdot-1 PaginationButton__StyledPaginationButton-txi1dr-1 eUNaBX" type="button">Load More Ratings</button>