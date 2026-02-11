# Onboarding Feature

Ce dossier contient le système d'onboarding pour l'application MEATAY.

## Structure

```
onboarding/
├── data/
│   └── models/
│       ├── onboarding_question.dart  # Modèle de données pour les questions
│       └── onboarding_data.dart      # Modèle pour stocker les réponses
└── presentation/
    ├── screens/
    │   └── onboarding_screen.dart    # Écran principal d'onboarding
    └── widgets/
        ├── question_card.dart        # Widget de carte de question
        └── option_button.dart        # Bouton d'option de réponse
```

## Fonctionnalités

### Questions d'Onboarding (11 questions)

1. **Pour combien de personnes tu cuisines ?**
   - Options: Juste moi, 2 personnes, 3–4, 5+
   - Utilité: Ajuster les portions et la liste de courses

2. **Tu cuisines combien de fois par semaine ?**
   - Options: Jamais, 1–2 fois, 3–5 fois, Tous les jours
   - Utilité: Fréquence des recommandations, meal plan

3. **Combien de temps max pour un repas ?**
   - Options: 10 min, 20 min, 30 min, Peu importe
   - Utilité: Filtrage des recettes par durée

4. **Ton niveau en cuisine ?**
   - Options: Débutant, Intermédiaire, Avancé
   - Utilité: Adapter la difficulté des recettes

5. **Tes préférences alimentaires ?** (multi-select)
   - Options: Omnivore, Végétarien, Vegan, Halal, Sans porc, Sans lactose, Sans gluten, Keto
   - Utilité: Filtrage automatique des recettes

6. **Allergies ou aliments interdits ?** (multi-select avec input texte)
   - Options: Arachides, Fruits de mer, Lait, Œufs, Autre, Aucune
   - Utilité: Sécurité alimentaire et crédibilité

7. **Tu préfères quel type de plats ?** (multi-select)
   - Options: Rapide/simple, Healthy, Protéiné, Pas cher, Gourmand, Cuisine du monde, Traditionnel
   - Utilité: Personnalisation des recommandations

8. **Budget nourriture ?**
   - Options: Petit budget, Normal, Premium
   - Utilité: Choix des ingrédients

9. **Quels équipements tu as ?** (multi-select)
   - Options: Four, Micro-ondes, Air fryer, Mixeur, Robot cuisine, BBQ, Plaques seulement
   - Utilité: Éviter de proposer des recettes impossibles

10. **Tu fais les courses combien de fois ?**
    - Options: Tous les jours, 2–3 fois/semaine, 1 fois/semaine, Rarement
    - Utilité: Gestion du meal plan et stock

11. **Veux-tu scanner ton frigo maintenant ?**
    - Options: Scanner avec caméra, Ajouter ingrédients, Plus tard
    - Utilité: Démarrer la magie IA

## Système de Navigation

L'onboarding utilise un système de cards avec:
- **Barre de progression** en haut de l'écran
- **PageView** pour la navigation fluide entre les questions
- **Bouton "Continuer"** pour passer à la question suivante
- **Bouton retour** pour revenir à la question précédente
- **Option "Passer"** pour ignorer l'onboarding

## Flux d'Utilisation

1. L'utilisateur arrive sur le WelcomeScreen
2. Clique sur "Get Started" 
3. Choisit Google ou Apple pour s'inscrire
4. Redirigé vers OnboardingScreen
5. Répond aux 11 questions une par une
6. Les réponses sont stockées
7. Redirigé vers le Dashboard

## Personnalisation

### Modifier une question
Éditez le tableau `_questions` dans [onboarding_screen.dart](presentation/screens/onboarding_screen.dart)

### Ajouter une question
```dart
OnboardingQuestion(
  id: 12,
  question: 'Votre question ?',
  subtitle: 'Description optionnelle',
  options: ['Option 1', 'Option 2'],
  multiSelect: false, // true pour sélection multiple
  hasTextInput: false, // true pour input texte
),
```

### Sauvegarder les réponses
Les réponses sont stockées dans `_answers` (Map<int, List<String>>)
Utilisez `OnboardingData` pour convertir et sauvegarder:

```dart
final onboardingData = OnboardingData(
  answers: _answers,
  completedAt: DateTime.now(),
);
// Sauvegarder avec SharedPreferences ou autre
```

## Style & Design

- **Couleurs**: Noir (#111111), Vert (#22C55E), Blanc, Gris (#7A7A7A)
- **Police**: Google Fonts Inter
- **Animations**: Transitions fluides de 300ms
- **Cards**: Border radius 12px, padding 24px
- **Boutons**: Style minimaliste avec état sélectionné

## À Implémenter

- [ ] Sauvegarde persistante des réponses (SharedPreferences/Hive)
- [ ] Intégration avec l'authentification Google/Apple
- [ ] Analytics pour tracking des réponses
- [ ] Système de validation avancé
- [ ] Animation de transition vers le Dashboard
- [ ] Récupération des réponses en cas de sortie
