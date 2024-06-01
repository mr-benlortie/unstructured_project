library(rvest)
library(magrittr)
library(stringr)


# base_link "https://www.ratemyprofessors.com/professor/"

name <- c("Wan Ting Chu", "Robert Holland", "Chad Allred", "Andrew Freed", "Olga Senicheva")

# links <- c("https://www.ratemyprofessors.com/professor/2560231", 
#                 "https://www.ratemyprofessors.com/professor/799230",
#                 "https://www.ratemyprofessors.com/professor/2369546",
#                 "https://www.ratemyprofessors.com/professor/1887440",
#                 "https://www.ratemyprofessors.com/professor/2384348")
#
# prof_id <- str_extract(links, "\\d+$")

id <- c("2560231", "799230", "2369546", "1887440", "2384348")

prof_table <- data.frame(name, id, dept = NA, avg_rating = NA, total_ratings = NA)

prof_data_list <- list()

for (i in 1:nrow(prof_table)) {
  prof_id <- prof_table$id[i]
  prof_url <- glue::glue("https://www.ratemyprofessors.com/professor/{prof_id}")
  
  dept <- read_html(url(prof_url)) %>% 
    html_element(".TeacherDepartment__StyledDepartmentLink-fl79e8-0") %>% 
    html_text() %>% 
    gsub("\\sdepartment", "", .)
  
  avg_rating <- read_html(url(prof_url)) %>% 
    html_element(".RatingValue__Numerator-qw8sqy-2") %>% 
    html_text()
  
  total_ratings <- read_html(url(prof_url)) %>% 
    html_element("a[href='#ratingsList']") %>% 
    html_text() %>% 
    str_extract("\\d+")
  
  prof_table[i, c("dept", "avg_rating", "total_ratings")] <- c(dept, avg_rating, total_ratings)
}

comments <- read.csv("C:/Users/blort/OneDrive/Desktop/MSBR70310/Project/comments.csv")

table <- merge(prof_table, comments, by = "id")
