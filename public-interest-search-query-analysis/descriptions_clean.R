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
  inner_join(desc_clean, by = c("country" = "code")) %>% 
  



desc %>% 
  filter(species == "Procyon lotor")
