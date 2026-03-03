import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'SmartNutri'**
  String get appTitle;

  /// Welcome screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to MEATAY'**
  String get welcomeTitle;

  /// Welcome screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Your smart cooking companion powered by AI'**
  String get welcomeSubtitle;

  /// Welcome screen message
  ///
  /// In en, this message translates to:
  /// **'Your AI-powered nutrition companion'**
  String get welcomeMessage;

  /// Button to start using the app
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Finish button
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Login prompt text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Sign up modal title
  ///
  /// In en, this message translates to:
  /// **'Sign Up Now'**
  String get signUpNow;

  /// Sign up modal subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your account in seconds'**
  String get createAccountSeconds;

  /// Email login/signup button
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// Terms and privacy notice
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get termsAndPrivacy;

  /// Login modal title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Login modal subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Track Your Nutrition'**
  String get onboardingTitle1;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Monitor your daily calories, macros, and reach your health goals'**
  String get onboardingDesc1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Smart Fridge Management'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Scan ingredients, track expiration dates, and reduce food waste'**
  String get onboardingDesc2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'AI Recipe Suggestions'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Get personalized recipes based on your ingredients and preferences'**
  String get onboardingDesc3;

  /// First onboarding question
  ///
  /// In en, this message translates to:
  /// **'What\'\'s your main health goal?'**
  String get onboardingQuestion1;

  /// No description provided for @goalLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get goalLoseWeight;

  /// No description provided for @goalGainMuscle.
  ///
  /// In en, this message translates to:
  /// **'Gain Muscle'**
  String get goalGainMuscle;

  /// No description provided for @goalMaintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain Health'**
  String get goalMaintain;

  /// No description provided for @goalImproveEnergy.
  ///
  /// In en, this message translates to:
  /// **'Improve Energy'**
  String get goalImproveEnergy;

  /// Second onboarding question
  ///
  /// In en, this message translates to:
  /// **'How active are you?'**
  String get onboardingQuestion2;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get activitySedentary;

  /// No description provided for @activityLight.
  ///
  /// In en, this message translates to:
  /// **'Lightly Active'**
  String get activityLight;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderately Active'**
  String get activityModerate;

  /// No description provided for @activityVery.
  ///
  /// In en, this message translates to:
  /// **'Very Active'**
  String get activityVery;

  /// No description provided for @activityExtreme.
  ///
  /// In en, this message translates to:
  /// **'Extremely Active'**
  String get activityExtreme;

  /// Third onboarding question
  ///
  /// In en, this message translates to:
  /// **'Do you have dietary restrictions?'**
  String get onboardingQuestion3;

  /// No description provided for @dietNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get dietNone;

  /// No description provided for @dietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-Free'**
  String get dietGlutenFree;

  /// No description provided for @dietDairyFree.
  ///
  /// In en, this message translates to:
  /// **'Dairy-Free'**
  String get dietDairyFree;

  /// No description provided for @dietKeto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get dietKeto;

  /// No description provided for @dietPaleo.
  ///
  /// In en, this message translates to:
  /// **'Paleo'**
  String get dietPaleo;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Recipes navigation label
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// Fridge navigation label
  ///
  /// In en, this message translates to:
  /// **'Fridge'**
  String get fridge;

  /// Tracking navigation label
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Language change confirmation message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @nutritionGoals.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Goals'**
  String get nutritionGoals;

  /// No description provided for @healthStats.
  ///
  /// In en, this message translates to:
  /// **'Health Statistics'**
  String get healthStats;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @dailyCalorieGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Goal'**
  String get dailyCalorieGoal;

  /// No description provided for @proteinGoal.
  ///
  /// In en, this message translates to:
  /// **'Protein Goal'**
  String get proteinGoal;

  /// No description provided for @carbsGoal.
  ///
  /// In en, this message translates to:
  /// **'Carbs Goal'**
  String get carbsGoal;

  /// No description provided for @fatsGoal.
  ///
  /// In en, this message translates to:
  /// **'Fats Goal'**
  String get fatsGoal;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// Greeting message
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get greeting;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @caloriesRemaining.
  ///
  /// In en, this message translates to:
  /// **'Calories Remaining'**
  String get caloriesRemaining;

  /// No description provided for @caloriesConsumed.
  ///
  /// In en, this message translates to:
  /// **'Calories Consumed'**
  String get caloriesConsumed;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get caloriesBurned;

  /// No description provided for @dailyNutrition.
  ///
  /// In en, this message translates to:
  /// **'Daily Nutrition'**
  String get dailyNutrition;

  /// No description provided for @nutritionSummary.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Summary'**
  String get nutritionSummary;

  /// No description provided for @macroBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Macro Breakdown'**
  String get macroBreakdown;

  /// No description provided for @proteins.
  ///
  /// In en, this message translates to:
  /// **'Proteins'**
  String get proteins;

  /// No description provided for @proteinShort.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get proteinShort;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @carbsShort.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbsShort;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fats;

  /// No description provided for @fatsShort.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fatsShort;

  /// No description provided for @fiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fiber;

  /// No description provided for @sugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sugar;

  /// No description provided for @sodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodium;

  /// Grams unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get gramsUnit;

  /// Kilocalories unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcalUnit;

  /// Milliliters unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get mlUnit;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @scanFood.
  ///
  /// In en, this message translates to:
  /// **'Scan Food'**
  String get scanFood;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get addMeal;

  /// No description provided for @logWater.
  ///
  /// In en, this message translates to:
  /// **'Log Water'**
  String get logWater;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @scanProduct.
  ///
  /// In en, this message translates to:
  /// **'Scan Product'**
  String get scanProduct;

  /// No description provided for @scanningProduct.
  ///
  /// In en, this message translates to:
  /// **'Scanning product...'**
  String get scanningProduct;

  /// No description provided for @productFound.
  ///
  /// In en, this message translates to:
  /// **'Product found'**
  String get productFound;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient'**
  String get addIngredient;

  /// No description provided for @addNewIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add New Ingredient'**
  String get addNewIngredient;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add Manually'**
  String get addManually;

  /// No description provided for @addIngredientManually.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient Manually'**
  String get addIngredientManually;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommendedForYou;

  /// No description provided for @popularRecipes.
  ///
  /// In en, this message translates to:
  /// **'Popular Recipes'**
  String get popularRecipes;

  /// No description provided for @trendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// No description provided for @recentlyViewed.
  ///
  /// In en, this message translates to:
  /// **'Recently Viewed'**
  String get recentlyViewed;

  /// No description provided for @recipe.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get recipe;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @prepTime.
  ///
  /// In en, this message translates to:
  /// **'Prep Time'**
  String get prepTime;

  /// No description provided for @cookTime.
  ///
  /// In en, this message translates to:
  /// **'Cook Time'**
  String get cookTime;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @cook.
  ///
  /// In en, this message translates to:
  /// **'Cook'**
  String get cook;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @viewRecipe.
  ///
  /// In en, this message translates to:
  /// **'View Recipe'**
  String get viewRecipe;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @cookWithYourIngredients.
  ///
  /// In en, this message translates to:
  /// **'Cook with Your Ingredients'**
  String get cookWithYourIngredients;

  /// No description provided for @myFridge.
  ///
  /// In en, this message translates to:
  /// **'My Fridge'**
  String get myFridge;

  /// No description provided for @ingredientsAvailable.
  ///
  /// In en, this message translates to:
  /// **'ingredients available'**
  String get ingredientsAvailable;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @desserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get desserts;

  /// No description provided for @drinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get drinks;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @aiRecipeSuggestions.
  ///
  /// In en, this message translates to:
  /// **'AI Recipe Suggestions'**
  String get aiRecipeSuggestions;

  /// No description provided for @basedOnYourIngredients.
  ///
  /// In en, this message translates to:
  /// **'Based on your ingredients'**
  String get basedOnYourIngredients;

  /// No description provided for @pastaCarbonara.
  ///
  /// In en, this message translates to:
  /// **'Pasta Carbonara'**
  String get pastaCarbonara;

  /// No description provided for @caesarSalad.
  ///
  /// In en, this message translates to:
  /// **'Caesar Salad'**
  String get caesarSalad;

  /// No description provided for @mySmartFridge.
  ///
  /// In en, this message translates to:
  /// **'My Smart Fridge'**
  String get mySmartFridge;

  /// No description provided for @fridgeInventory.
  ///
  /// In en, this message translates to:
  /// **'Fridge Inventory'**
  String get fridgeInventory;

  /// Message showing how many items are expiring soon
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items expiring soon} =1{1 item expiring soon} other{{count} items expiring soon}}'**
  String itemsExpiringSoon(int count);

  /// Count of items in fridge
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemsCount(int count);

  /// Days until expiration
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Expires today} =1{Expires in 1 day} other{Expires in {days} days}}'**
  String expiringDays(int days);

  /// No description provided for @dropItemsHere.
  ///
  /// In en, this message translates to:
  /// **'Drop items here'**
  String get dropItemsHere;

  /// No description provided for @dragToRearrange.
  ///
  /// In en, this message translates to:
  /// **'Drag to rearrange'**
  String get dragToRearrange;

  /// No description provided for @topShelf.
  ///
  /// In en, this message translates to:
  /// **'Top Shelf'**
  String get topShelf;

  /// No description provided for @middleShelf.
  ///
  /// In en, this message translates to:
  /// **'Middle Shelf'**
  String get middleShelf;

  /// No description provided for @bottomShelf.
  ///
  /// In en, this message translates to:
  /// **'Bottom Shelf'**
  String get bottomShelf;

  /// No description provided for @door.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get door;

  /// No description provided for @freezer.
  ///
  /// In en, this message translates to:
  /// **'Freezer'**
  String get freezer;

  /// No description provided for @fridgeLocation.
  ///
  /// In en, this message translates to:
  /// **'Fridge Location'**
  String get fridgeLocation;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @shelfLocation.
  ///
  /// In en, this message translates to:
  /// **'Shelf Location'**
  String get shelfLocation;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 500g, 2 pieces'**
  String get quantityHint;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires In'**
  String get expiresIn;

  /// No description provided for @expirationDate.
  ///
  /// In en, this message translates to:
  /// **'Expiration Date'**
  String get expirationDate;

  /// No description provided for @numberOfDays.
  ///
  /// In en, this message translates to:
  /// **'Number of Days'**
  String get numberOfDays;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'days remaining'**
  String get daysRemaining;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @productNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Milk, Chicken'**
  String get productNameHint;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose Icon'**
  String get chooseIcon;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get dairy;

  /// No description provided for @meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// No description provided for @fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// No description provided for @grains.
  ///
  /// In en, this message translates to:
  /// **'Grains'**
  String get grains;

  /// No description provided for @beverages.
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get beverages;

  /// No description provided for @condiments.
  ///
  /// In en, this message translates to:
  /// **'Condiments'**
  String get condiments;

  /// No description provided for @snacksCategory.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacksCategory;

  /// No description provided for @otherCategory.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCategory;

  /// No description provided for @unknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown Product'**
  String get unknownProduct;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Please enter product name'**
  String get enterProductName;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get enterQuantity;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategory;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select a location'**
  String get selectLocation;

  /// No description provided for @addedToFridge.
  ///
  /// In en, this message translates to:
  /// **'added to fridge!'**
  String get addedToFridge;

  /// No description provided for @addToFridge.
  ///
  /// In en, this message translates to:
  /// **'Add to Fridge'**
  String get addToFridge;

  /// No description provided for @removeFromFridge.
  ///
  /// In en, this message translates to:
  /// **'Remove from Fridge'**
  String get removeFromFridge;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @editIngredient.
  ///
  /// In en, this message translates to:
  /// **'Edit Ingredient'**
  String get editIngredient;

  /// No description provided for @deleteIngredient.
  ///
  /// In en, this message translates to:
  /// **'Delete Ingredient'**
  String get deleteIngredient;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @caloriesThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Calories This Week'**
  String get caloriesThisWeek;

  /// No description provided for @caloriesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Calories This Month'**
  String get caloriesThisMonth;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntake;

  /// No description provided for @glassesOfWater.
  ///
  /// In en, this message translates to:
  /// **'glasses of water'**
  String get glassesOfWater;

  /// No description provided for @dailyWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Water Goal'**
  String get dailyWaterGoal;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @activeMinutes.
  ///
  /// In en, this message translates to:
  /// **'Active Minutes'**
  String get activeMinutes;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @stepsToday.
  ///
  /// In en, this message translates to:
  /// **'Steps Today'**
  String get stepsToday;

  /// No description provided for @weightTracking.
  ///
  /// In en, this message translates to:
  /// **'Weight Tracking'**
  String get weightTracking;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @goalWeight.
  ///
  /// In en, this message translates to:
  /// **'Goal Weight'**
  String get goalWeight;

  /// No description provided for @weightProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight Progress'**
  String get weightProgress;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get averageScore;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @nutritionScore.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Score'**
  String get nutritionScore;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummary;

  /// No description provided for @monthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummary;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @progressTracking.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get progressTracking;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @mealsLogged.
  ///
  /// In en, this message translates to:
  /// **'Meals Logged'**
  String get mealsLogged;

  /// No description provided for @totalMeals.
  ///
  /// In en, this message translates to:
  /// **'Total Meals'**
  String get totalMeals;

  /// No description provided for @healthyDaysStreak.
  ///
  /// In en, this message translates to:
  /// **'Healthy Days Streak'**
  String get healthyDaysStreak;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get chatbot;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @nutritionAssistant.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Assistant'**
  String get nutritionAssistant;

  /// No description provided for @askMeAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything...'**
  String get askMeAnything;

  /// No description provided for @needIdeas.
  ///
  /// In en, this message translates to:
  /// **'Need Ideas?'**
  String get needIdeas;

  /// No description provided for @askMeRecipe.
  ///
  /// In en, this message translates to:
  /// **'Ask me for a recipe!'**
  String get askMeRecipe;

  /// No description provided for @openChat.
  ///
  /// In en, this message translates to:
  /// **'Open Chat'**
  String get openChat;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get chatPlaceholder;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChat;

  /// No description provided for @chatAIAdvice.
  ///
  /// In en, this message translates to:
  /// **'AI Nutrition Advice'**
  String get chatAIAdvice;

  /// No description provided for @getAdvice.
  ///
  /// In en, this message translates to:
  /// **'Get Advice'**
  String get getAdvice;

  /// No description provided for @dailyTracking.
  ///
  /// In en, this message translates to:
  /// **'Daily Tracking'**
  String get dailyTracking;

  /// No description provided for @weeklyTracking.
  ///
  /// In en, this message translates to:
  /// **'Weekly Tracking'**
  String get weeklyTracking;

  /// No description provided for @monthlyTracking.
  ///
  /// In en, this message translates to:
  /// **'Monthly Tracking'**
  String get monthlyTracking;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @myGoals.
  ///
  /// In en, this message translates to:
  /// **'My Goals'**
  String get myGoals;

  /// No description provided for @achievedGoals.
  ///
  /// In en, this message translates to:
  /// **'Achieved Goals'**
  String get achievedGoals;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoading;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noConnection;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get timeout;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully'**
  String get successMessage;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noRecipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipes;

  /// No description provided for @noIngredients.
  ///
  /// In en, this message translates to:
  /// **'No ingredients available'**
  String get noIngredients;

  /// No description provided for @emptyFridge.
  ///
  /// In en, this message translates to:
  /// **'Your fridge is empty'**
  String get emptyFridge;

  /// No description provided for @emptyFridgeMessage.
  ///
  /// In en, this message translates to:
  /// **'Start adding ingredients to see them here'**
  String get emptyFridgeMessage;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationTitle;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @reminderNotifications.
  ///
  /// In en, this message translates to:
  /// **'Reminder Notifications'**
  String get reminderNotifications;

  /// No description provided for @expirationReminder.
  ///
  /// In en, this message translates to:
  /// **'Expiration Reminder'**
  String get expirationReminder;

  /// No description provided for @mealReminder.
  ///
  /// In en, this message translates to:
  /// **'Meal Reminder'**
  String get mealReminder;

  /// No description provided for @waterReminder.
  ///
  /// In en, this message translates to:
  /// **'Water Reminder'**
  String get waterReminder;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Label for question
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// Question progress indicator
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionOf(int current, int total);

  /// No description provided for @pleaseSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one option'**
  String get pleaseSelectOption;

  /// No description provided for @specifyHere.
  ///
  /// In en, this message translates to:
  /// **'Specify here...'**
  String get specifyHere;

  /// No description provided for @onbQ1.
  ///
  /// In en, this message translates to:
  /// **'How many people do you cook for?'**
  String get onbQ1;

  /// No description provided for @onbQ1Sub.
  ///
  /// In en, this message translates to:
  /// **'Very important for portions.'**
  String get onbQ1Sub;

  /// No description provided for @onbQ1Opt1.
  ///
  /// In en, this message translates to:
  /// **'Just me'**
  String get onbQ1Opt1;

  /// No description provided for @onbQ1Opt2.
  ///
  /// In en, this message translates to:
  /// **'2 people'**
  String get onbQ1Opt2;

  /// No description provided for @onbQ1Opt3.
  ///
  /// In en, this message translates to:
  /// **'3–4'**
  String get onbQ1Opt3;

  /// No description provided for @onbQ1Opt4.
  ///
  /// In en, this message translates to:
  /// **'5+'**
  String get onbQ1Opt4;

  /// No description provided for @onbQ1Ben1.
  ///
  /// In en, this message translates to:
  /// **'adjust portions'**
  String get onbQ1Ben1;

  /// No description provided for @onbQ1Ben2.
  ///
  /// In en, this message translates to:
  /// **'auto shopping list'**
  String get onbQ1Ben2;

  /// No description provided for @onbQ2.
  ///
  /// In en, this message translates to:
  /// **'How often do you cook per week?'**
  String get onbQ2;

  /// No description provided for @onbQ2Opt1.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get onbQ2Opt1;

  /// No description provided for @onbQ2Opt2.
  ///
  /// In en, this message translates to:
  /// **'1–2 times'**
  String get onbQ2Opt2;

  /// No description provided for @onbQ2Opt3.
  ///
  /// In en, this message translates to:
  /// **'3–5 times'**
  String get onbQ2Opt3;

  /// No description provided for @onbQ2Opt4.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get onbQ2Opt4;

  /// No description provided for @onbQ2Ben1.
  ///
  /// In en, this message translates to:
  /// **'recommendation frequency'**
  String get onbQ2Ben1;

  /// No description provided for @onbQ2Ben2.
  ///
  /// In en, this message translates to:
  /// **'meal plan or not'**
  String get onbQ2Ben2;

  /// No description provided for @onbQ3.
  ///
  /// In en, this message translates to:
  /// **'Max time for a meal?'**
  String get onbQ3;

  /// No description provided for @onbQ3Sub.
  ///
  /// In en, this message translates to:
  /// **'Super important for UX.'**
  String get onbQ3Sub;

  /// No description provided for @onbQ3Opt1.
  ///
  /// In en, this message translates to:
  /// **'10 min (quick)'**
  String get onbQ3Opt1;

  /// No description provided for @onbQ3Opt2.
  ///
  /// In en, this message translates to:
  /// **'20 min'**
  String get onbQ3Opt2;

  /// No description provided for @onbQ3Opt3.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get onbQ3Opt3;

  /// No description provided for @onbQ3Opt4.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'\'t matter'**
  String get onbQ3Opt4;

  /// No description provided for @onbQ3Ben1.
  ///
  /// In en, this message translates to:
  /// **'filter long recipes'**
  String get onbQ3Ben1;

  /// No description provided for @onbQ3Ben2.
  ///
  /// In en, this message translates to:
  /// **'express recipes'**
  String get onbQ3Ben2;

  /// No description provided for @onbQ4.
  ///
  /// In en, this message translates to:
  /// **'Your cooking level?'**
  String get onbQ4;

  /// No description provided for @onbQ4Opt1.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get onbQ4Opt1;

  /// No description provided for @onbQ4Opt2.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get onbQ4Opt2;

  /// No description provided for @onbQ4Opt3.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get onbQ4Opt3;

  /// No description provided for @onbQ4Ben1.
  ///
  /// In en, this message translates to:
  /// **'recipe difficulty'**
  String get onbQ4Ben1;

  /// No description provided for @onbQ4Ben2.
  ///
  /// In en, this message translates to:
  /// **'simplified steps'**
  String get onbQ4Ben2;

  /// No description provided for @onbQ4Ben3.
  ///
  /// In en, this message translates to:
  /// **'tutorials or not'**
  String get onbQ4Ben3;

  /// No description provided for @onbQ5.
  ///
  /// In en, this message translates to:
  /// **'Your dietary preferences?'**
  String get onbQ5;

  /// No description provided for @onbQ5Opt1.
  ///
  /// In en, this message translates to:
  /// **'Omnivore'**
  String get onbQ5Opt1;

  /// No description provided for @onbQ5Opt2.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get onbQ5Opt2;

  /// No description provided for @onbQ5Opt3.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get onbQ5Opt3;

  /// No description provided for @onbQ5Opt4.
  ///
  /// In en, this message translates to:
  /// **'Halal'**
  String get onbQ5Opt4;

  /// No description provided for @onbQ5Opt5.
  ///
  /// In en, this message translates to:
  /// **'No pork'**
  String get onbQ5Opt5;

  /// No description provided for @onbQ5Opt6.
  ///
  /// In en, this message translates to:
  /// **'Lactose-free'**
  String get onbQ5Opt6;

  /// No description provided for @onbQ5Opt7.
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
  String get onbQ5Opt7;

  /// No description provided for @onbQ5Opt8.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get onbQ5Opt8;

  /// No description provided for @onbQ5Ben1.
  ///
  /// In en, this message translates to:
  /// **'automatic recipe filter'**
  String get onbQ5Ben1;

  /// No description provided for @onbQ6.
  ///
  /// In en, this message translates to:
  /// **'Allergies or forbidden foods?'**
  String get onbQ6;

  /// No description provided for @onbQ6Opt1.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get onbQ6Opt1;

  /// No description provided for @onbQ6Opt2.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get onbQ6Opt2;

  /// No description provided for @onbQ6Opt3.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get onbQ6Opt3;

  /// No description provided for @onbQ6Opt4.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get onbQ6Opt4;

  /// No description provided for @onbQ6Opt5.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onbQ6Opt5;

  /// No description provided for @onbQ6Opt6.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get onbQ6Opt6;

  /// No description provided for @onbQ6Ben1.
  ///
  /// In en, this message translates to:
  /// **'safety + medical credibility'**
  String get onbQ6Ben1;

  /// No description provided for @onbQ7.
  ///
  /// In en, this message translates to:
  /// **'What type of dishes do you prefer?'**
  String get onbQ7;

  /// No description provided for @onbQ7Sub.
  ///
  /// In en, this message translates to:
  /// **'Fun + useful for personalization'**
  String get onbQ7Sub;

  /// No description provided for @onbQ7Opt1.
  ///
  /// In en, this message translates to:
  /// **'Quick / simple'**
  String get onbQ7Opt1;

  /// No description provided for @onbQ7Opt2.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get onbQ7Opt2;

  /// No description provided for @onbQ7Opt3.
  ///
  /// In en, this message translates to:
  /// **'High protein (sport)'**
  String get onbQ7Opt3;

  /// No description provided for @onbQ7Opt4.
  ///
  /// In en, this message translates to:
  /// **'Budget-friendly'**
  String get onbQ7Opt4;

  /// No description provided for @onbQ7Opt5.
  ///
  /// In en, this message translates to:
  /// **'Gourmet / comfort food'**
  String get onbQ7Opt5;

  /// No description provided for @onbQ7Opt6.
  ///
  /// In en, this message translates to:
  /// **'World cuisine'**
  String get onbQ7Opt6;

  /// No description provided for @onbQ7Opt7.
  ///
  /// In en, this message translates to:
  /// **'Traditional'**
  String get onbQ7Opt7;

  /// No description provided for @onbQ7Ben1.
  ///
  /// In en, this message translates to:
  /// **'personalized recommendations'**
  String get onbQ7Ben1;

  /// No description provided for @onbQ8.
  ///
  /// In en, this message translates to:
  /// **'Food budget?'**
  String get onbQ8;

  /// No description provided for @onbQ8Opt1.
  ///
  /// In en, this message translates to:
  /// **'Low budget'**
  String get onbQ8Opt1;

  /// No description provided for @onbQ8Opt2.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get onbQ8Opt2;

  /// No description provided for @onbQ8Opt3.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get onbQ8Opt3;

  /// No description provided for @onbQ8Ben1.
  ///
  /// In en, this message translates to:
  /// **'ingredient choices (rice/chicken vs salmon/avocado)'**
  String get onbQ8Ben1;

  /// No description provided for @onbQ9.
  ///
  /// In en, this message translates to:
  /// **'What equipment do you have?'**
  String get onbQ9;

  /// No description provided for @onbQ9Sub.
  ///
  /// In en, this message translates to:
  /// **'Specific and very smart'**
  String get onbQ9Sub;

  /// No description provided for @onbQ9Opt1.
  ///
  /// In en, this message translates to:
  /// **'Oven'**
  String get onbQ9Opt1;

  /// No description provided for @onbQ9Opt2.
  ///
  /// In en, this message translates to:
  /// **'Microwave'**
  String get onbQ9Opt2;

  /// No description provided for @onbQ9Opt3.
  ///
  /// In en, this message translates to:
  /// **'Air fryer'**
  String get onbQ9Opt3;

  /// No description provided for @onbQ9Opt4.
  ///
  /// In en, this message translates to:
  /// **'Blender'**
  String get onbQ9Opt4;

  /// No description provided for @onbQ9Opt5.
  ///
  /// In en, this message translates to:
  /// **'Food processor'**
  String get onbQ9Opt5;

  /// No description provided for @onbQ9Opt6.
  ///
  /// In en, this message translates to:
  /// **'BBQ'**
  String get onbQ9Opt6;

  /// No description provided for @onbQ9Opt7.
  ///
  /// In en, this message translates to:
  /// **'Stovetop only'**
  String get onbQ9Opt7;

  /// No description provided for @onbQ9Ben1.
  ///
  /// In en, this message translates to:
  /// **'avoid suggesting impossible recipes'**
  String get onbQ9Ben1;

  /// No description provided for @onbQ10.
  ///
  /// In en, this message translates to:
  /// **'How often do you shop?'**
  String get onbQ10;

  /// No description provided for @onbQ10Opt1.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get onbQ10Opt1;

  /// No description provided for @onbQ10Opt2.
  ///
  /// In en, this message translates to:
  /// **'2–3 times/week'**
  String get onbQ10Opt2;

  /// No description provided for @onbQ10Opt3.
  ///
  /// In en, this message translates to:
  /// **'Once a week'**
  String get onbQ10Opt3;

  /// No description provided for @onbQ10Opt4.
  ///
  /// In en, this message translates to:
  /// **'Rarely'**
  String get onbQ10Opt4;

  /// No description provided for @onbQ10Ben1.
  ///
  /// In en, this message translates to:
  /// **'weekly meal plan'**
  String get onbQ10Ben1;

  /// No description provided for @onbQ10Ben2.
  ///
  /// In en, this message translates to:
  /// **'stock management'**
  String get onbQ10Ben2;

  /// No description provided for @onbQ11.
  ///
  /// In en, this message translates to:
  /// **'Want to scan your fridge now?'**
  String get onbQ11;

  /// No description provided for @onbQ11Sub.
  ///
  /// In en, this message translates to:
  /// **'Start the AI magic right away 🔥'**
  String get onbQ11Sub;

  /// No description provided for @onbQ11Opt1.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get onbQ11Opt1;

  /// No description provided for @onbQ11Opt2.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients'**
  String get onbQ11Opt2;

  /// No description provided for @onbQ11Opt3.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get onbQ11Opt3;

  /// No description provided for @onbQ11Ben1.
  ///
  /// In en, this message translates to:
  /// **'start the AI magic right away'**
  String get onbQ11Ben1;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
