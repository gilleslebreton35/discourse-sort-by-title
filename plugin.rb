# name: discourse-sort-by-title
# about: Permet le tri natif par titre (A-Z) configurable depuis l'administration
# version: 0.7
# authors: gilles

enabled_site_setting :alphabetical_sort_enabled

after_initialize do
  # Autorise la colonne "title" dans le tri SQL pour le serveur
  TopicQuery::SORTABLE_MAPPING["title"] = "title"

  module ::AlphabeticalSortCategory
    # Force la valeur du tri sur "Titre" pour les catégories ciblées
    def sort_order
      if SiteSetting.alphabetical_sort_enabled && SiteSetting.alphabetical_sort_categories.present?
        target_ids = SiteSetting.alphabetical_sort_categories.split("|").map(&:to_i)
        return "title" if target_ids.include?(self.id)
      end
      super
    end

    # Force l'ordre sur "Croissant (A-Z)" pour les catégories ciblées
    def sort_ascending
      if SiteSetting.alphabetical_sort_enabled && SiteSetting.alphabetical_sort_categories.present?
        target_ids = SiteSetting.alphabetical_sort_categories.split("|").map(&:to_i)
        return true if target_ids.include?(self.id)
      end
      super
    end
  end

  # On injecte notre code directement dans le cœur du modèle Catégorie de Discourse
  ::Category.prepend(::AlphabeticalSortCategory)
end
