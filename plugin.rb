# name: discourse-sort-by-title
# about: Permet le tri natif par titre (A-Z) configurable depuis l'administration
# version: 0.6
# authors: Auto-hébergé

enabled_site_setting :alphabetical_sort_enabled

after_initialize do
  # Autorise la colonne "title" dans le tri SQL
  TopicQuery::SORTABLE_MAPPING["title"] = "title"

  module ::AlphabeticalSortTopicQuery
    def build_topic_results(options = {})
      # On ne trie que si le plugin est activé globalement
      if SiteSetting.alphabetical_sort_enabled
        category_id = options[:category] || @category&.id

        if category_id.present? && SiteSetting.alphabetical_sort_categories.present?
          target_ids = SiteSetting.alphabetical_sort_categories.split("|").map(&:to_i)

          # Si la catégorie est sélectionnée et qu'aucun tri manuel n'est demandé par l'utilisateur
          if target_ids.include?(category_id.to_i) && options[:order].blank?
            options[:order] = "title"
            options[:ascending] = "true"
          end
        end
      end

      super(options)
    end
  end

  ::TopicQuery.prepend(::AlphabeticalSortTopicQuery)
end
