import { withPluginApi } from "discourse/lib/plugin-api";
import { CATEGORY_SORT_ORDERS } from "discourse/models/category";
import I18n from "I18n";

export default {
  name: "add-title-sort-option",
  initialize() {
    withPluginApi("1.8.0", () => {
      // Ajoute "title" à la liste des choix autorisés dans le menu déroulant
      if (!CATEGORY_SORT_ORDERS.includes("title")) {
        CATEGORY_SORT_ORDERS.push("title");
      }

      // Définit le libellé affiché dans l'interface Admin
      if (I18n.translations[I18n.locale]) {
        I18n.translations[I18n.locale].js.category = I18n.translations[I18n.locale].js.category || {};
        I18n.translations[I18n.locale].js.category.sort_options = I18n.translations[I18n.locale].js.category.sort_options || {};
        
        I18n.translations[I18n.locale].js.category.sort_options.title = "Titre (A-Z)";
      }
    });
  },
};
