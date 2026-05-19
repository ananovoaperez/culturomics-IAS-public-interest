species_description_plots <- list.files("data/species_descriptions/", full.names = TRUE) %>% 
  map(function(species_description_path){
    species_description <- read.csv(species_description_path, sep = ";") %>% 
      janitor::clean_names()
    
    species_name <- species_description %>% 
      pull(species) %>% 
      first()
    
    species_data <- europe_mainland %>% 
      select(name, geometry) %>% 
      inner_join(species_description, by = "name") %>% 
      mutate(number_of_anomalies = factor(number_of_anomalies, levels = 0:4))
    
    ggplot(species_data) +
      geom_sf(aes(fill = number_of_anomalies), color = "grey90", linewidth = 0.3) +
      geom_sf(
        data = filter(species_data, established == "Yes"),
        fill = NA, color = "black", linewidth = 0.6
      ) +
      scale_fill_manual(
        values       = anomaly_colors,
        limits       = names(anomaly_colors),
        drop         = FALSE,
        na.translate = FALSE,         # <-- klíčové
        name         = "# of anomalies"
      ) +
      coord_sf(xlim = c(-25, 45), ylim = c(32, 72), expand = FALSE) +
      theme_minimal() +
      labs(title = species_name) +
      theme(plot.title = element_text(size = 14, face = "italic"))
  })

species_description_plots <- imap(species_description_plots, function(p, i) {
  if (i == 1) p else p + guides(fill = "none")
})

wrap_plots(species_description_plots, ncol = 4) &
  theme(legend.position = "bottom")