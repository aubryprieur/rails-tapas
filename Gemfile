source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Ajoutez ou mettez à jour
gem 'rails', '~> 6.1.0'
gem 'webpacker', '~> 5.0'
gem 'psych', '~> 4.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '~> 6.0'
gem 'bootstrap', '~> 5.2', '>= 5.2.3'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'cloudinary'
gem 'bootsnap', '~> 1.18', '>= 1.18.4'
gem 'autoprefixer-rails'
gem 'font-awesome-sass', '~> 4.6', '>= 4.6.2'
gem 'simple_form'
gem "administrate"
gem 'pundit', '~> 2.1'
gem "letter_opener", :group => :development
gem 'sendgrid-ruby'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'database_cleaner', '~> 1.8', '>= 1.8.5'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rspec-rails', '~> 6.1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
