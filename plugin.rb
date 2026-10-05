# name: discourse-sort-by-title
# about: Permet le tri natif des sujets par titre (A-Z) et l'ajoute au menu admin
# version: 0.2
# authors: Auto-hébergé

after_initialize do
  # Débloque le tri par titre dans la requête SQL
  TopicQuery::SORTABLE_MAPPING["title"] = "topics.title"
end
