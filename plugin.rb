# name: discourse-sort-by-title
# about: Permet le tri natif des sujets par titre (A-Z)
# version: 0.1
# authors: Auto-hébergé

after_initialize do
  # Ajoute la colonne 'title' aux champs de tri autorisés par le serveur
  TopicQuery::SORTABLE_MAPPING["title"] = "topics.title"
end
