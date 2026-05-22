data_with_anomaly_high %>% filter(species == "Procyon lotor")


desc <- read.csv("data/species_descriptions/descriptive_data_racoon.csv", sep = ";") %>% 
  janitor::clean_names()


desc_clean <- desc %>% 
  select(species, name, code, established, first_record)


data_with_anomaly_high %>% 
  group_by(country) %>% 
  arrange(desc(mentions)) %>%
  slice_head(n = 10) %>%
  filter(species == "Procyon lotor")  %>% 
  ungroup() %>% 
  # filter(anomaly == "Yes") %>% 
  inner_join(desc_clean, by = c("country" = "code"))
  


list.files("data/species_descriptions/", full.names = T) %>% 
  str_subset("racoon") %>% 
  str_subset("_clean", negate = T) %>% 
  walk(function(x){
    x %>% 
      read.csv2() %>% 
      janitor::clean_names() %>% 
      rename(country = code) %>% 
      select(species, country, name, established, first_record) %>% 
      write_csv(str_replace(x, "[.]csv$", "_clean.csv"))
  })
