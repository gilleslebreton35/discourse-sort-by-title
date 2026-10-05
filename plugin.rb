# name: discourse-sort-by-title
# about: Applique automatiquement le tri par titre (A-Z) en base de données via l'administration
# version: 0.8
# authors: gilles

enabled_site_setting :alphabetical_sort_enabled

after_initialize do
  # 1. Autorise la colonne "title" dans le tri SQL pour le serveur
  TopicQuery::SORTABLE_MAPPING["title"] = "title"

  # 2. Fonction qui met à jour la base de données en temps réel
  def sync_alphabetical_categories
    # Récupère les IDs ciblés dans les paramètres
    target_ids = []
    if SiteSetting.alphabetical_sort_enabled && SiteSetting.alphabetical_sort_categories.present?
      target_ids = SiteSetting.alphabetical_sort_categories.split("|").map(&:to_i).reject(&:zero?)
    end

    # A. Applique le tri "Titre" aux catégories sélectionnées
    if target_ids.any?
      Category.where(id: target_ids).each do |cat|
        if cat.sort_order != 'title'
          cat.sort_order = 'title'
          cat.sort_ascending = true
          # save(validate: false) force l'enregistrement et purge le cache de Discourse !
          cat.save(validate: false) 
        end
      end
    end

    # B. Restaure les anciennes catégories qui ne sont plus dans la liste (remet par défaut)
    revert_query = Category.where(sort_order: 'title')
    revert_query = revert_query.where.not(id: target_ids) if target_ids.any?

    revert_query.each do |cat|
      cat.sort_order = '' # '' correspond au tri par défaut de Discourse (Activité)
      cat.sort_ascending = nil
      cat.save(validate: false)
    end
  end

  # 3. Exécute la synchronisation au démarrage du serveur
  begin
    sync_alphabetical_categories
  rescue => e
    # Ignore si la base de données n'est pas encore initialisée
  end

  # 4. ÉCOUTEUR MAGIQUE : Exécute la synchronisation DÈS QUE tu modifies le paramètre dans l'Admin !
  on(:site_setting_changed) do |name, old_value, new_value|
    if name == :alphabetical_sort_enabled || name == :alphabetical_sort_categories
      sync_alphabetical_categories
    end
  end
end
