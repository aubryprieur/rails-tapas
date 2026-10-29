# Données de test pour le développement en local.
#
#   bin/rails db:seed
#
# ⚠️ Efface puis recrée tous les utilisateurs, appels d'offres, positionnements,
# commentaires et favoris de la base LOCALE. Ne tourne jamais en production.
#
# Comptes (mot de passe commun : Copas123456)
#   - aubry.prieur@copas.coop  → admin
#   - dalila@example.com, alexandre@example.com, julie@example.com, sophie@example.com → membres

abort("Les seeds ne doivent pas être lancés en production.") if Rails.env.production?

PASSWORD = "Copas123456".freeze
today = Date.current

# Pas d'emails pendant les seeds (sinon un email de bienvenue s'ouvre pour chaque compte)
ActionMailer::Base.perform_deliveries = false

puts "Nettoyage de la base locale…"
[Favorite, Comment, Reading, Call, Like, Team, Rejection].each(&:delete_all)
Post.find_each(&:destroy) # détruit aussi les textes riches et les pièces jointes
User.destroy_all

# --------------------------------------------------------------------------
puts "Création des comptes…"
admin = AdminUser.create!(email: "aubry.prieur@copas.coop", first_name: "Aubry", last_name: "Prieur",
                          password: PASSWORD, password_confirmation: PASSWORD)

members = {
  dalila:    ["Dalila", "Benali"],
  alexandre: ["Alexandre", "Lefebvre"],
  julie:     ["Julie", "Martin"],
  sophie:    ["Sophie", "Moreau"]
}.to_h do |key, (first, last)|
  [key, User.create!(email: "#{key}@example.com", first_name: first, last_name: last,
                     password: PASSWORD, password_confirmation: PASSWORD)]
end
dalila, alexandre, julie, sophie = members.values_at(:dalila, :alexandre, :julie, :sophie)

# --------------------------------------------------------------------------
puts "Création des appels d'offres…"

def rich(*paragraphs, list: nil)
  html = paragraphs.map { |p| "<div>#{p}</div>" }.join("<div><br></div>")
  html += "<ul>#{list.map { |item| "<li>#{item}</li>" }.join}</ul>" if list
  html
end

def ao(client:, title:, deadline:, created: 2.days.ago, body: nil, by:)
  Post.create!(client: client, title: title, deadline: deadline, rich_body: body,
               user: by, created_at: created, updated_at: created)
end

# Échéances proches (rouge) — nouveaux
urgent_today = ao(
  client: "Ville de Roubaix",
  title: "Animation d'une démarche participative pour le budget citoyen 2027",
  deadline: today, created: 1.day.ago, by: admin,
  body: rich("Accompagnement de la Ville dans l'animation du budget participatif : ateliers de quartier, " \
             "plateforme en ligne et vote final.",
             list: ["Durée : 10 mois", "Budget estimé : 45 k€ HT", "Remise des offres à midi"])
)

urgent_tomorrow = ao(
  client: "RIVP",
  title: "Concertation des locataires sur le projet de réhabilitation Saint-Blaise",
  deadline: today + 1, created: 3.days.ago, by: admin,
  body: rich("Mission d'accompagnement des habitants : <strong>diagnostic en marchant</strong>, " \
             "ateliers de concertation et restitution publique.",
             "Visite de site obligatoire, coordonnées du bailleur dans le dossier de consultation.")
)

urgent_3 = ao(
  client: "Communauté d'agglomération de la Porte du Hainaut - Direction de la cohésion sociale et de la politique de la ville",
  title: "Évaluation à mi-parcours du contrat de ville et des programmes de réussite éducative sur l'ensemble des quartiers prioritaires du territoire",
  deadline: today + 3, created: 5.days.ago, by: admin,
  body: rich("Cas de test : client et titre très longs, pour vérifier l'affichage sur mobile.")
)

# Échéances sous 7 jours (orange)
soon_5 = ao(
  client: "Métropole Européenne de Lille",
  title: "Évaluation du Fonds de Solidarité pour le Logement (FSL)",
  deadline: today + 5, created: 12.days.ago, by: admin,
  body: rich("Évaluation qualitative et quantitative du FSL : entretiens avec les ménages, " \
             "analyse des données de gestion et recommandations.")
)

soon_7 = ao(
  client: "Paris Habitat",
  title: "Diagnostic social et urbain de la résidence Belleville",
  deadline: today + 7, created: 20.days.ago, by: admin
  # sans description : cas « Aucune description »
)

# Échéances plus lointaines (vert)
later_15 = ao(
  client: "Département du Nord",
  title: "Accompagnement à la mise en place d'un observatoire de l'habitat indigne",
  deadline: today + 15, created: 2.days.ago, by: admin,
  body: rich("Construction d'indicateurs partagés avec les communes et les CAF.")
)

later_30 = ao(
  client: "Lille Métropole Habitat",
  title: "Enquête de satisfaction des locataires 2027",
  deadline: today + 30, created: 15.days.ago, by: admin,
  body: rich("Enquête téléphonique auprès de 1 500 ménages, analyse et restitution aux équipes de proximité.")
)

next_month = ao(
  client: "Ville de Tourcoing",
  title: "Assistance à maîtrise d'ouvrage pour la maison du projet NPNRU",
  deadline: (today + 1.month).end_of_month, created: 6.days.ago, by: admin,
  body: rich("Conception et animation de la maison du projet du quartier de la Bourgogne.")
)

in_two_months = ao(
  client: "Habitat du Nord",
  title: "Formation des gardiens à l'accueil des publics vulnérables",
  deadline: today + 2.months, created: 30.days.ago, by: admin,
  body: rich("Cycle de 6 sessions d'une journée.")
)

# Échéance dépassée : n'apparaît plus dans la liste, mais grisée dans le calendrier des favoris
past = ao(
  client: "Ville de Lille",
  title: "Évaluation du dispositif « Quartiers d'été »",
  deadline: today - 4, created: 25.days.ago, by: admin,
  body: rich("Cas de test : échéance dépassée.")
)

# --------------------------------------------------------------------------
puts "Positionnements…"
{
  Reading => { urgent_tomorrow => [admin, dalila, alexandre], soon_5 => [admin, julie], urgent_3 => [sophie],
               later_15 => [dalila], next_month => [admin] },
  Call    => { urgent_tomorrow => [dalila], soon_5 => [alexandre] },
  Like    => { urgent_tomorrow => [dalila, alexandre], urgent_today => [admin] },
  Team    => { urgent_tomorrow => [julie], soon_5 => [admin, dalila, sophie] },
  Rejection => { later_30 => [alexandre], soon_7 => [sophie] }
}.each do |model, by_post|
  by_post.each do |post, users|
    users.each { |user| model.create!(post: post, user: user) }
  end
end

# --------------------------------------------------------------------------
puts "Commentaires…"
[
  [urgent_tomorrow, dalila, "On a déjà travaillé avec eux sur Belleville, je peux reprendre la note méthodo.", 2.days.ago],
  [urgent_tomorrow, alexandre, "Je suis dispo pour la visite de site.", 1.day.ago],
  [urgent_tomorrow, julie, "Je m'occupe des pièces administratives : DC1, DC2 et attestations.\nIl me faut vos CV à jour d'ici demain midi.", 3.hours.ago],
  [soon_5, admin, "Gros intérêt pour nous, on en parle à la réunion d'équipe ?", 1.day.ago],
  [urgent_3, sophie, "Le cahier des charges fait 80 pages, je fais une synthèse.", 4.hours.ago]
].each do |post, user, body, at|
  post.comments.create!(body: body, user: user, created_at: at, updated_at: at)
end

# --------------------------------------------------------------------------
puts "Favoris…"
# Favoris de l'admin répartis sur plusieurs mois, pour tester le calendrier
[urgent_today, urgent_tomorrow, soon_5, later_15, next_month, in_two_months, past].each do |post|
  Favorite.create!(favorited: post, user: admin)
end
[urgent_tomorrow, soon_7].each { |post| Favorite.create!(favorited: post, user: dalila) }
# Sophie n'a aucun favori : cas « page vide »

ActionMailer::Base.perform_deliveries = true

puts <<~SUMMARY

  ✅ Seeds terminés
     #{User.count} comptes (mot de passe : #{PASSWORD})
       admin  : aubry.prieur@copas.coop
       membres : dalila@, alexandre@, julie@, sophie@example.com (Sophie n'a aucun favori)
     #{Post.count} appels d'offres (#{Post.where('deadline >= ?', today).count} en cours, #{Post.where('created_at >= ?', 7.days.ago).count} nouveaux)
     #{Comment.count} commentaires, #{Favorite.count} favoris

  Les pièces jointes ne sont pas créées (elles iraient sur Cloudinary) :
  ajoutez-en une à la main sur un AO pour tester le téléchargement.
SUMMARY
