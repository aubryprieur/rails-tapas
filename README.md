# TAPAS

Application Rails de partage et de suivi des appels d'offres.

## Versions

- Ruby 3.4
- Rails 8.1
- PostgreSQL (Heroku Postgres 18)
- Node 22 + Yarn 1 (esbuild pour le JavaScript, Dart Sass pour le CSS)

## Installation en local

```bash
bundle install
yarn install
bin/rails db:prepare
```

## Lancer l'application

```bash
bin/dev
```

`bin/dev` démarre le serveur Rails ainsi que la compilation du JavaScript et du CSS
en mode « watch » (voir `Procfile.dev`). L'application est sur http://localhost:3000.

## Tests

```bash
bundle exec rspec
```

## Déploiement

L'application est déployée sur Heroku (`rails-tapas`). Les migrations sont lancées
automatiquement à chaque déploiement (phase `release` du `Procfile`).
