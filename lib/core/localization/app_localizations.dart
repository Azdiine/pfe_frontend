/// 🌍 Système de Localisation 2026
/// Support Français / Anglais avec traduction en temps réel

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(String locale) {
    return AppLocalizations(locale);
  }

  // ========================================
  // 🏠 WELCOME & ONBOARDING
  // ========================================

  String get welcomeTitle =>
      _translate(fr: 'Bienvenue sur MEATAY', en: 'Welcome to MEATAY');

  String get welcomeSubtitle => _translate(
    fr: 'Nutrition premium livrée\nà votre porte',
    en: 'Premium nutrition delivered\nto your doorstep',
  );

  String get getStarted => _translate(fr: 'Commencer', en: 'Get Started');

  String get alreadyHaveAccount =>
      _translate(fr: 'J\'ai déjà un compte', en: 'I already have an account');

  String get signUpNow =>
      _translate(fr: 'Commencez Maintenant', en: 'Sign Up Now');

  String get welcomeBack => _translate(fr: 'Bon Retour', en: 'Welcome Back');

  String get createAccountSeconds => _translate(
    fr: 'Créez votre compte en quelques secondes',
    en: 'Create your account in seconds',
  );

  String get signInToAccount => _translate(
    fr: 'Connectez-vous à votre compte',
    en: 'Sign in to your account',
  );

  String get continueWithEmail =>
      _translate(fr: 'Continuer avec Email', en: 'Continue with Email');

  String get termsAndPrivacy => _translate(
    fr: 'En continuant, vous acceptez nos Conditions de Service\net Politique de Confidentialité',
    en: 'By continuing, you agree to our Terms of Service\nand Privacy Policy',
  );

  // ========================================
  // 🎯 NAVIGATION
  // ========================================

  String get home => _translate(fr: 'Accueil', en: 'Home');

  String get recipesTab => _translate(fr: 'Recettes', en: 'Recipes');

  String get fridge => _translate(fr: 'Frigo', en: 'Fridge');

  String get tracking => _translate(fr: 'Suivi', en: 'Tracking');

  String get profileTab => _translate(fr: 'Profil', en: 'Profile');

  // ========================================
  // 👤 PROFILE
  // ========================================

  String get profile => _translate(fr: 'Profil', en: 'Profile');

  String get edit => _translate(fr: 'Modifier', en: 'Edit');

  String get user => _translate(fr: 'Utilisateur', en: 'User');

  String get memberSince => _translate(
    fr: 'Membre depuis février 2026',
    en: 'Member since February 2026',
  );

  String get days => _translate(fr: 'Jours', en: 'Days');

  String get streak => _translate(fr: 'Série', en: 'Streak');

  String get recipes => _translate(fr: 'Recettes', en: 'Recipes');

  String get favorites => _translate(fr: 'Favoris', en: 'Favorites');

  String get goal => _translate(fr: 'Objectif', en: 'Goal');

  String get achieved => _translate(fr: 'Atteint', en: 'Achieved');

  String get recentActivity =>
      _translate(fr: 'Activité Récente', en: 'Recent Activity');

  String get viewAll => _translate(fr: 'Voir tout', en: 'View All');

  String get dailyGoalAchieved =>
      _translate(fr: 'Objectif quotidien atteint', en: 'Daily goal achieved');

  String get newRecipeAdded =>
      _translate(fr: 'Nouvelle recette ajoutée', en: 'New recipe added');

  String get recipesAddedToFavorites => _translate(
    fr: '5 recettes mises en favoris',
    en: '5 recipes added to favorites',
  );

  String get hoursAgo => _translate(fr: 'Il y a 2 heures', en: '2 hours ago');

  String get yesterday => _translate(fr: 'Hier', en: 'Yesterday');

  String get daysAgo => _translate(fr: 'Il y a 3 jours', en: '3 days ago');

  String get settings => _translate(fr: 'Paramètres', en: 'Settings');

  String get personalInfo =>
      _translate(fr: 'Informations personnelles', en: 'Personal Information');

  String get securityAndPrivacy =>
      _translate(fr: 'Sécurité et confidentialité', en: 'Security and Privacy');

  String get notifications =>
      _translate(fr: 'Notifications', en: 'Notifications');

  String get helpAndSupport =>
      _translate(fr: 'Aide et support', en: 'Help and Support');

  String get logout => _translate(fr: 'Se déconnecter', en: 'Log Out');

  String get logoutTitle => _translate(fr: 'Déconnexion', en: 'Log Out');

  String get logoutMessage => _translate(
    fr: 'Êtes-vous sûr de vouloir vous déconnecter?',
    en: 'Are you sure you want to log out?',
  );

  String get cancel => _translate(fr: 'Annuler', en: 'Cancel');

  String get loadingProfile =>
      _translate(fr: 'Chargement du profil...', en: 'Loading profile...');

  String get error => _translate(fr: 'Erreur', en: 'Error');

  String get retry => _translate(fr: 'Réessayer', en: 'Retry');

  // ========================================
  // 🏠 HOME PAGE
  // ========================================

  // Days of the week
  String get monday => _translate(fr: 'Lundi', en: 'Monday');
  String get tuesday => _translate(fr: 'Mardi', en: 'Tuesday');
  String get wednesday => _translate(fr: 'Mercredi', en: 'Wednesday');
  String get thursday => _translate(fr: 'Jeudi', en: 'Thursday');
  String get friday => _translate(fr: 'Vendredi', en: 'Friday');
  String get saturday => _translate(fr: 'Samedi', en: 'Saturday');
  String get sunday => _translate(fr: 'Dimanche', en: 'Sunday');

  // Months
  String get january => _translate(fr: 'janvier', en: 'January');
  String get february => _translate(fr: 'février', en: 'February');
  String get march => _translate(fr: 'mars', en: 'March');
  String get april => _translate(fr: 'avril', en: 'April');
  String get may => _translate(fr: 'mai', en: 'May');
  String get june => _translate(fr: 'juin', en: 'June');
  String get july => _translate(fr: 'juillet', en: 'July');
  String get august => _translate(fr: 'août', en: 'August');
  String get september => _translate(fr: 'septembre', en: 'September');
  String get october => _translate(fr: 'octobre', en: 'October');
  String get november => _translate(fr: 'novembre', en: 'November');
  String get december => _translate(fr: 'décembre', en: 'December');

  // General
  String get greeting => _translate(fr: 'Bonjour', en: 'Hello');
  String get caloriesRemaining => _translate(
    fr: 'Il te reste 650 kcal aujourd\'hui',
    en: 'You have 650 kcal remaining today',
  );
  String get dailyNutrition =>
      _translate(fr: 'Nutrition du jour', en: 'Daily Nutrition');
  String get kcalUnit => _translate(fr: 'kcal', en: 'kcal');
  String get proteins => _translate(fr: '🥩 Protéines', en: '🥩 Proteins');
  String get carbs => _translate(fr: '🍞 Glucides', en: '🍞 Carbs');
  String get fats => _translate(fr: '🥑 Lipides', en: '🥑 Fats');
  String get outOf => _translate(fr: 'sur', en: 'out of');

  // Quick Actions
  String get quickActions =>
      _translate(fr: 'Actions rapides', en: 'Quick Actions');
  String get scan => _translate(fr: 'Scanner', en: 'Scanner');
  String get food => _translate(fr: 'aliment', en: 'food');
  String get add => _translate(fr: 'Ajouter', en: 'Add');
  String get meal => _translate(fr: 'repas', en: 'meal');
  String get chatAI => _translate(fr: 'Chat IA', en: 'AI Chat');
  String get advice => _translate(fr: 'conseils', en: 'advice');
  String get myFridge => _translate(fr: 'Mon frigo', en: 'My Fridge');
  String get ingredients => _translate(fr: 'ingrédients', en: 'ingredients');

  // Recipe recommendations
  String get recommendedForYou =>
      _translate(fr: 'Recette recommandée pour toi', en: 'Recommended for you');
  String get cook => _translate(fr: 'Cuisiner', en: 'Cook');
  String get cookWithYourIngredients => _translate(
    fr: 'À cuisiner avec tes ingrédients',
    en: 'Cook with your ingredients',
  );

  // Daily tracking
  String get dailyTracking =>
      _translate(fr: 'Suivi du jour', en: 'Daily Tracking');
  String get meals => _translate(fr: 'Repas', en: 'Meals');
  String get water => _translate(fr: 'Eau', en: 'Water');
  String get score => _translate(fr: 'Score', en: 'Score');
  String get healthyDaysStreak =>
      _translate(fr: '5 jours healthy d\'affilée', en: '5 healthy days streak');

  // Chatbot teaser
  String get needIdeas =>
      _translate(fr: 'Besoin d\'idées ?', en: 'Need ideas?');
  String get askMeRecipe =>
      _translate(fr: 'Demande-moi une recette', en: 'Ask me for a recipe');
  String get openChat => _translate(fr: 'Ouvrir chat', en: 'Open chat');

  // Units and misc
  String get minutes => _translate(fr: 'min', en: 'min');
  String get productScanned =>
      _translate(fr: 'Produit scanné', en: 'Product scanned');

  // Recipe names
  String get chickenCurry =>
      _translate(fr: '🍝 Poulet curry healthy', en: '🍝 Healthy chicken curry');
  String get veggiesOmelette =>
      _translate(fr: 'Omelette légumes', en: 'Veggie omelette');

  // ========================================
  // 📖 RECIPES PAGE
  // ========================================

  String get all => _translate(fr: 'Tous', en: 'All');
  String get breakfast => _translate(fr: 'Petit-déj', en: 'Breakfast');
  String get lunch => _translate(fr: 'Déjeuner', en: 'Lunch');
  String get dinner => _translate(fr: 'Dîner', en: 'Dinner');
  String get recipe => _translate(fr: 'Recette', en: 'Recipe');

  // ========================================
  // 📊 TRACKING PAGE
  // ========================================

  String get day => _translate(fr: 'Jour', en: 'Day');
  String get week => _translate(fr: 'Semaine', en: 'Week');
  String get month => _translate(fr: 'Mois', en: 'Month');
  String get year => _translate(fr: 'Année', en: 'Year');
  String get caloriesThisWeek =>
      _translate(fr: 'Calories cette semaine', en: 'Calories this week');
  String get statistics => _translate(fr: 'Statistiques', en: 'Statistics');
  String get thisWeek => _translate(fr: 'cette semaine', en: 'this week');
  String get activity => _translate(fr: 'Activité', en: 'Activity');
  String get weight => _translate(fr: 'Poids', en: 'Weight');
  String get averageScore => _translate(fr: 'Score moyen', en: 'Average Score');
  String get veryGood => _translate(fr: 'très bien', en: 'very good');
  String get weeklySummary =>
      _translate(fr: 'Résumé hebdomadaire', en: 'Weekly Summary');
  String get mondayShort => _translate(fr: 'Lun', en: 'Mon');
  String get tuesdayShort => _translate(fr: 'Mar', en: 'Tue');
  String get wednesdayShort => _translate(fr: 'Mer', en: 'Wed');
  String get thursdayShort => _translate(fr: 'Jeu', en: 'Thu');
  String get fridayShort => _translate(fr: 'Ven', en: 'Fri');
  String get saturdayShort => _translate(fr: 'Sam', en: 'Sat');
  String get sundayShort => _translate(fr: 'Dim', en: 'Sun');

  // ========================================
  // 🧊 FRIDGE
  // ========================================

  String get productName =>
      _translate(fr: 'Nom du Produit', en: 'Product Name');

  String get productNameHint => _translate(
    fr: 'ex: Lait, Œufs, Poulet...',
    en: 'e.g., Milk, Eggs, Chicken...',
  );

  String get quantity => _translate(fr: 'Quantité', en: 'Quantity');

  String get quantityHint =>
      _translate(fr: 'ex: 1L, 500g, 6 pcs...', en: 'e.g., 1L, 500g, 6 pcs...');

  String get expiresIn =>
      _translate(fr: 'Expire dans (jours)', en: 'Expires in (days)');

  String get numberOfDays =>
      _translate(fr: 'Nombre de jours', en: 'Number of days');

  String get category => _translate(fr: 'Catégorie', en: 'Category');

  String get fridgeLocation =>
      _translate(fr: 'Emplacement du Frigo', en: 'Fridge Location');

  String get topShelf => _translate(fr: 'Étagère Haute', en: 'Top Shelf');

  String get middleShelf =>
      _translate(fr: 'Étagère Milieu', en: 'Middle Shelf');

  String get bottomShelf => _translate(fr: 'Étagère Basse', en: 'Bottom Shelf');

  String get door => _translate(fr: 'Porte', en: 'Door');

  String get enterProductName => _translate(
    fr: 'Veuillez entrer un nom de produit',
    en: 'Please enter a product name',
  );

  String get enterQuantity => _translate(
    fr: 'Veuillez entrer une quantité',
    en: 'Please enter a quantity',
  );

  String get addedToFridge =>
      _translate(fr: 'ajouté au frigo!', en: 'added to fridge!');

  String get addToFridge =>
      _translate(fr: 'Ajouter au Frigo', en: 'Add to Fridge');

  String get aiRecipeSuggestions =>
      _translate(fr: 'Suggestions de Recettes IA', en: 'AI Recipe Suggestions');

  String get recipesYouCanMake => _translate(
    fr: 'Recettes que vous pouvez faire maintenant',
    en: 'Recipes you can make now',
  );

  // Recipe names
  String get pastaCarbonara =>
      _translate(fr: 'Pâtes Carbonara', en: 'Pasta Carbonara');

  String get caesarSalad => _translate(fr: 'Salade César', en: 'Caesar Salad');

  String get chickenSoup =>
      _translate(fr: 'Soupe au Poulet', en: 'Chicken Soup');

  String get clubSandwich =>
      _translate(fr: 'Sandwich Club', en: 'Club Sandwich');

  // Fridge UI
  String get mySmartFridge =>
      _translate(fr: '🧊 Mon Frigo Intelligent', en: '🧊 My Smart Fridge');

  String itemsExpiringSoon(int count) =>
      _translate(fr: '$count expirent bientôt', en: '$count expiring soon');

  String itemsCount(int count) =>
      _translate(fr: '$count articles', en: '$count items');

  String get addItem => _translate(fr: 'Ajouter Article', en: 'Add Item');

  String get dropItemsHere =>
      _translate(fr: 'Déposez les articles ici', en: 'Drop items here');

  String get basedOnYourIngredients => _translate(
    fr: 'Basé sur vos ingrédients',
    en: 'Based on your ingredients',
  );

  String expiringDays(int days) =>
      _translate(fr: '$days jours', en: '$days days');

  String get location => _translate(fr: 'Emplacement', en: 'Location');

  String get remove => _translate(fr: 'Supprimer', en: 'Remove');

  String get addNewIngredient =>
      _translate(fr: 'Ajouter Nouvel Ingrédient', en: 'Add New Ingredient');

  String get scanBarcode =>
      _translate(fr: 'Scanner Code-barres', en: 'Scan Barcode');

  String get addManually =>
      _translate(fr: 'Ajouter Manuellement', en: 'Add Manually');

  String get chooseIcon => _translate(fr: 'Choisir Icône', en: 'Choose Icon');

  String get addIngredientManually => _translate(
    fr: 'Ajouter Ingrédient Manuellement',
    en: 'Add Ingredient Manually',
  );

  // Categories
  String get fruits => _translate(fr: 'Fruits', en: 'Fruits');
  String get vegetables => _translate(fr: 'Légumes', en: 'Vegetables');
  String get dairy => _translate(fr: 'Produits Laitiers', en: 'Dairy');
  String get meat => _translate(fr: 'Viande', en: 'Meat');
  String get beverages => _translate(fr: 'Boissons', en: 'Beverages');
  String get condiments => _translate(fr: 'Condiments', en: 'Condiments');
  String get snacks => _translate(fr: 'Collations', en: 'Snacks');
  String get other => _translate(fr: 'Autre', en: 'Other');

  String get unknownProduct =>
      _translate(fr: 'Produit inconnu', en: 'Unknown product');

  // ========================================
  // 💬 CHATBOT & NOTIFICATIONS
  // ========================================

  String get recipeAssistant =>
      _translate(fr: 'Assistant Recettes', en: 'Recipe Assistant');

  String get online => _translate(fr: 'En ligne', en: 'Online');

  String get yourMessage =>
      _translate(fr: 'Votre message...', en: 'Your message...');

  String get markAllRead => _translate(fr: 'Tout lire', en: 'Mark all read');

  String get recipeAdded =>
      _translate(fr: 'Recette ajoutée', en: 'Recipe Added');

  String get newTrendingRecipe =>
      _translate(fr: 'Nouvelle recette tendance', en: 'New Trending Recipe');

  String get shoppingReminder =>
      _translate(fr: 'Rappel de courses', en: 'Shopping Reminder');

  String get recommendedRecipe =>
      _translate(fr: 'Recette recommandée', en: 'Recommended Recipe');

  String get challengeCompleted =>
      _translate(fr: 'Défi complété', en: 'Challenge Completed');

  // ========================================
  // 🔧 COMMON
  // ========================================

  String get language => _translate(fr: 'Langue', en: 'Language');

  String get french => _translate(fr: 'Français', en: 'French');

  String get english => _translate(fr: 'Anglais', en: 'English');

  String get selectLanguage =>
      _translate(fr: 'Sélectionner la langue', en: 'Select Language');

  String get loading => _translate(fr: 'Chargement...', en: 'Loading...');

  String get save => _translate(fr: 'Enregistrer', en: 'Save');

  String get delete => _translate(fr: 'Supprimer', en: 'Delete');

  String get search => _translate(fr: 'Rechercher', en: 'Search');

  String get close => _translate(fr: 'Fermer', en: 'Close');

  String get ok => _translate(fr: 'OK', en: 'OK');

  String get yes => _translate(fr: 'Oui', en: 'Yes');

  String get no => _translate(fr: 'Non', en: 'No');

  // ========================================
  // 🔐 HELPER METHOD
  // ========================================

  String _translate({required String fr, required String en}) {
    switch (languageCode) {
      case 'fr':
        return fr;
      case 'en':
        return en;
      default:
        return fr; // Default to French
    }
  }
}
