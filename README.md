# 🐳 Dockit

Outil en ligne de commande pour initialiser des environnements de développement (PrestaShop, WordPress, Symfony) avec Docker.

## 🚀 Installation

```bash
git clone https://github.com/ton-user/dockit.git
cd dockit
./install.sh

# 📘 Dockit - Documentation & Démo d'utilisation

`dockit` est un outil shell interactif pour générer rapidement des environnements de développement locaux prêts à l'emploi pour **PrestaShop**, et bientôt **Symfony** et **WordPress**.

Il vous guide étape par étape, génère un `.env`, un `docker-compose.yml`, les dossiers, installe PrestaShop et configure votre stack personnalisée.

---

## 🚀 Lancement rapide

```bash
./bin/prestashop-env
```

Vous serez guidé étape par étape :

1. 📝 Nom du projet
2. 📂 Emplacement cible (par défaut `/var/www`)
3. 🔢 Version de PrestaShop (sélection via `fzf`)
4. 🧱 Stack technique déduite automatiquement (PHP, MariaDB, Node)
5. 🔌 Ports détectés automatiquement
6. 🧩 Sélection interactive des extensions PHP à installer
7. 🔧 Génération du `.env`
8. 🧬 Génération du `docker-compose.yml`
9. 📥 Téléchargement de PrestaShop (optionnel)
10. 🧨 Instructions pour démarrer

---

## 🧪 Exemple complet d'utilisation

```bash
$ ./bin/prestashop-env
🚀 Welcome to the PrestaShop environment setup!

📝 Enter project name (letters, dashes, underscores, dots): myshop
📁 Où souhaitez-vous créer le projet ? [/var/www] : [Entrée]
📂 Répertoire du projet : /var/www/myshop

🧩 Sélectionnez la version PrestaShop :
  1.7.8.11
  8.0.5
  8.1.5
  9.0.0-alpha.1
✅ Selected PrestaShop version: 8.1.5

🧩 Stack recommandée → PHP: 8.1, MariaDB: 10.6, Node: 18
📍 Port de base (ex: 10000) [10000] : 11000

🧠 Ports assignés :
   🌐 HTTP         : 11000
   🔐 HTTPS        : 11001
   🛢️ PhpMyAdmin   : 11002
   📬 Mailpit      : 11003
   🐬 MySQL        : 11004

🧩 Extensions PHP à inclure : [fzf multi-select]
✅ .env mis à jour avec : PHP_EXTENSIONS="pdo pdo_mysql intl zip gd opcache"

✅ Fichier .env généré
✅ docker-compose.yml généré avec envsubst
📥 Souhaitez-vous télécharger PrestaShop 8.1.5 ? (y/N) : y
⏬ Téléchargement depuis https://github.com/PrestaShop/PrestaShop/...zip
✅ PrestaShop extrait.

🚀 Lancez maintenant :
cd /var/www/myshop && docker compose up -d
```

---

## 📦 Arborescence générée

```
/var/www/myshop
├── .env
├── docker-compose.yml
├── prestashop/
├── data/
├── logs/
└── config/
```

---

## 🔧 Commandes utiles

```bash
make install         # Composer install dans le conteneur PHP
make blackfire-on    # Active Blackfire
make blackfire-off   # Désactive Blackfire
make rebuild         # Rebuild propre du projet
```

---

## ✨ À venir

- Support Symfony / WordPress
- `dockit list`, `dockit stop`, `dockit clean`
- Setup multi-domaine, reverse-proxy
- Génération automatique de certificats SSL locaux

---

## 🙌 Auteur

**Noël aka `nono-pxbsd`**
> Créateur de `dockit`, expert PrestaShop, artisan de l'efficacité DevOps ⚙️
