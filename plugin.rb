# name: discourse-sort-by-title
# about: Permet le tri natif par titre (A-Z) configurable depuis l'administration
# version: 0.5
# authors: Auto-hébergé

enabled_site_setting :alphabetical_sort_categories

after_initialize do
  # 1. Autorise la colonne "title" dans le tri SQL
  TopicQuery::SORTABLE_MAPPING["title"] = "title"

  # 2. Surcharge TopicQuery pour appliquer le tri automatiquement aux catégories ciblées
  module ::AlphabeticalSortTopicQuery
    def build_topic_results(options = {})
      category_id = options[:category] || @category&.id

      if category_id.present? && SiteSetting.alphabetical_sort_categories.present?
        target_ids = SiteSetting.alphabetical_sort_categories.split("|").map(&:to_i)

        # Si la catégorie est dans le paramètre et qu'aucun tri manuel n'est demandé
        if target_ids.include?(category_id.to_i) && options[:order].blank?
          options[:order] = "title"
          options[:ascending] = "true"
        end
      end

      super(options)
    end
  end

  ::TopicQuery.prepend(::AlphabeticalSortTopicQuery)
end
