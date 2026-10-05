# name: discourse-sort-by-title
# about: Permet le tri natif des sujets par titre (A-Z) et l'applique automatiquement
# version: 0.3
# authors: Auto-hébergé

after_initialize do
  # 1. On autorise le serveur à trier par titre
  TopicQuery::SORTABLE_MAPPING["title"] = "topics.title"

  # 2. On protège l'exécution (évite les erreurs lors de l'installation de Discourse)
  begin
    # --- CHANGE CECI ---
    # Mets ici les "slugs" (les noms dans l'URL) des catégories à trier
    categories_a_trier = ["presentation-jeux", "presentation-jeux-a-campagne", "jeux-familles"]
    
    # 3. Le serveur applique le réglage tout seul en base de données
    Category.where(slug: categories_a_trier).each do |cat|
      if cat.sort_order != "title" || cat.sort_ascending != true
        cat.update_columns(sort_order: "title", sort_ascending: true)
      end
    end
  rescue => e
    # Ignore silencieusement si la base de données n'est pas encore prête
  end
end
