# CrunchLab - Gestionnaire de Stock

## 📋 Description
CrunchLab est un outil de gestion de stock développé spécifiquement pour le "Crunch Time", un événement intensif d'une semaine. L'application permet de suivre en temps réel les emprunts et retours de matériel, facilitant ainsi la gestion logistique de l'événement.

## ✨ Fonctionnalités

### Gestion des Commandes
- Création de commandes avec plusieurs items
- Suivi du statut des emprunts (En cours/Rendu)
- Attribution de techniques spécifiques aux items
- Gestion des quantités par item

### Gestion des Groupes
- Création et modification des groupes
- Association des commandes aux groupes
- Suivi par groupe

### Interface Utilisateur
- Interface responsive et moderne
- Recherche en temps réel
- Tri des colonnes
- Système de filtrage
- Actions rapides (modification, suppression, changement de statut)

## 🛠 Technologies Utilisées
- **Backend** : Flask
- **Frontend** : HTML/CSS, JavaScript vanilla
- **Base de données** : SQLite

## 👥 Utilisation

1. **Page d'accueil** : Vue d'ensemble des commandes avec options de recherche et tri.
2. **Ajout de commande** : Formulaire pour créer une nouvelle commande.
   - Sélection du groupe
   - Ajout d'items multiples
   - Spécification des techniques
3. **Gestion des groupes** : Interface pour gérer les groupes participants.

## 🎯 Objectif
Cet outil a été développé pour optimiser la gestion du matériel pendant le Crunch Time, permettant un suivi précis et en temps réel des emprunts, facilitant ainsi le travail des organisateurs et assurant une meilleure expérience pour les participants.

## 📝 Licence
Ce projet est sous licence MIT. Toute utilisation à des fins commerciales ou associatives n'est pas permise sans l'aval du créateur et détenteur.

## ⏳ Contexte de Développement
Il est important de noter que CrunchLab a été développé dans des délais très courts. Les premiers jours ont permis de poser les bases du projet, mais à partir de mardi, la charge de travail s'est considérablement intensifiée, rendant impossible la gestion simultanée du développement et de l'assistance aux utilisateurs. L'implémentation du système de connexion, une nécessité pour prévenir des problèmes potentiels, a pris plus de temps que prévu. Certaines fonctionnalités ont dû être intégrées dans l'urgence, et bien qu'elles aient été testées et vérifiées, leur implémentation a été réalisée sous pression. En raison de ces contraintes, aucune optimisation n'a pu être réalisée, que ce soit au niveau des tables de la base de données, du chargement des images, de la gestion des temps de session de connexion, ou d'autres aspects.