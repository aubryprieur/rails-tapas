source "https://rubygems.org"

ruby "~> 3.4.0"

gem "rails", "~> 8.1.0"
gem "pg", "~> 1.5"
gem "puma", ">= 6.0"
gem "bootsnap", require: false

# Assets : Propshaft + esbuild (JS) + Dart Sass (CSS)
gem "propshaft"
gem "jsbundling-rails"
gem "cssbundling-rails"

gem "jbuilder"
gem "devise", "~> 5.0"
gem "cloudinary", "~> 2.2"
gem "simple_form"
gem "administrate", "~> 1.0"
gem "pundit", "~> 2.1"
gem "sendgrid-ruby"
gem "postmark-rails"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 8.0"
end

group :development do
  gem "web-console"
  gem "letter_opener"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]
