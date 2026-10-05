# name: discourse-sort-by-title
# about: Permet le tri natif des sujets par titre (A-Z) et l'applique automatiquement
# version: 0.4
# authors: gilles

after_initialize do
  # 1. On autorise le serveur à trier par titre (Correction : on utilise juste "title")
  TopicQuery::SORTABLE_MAPPING["title"] = "title"

  # 2. Application automatique en base de données
  begin
    # Ajoute les slugs de tes catégories ici (ex: "presentation-jeux")
    categories_a_trier = ["presentation-jeux","presentation-jeux-a-campagne","jeux-familles"]
    
    Category.where(slug: categories_a_trier).each do |cat|
      if cat.sort_order != "title" || cat.sort_ascending != true
        cat.update_columns(sort_order: "title", sort_ascending: true)
      end
    end
  rescue => e
    # Ignore silencieusement si la base de données n'est pas encore prête au boot
  end
end
