# 🎯 QUICK START: Using Your New i18n System

## ✅ Setup Complete - Start Using Immediately!

---

## 📝 Step-by-Step Guide to Localize Your Pages

### 1️⃣ Import the Localization Package

At the top of any page file:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### 2️⃣ Get the Localization Instance

In your `build()` method:

```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  // Now use l10n for all text
}
```

### 3️⃣ Replace All Hardcoded Strings

**Before:**
```dart
Text("Home")
Text("Recipes")  
Text("My Smart Fridge")
```

**After:**
```dart
Text(l10n.home)
Text(l10n.recipes)
Text(l10n.mySmartFridge)
```

---

## 🎨 Adding the Language Switcher

### In Settings Page

```dart
import 'package:flutter/material.dart';
import '../shared/widgets/language_switcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Add this:
          const LanguageSwitcher(
            style: LanguageSwitcherStyle.tile,
          ),
          
          // Other settings...
        ],
      ),
    );
  }
}
```

### In AppBar (Top Right)

```dart
AppBar(
  title: Text('My App'),
  actions: [
    const LanguageSwitcher(
      style: LanguageSwitcherStyle.iconButton,
    ),
  ],
)
```

### Quick Toggle Button

```dart
import '../shared/widgets/language_switcher.dart';

// Somewhere in your UI:
const QuickLanguageToggle()
```

---

## 📚 Available Translations (350+ Keys!)

### Common Usage

```dart
// Navigation
l10n.home
l10n.recipes
l10n.fridge
l10n.tracking
l10n.profile
l10n.settings

// Greetings
l10n.greeting              // "Hello" / "Bonjour"
l10n.goodMorning          // "Good Morning" / "Bonjour"
l10n.goodAfternoon        // "Good Afternoon" / "Bon Après-midi"
l10n.goodEvening          // "Good Evening" / "Bonsoir"

// Actions
l10n.save
l10n.cancel
l10n.edit
l10n.delete
l10n.confirm
l10n.close

// Time
l10n.today
l10n.yesterday
l10n.tomorrow
l10n.thisWeek
l10n.thisMonth

// Days
l10n.monday
l10n.tuesday
// ... etc
l10n.mondayShort          // "Mon" / "Lun"
l10n.tuesdayShort         // "Tue" / "Mar"
// ... etc

// Months
l10n.january
l10n.february
// ... etc

// Nutrition
l10n.dailyNutrition
l10n.caloriesRemaining
l10n.proteins
l10n.carbs
l10n.fats
l10n.kcalUnit             // "kcal"
l10n.gramsUnit            // "g"

// Quick Actions
l10n.quickActions
l10n.scanFood
l10n.addMeal
l10n.logWater
l10n.myFridge

// Recipes
l10n.recommendedForYou
l10n.popularRecipes
l10n.breakfast
l10n.lunch
l10n.dinner
l10n.minutes              // "min"
l10n.cook
l10n.viewRecipe

// Fridge
l10n.mySmartFridge
l10n.addItem
l10n.addIngredient
l10n.scanBarcode
l10n.addManually
l10n.productName
l10n.quantity
l10n.expiresIn
l10n.category
l10n.topShelf
l10n.middleShelf
l10n.bottomShelf
l10n.door
l10n.fruits
l10n.vegetables
l10n.dairy
l10n.meat
l10n.beverages

// Tracking
l10n.statistics
l10n.water
l10n.activity
l10n.progress
l10n.weeklySummary
l10n.healthScore

// Chatbot
l10n.chatbot
l10n.aiAssistant
l10n.askMeAnything
l10n.needIdeas

// Errors & Messages
l10n.error
l10n.success
l10n.loading
l10n.noData
l10n.tryAgain

// And 250+ more!
```

### With Pluralization

```dart
l10n.itemsCount(0)        // "No items" / "Aucun article"
l10n.itemsCount(1)        // "1 item" / "1 article"
l10n.itemsCount(5)        // "5 items" / "5 articles"

l10n.expiringDays(0)      // "Expires today" / "Expire aujourd'hui"
l10n.expiringDays(1)      // "Expires in 1 day" / "Expire dans 1 jour"
l10n.expiringDays(3)      // "Expires in 3 days" / "Expire dans 3 jours"
```

---

## 🔄 Testing Language Switching

### Run Your App

```bash
flutter run
```

### Test Scenarios

1. **Initial Launch** - Should auto-detect your device language
2. **Switch Language** - Tap language button, select different language
3. **Instant Update** - UI should update immediately (no restart!)
4. **Persistence** - Close app, reopen - language should be remembered
5. **All Screens** - Navigate to different screens - all should be translated

---

## 🚀 Migration Checklist for Your Pages

### For Each Page:

- [ ] Add import: `import 'package:flutter_gen/gen_l10n/app_localizations.dart';`
- [ ] Get l10n instance: `final l10n = AppLocalizations.of(context)!;`
- [ ] Replace `Text("Hardcoded")` with `Text(l10n.keyName)`
- [ ] Replace button labels
- [ ] Replace AppBar titles
- [ ] Replace dialog messages
- [ ] Replace input hints
- [ ] Replace error messages
- [ ] Test in both languages

### Example Migration

**Before:**
```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      body: Column(
        children: [
          Text("Popular Recipes"),
          ElevatedButton(
            onPressed: () {},
            child: Text("View All"),
          ),
        ],
      ),
    );
  }
}
```

**After:**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;  // ← Add this
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recipes),  // ← Changed
      ),
      body: Column(
        children: [
          Text(l10n.popularRecipes),  // ← Changed
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.viewAll),  // ← Changed
          ),
        ],
      ),
    );
  }
}
```

---

## ➕ Adding New Translations

When you need a translation that doesn't exist:

### 1. Add to English ARB

`lib/l10n/app_en.arb`:
```json
{
  "myNewText": "My New Text",
  "@myNewText": {
    "description": "Description of what this is for"
  }
}
```

### 2. Add to French ARB

`lib/l10n/app_fr.arb`:
```json
{
  "myNewText": "Mon Nouveau Texte"
}
```

### 3. Regenerate

```bash
flutter pub get
```

### 4. Use It

```dart
Text(l10n.myNewText)
```

---

## 🎯 Pro Tips

### ✅ DO

- Use l10n for **ALL** user-facing text
- Use descriptive key names (`mySmartFridge` not `text1`)
- Add descriptions in ARB files
- Test both languages regularly
- Use pluralization for counts
- Regenerate after ARB changes

### ❌ DON'T

- Hardcode text anywhere
- Forget to import AppLocalizations
- Skip regeneration after ARB changes
- Use unclear key names
- Concatenate strings (use parameters instead)

---

## 🛠️ Useful Commands

```bash
# Install/update dependencies
flutter pub get

# Generate localizations
flutter gen-l10n

# Clean and rebuild
flutter clean
flutter pub get

# Run app
flutter run

# Check for package updates
flutter pub outdated
```

---

## 🔍 Finding Translation Keys

All translation keys are in:
- `lib/l10n/app_en.arb` (English - search here!)
- `lib/l10n/app_fr.arb` (French)

Use your IDE's search (Ctrl+F / Cmd+F) to find keys by English text.

Example: Search for "Smart Fridge" → find `"mySmartFridge"` key

---

## 📱 Example: Fully Localized Home Page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../shared/widgets/language_switcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          const QuickLanguageToggle(),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.goodMorning,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(l10n.today),
            const SizedBox(height: 24),
            
            // Nutrition Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyNutrition,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('${l10n.caloriesRemaining}: 1,500 ${l10n.kcalUnit}'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MacroCard(l10n.proteins, '45', l10n.gramsUnit),
                        _MacroCard(l10n.carbs, '120', l10n.gramsUnit),
                        _MacroCard(l10n.fats, '35', l10n.gramsUnit),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              l10n.quickActions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    label: l10n.scanFood,
                    icon: Icons.qr_code_scanner,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionCard(
                    label: l10n.addMeal,
                    icon: Icons.restaurant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Recipes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recommendedForYou,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _MacroCard(this.label, this.value, this.unit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value$unit',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(label),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const ActionCard({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🎉 You're Ready!

Your i18n system is **fully set up and ready to use**!

Start by:
1. ✅ Adding the language switcher to your settings page
2. ✅ Converting one page to use l10n
3. ✅ Testing the language switching
4. ✅ Gradually migrating all pages

**Need help?** Check:
- `INTERNATIONALIZATION_GUIDE.md` - Complete documentation
- `I18N_IMPLEMENTATION_COMPLETE.md` - Implementation summary
- `lib/core/examples/localized_page_examples.dart` - Working examples

**Happy coding! 🚀**
