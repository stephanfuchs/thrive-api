source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# CORE: RAILS
# INFO: (Stephan) See https://blog.sundaycoding.com/blog/2016/08/10/how-to-remove-action-cable-from-a-rails-app/
gem 'activerecord', '~> 7.0.0'
gem 'activemodel', '~> 7.0.0'
gem 'actionpack', '~> 7.0.0'
gem 'activesupport', '~> 7.0.0'
gem 'railties', '~> 7.0.0'

# CORE: CONFIG/ENV
gem 'dotenv-rails'

# CORE: DB
gem "redis", "~> 4.0"
gem 'mysql2'
gem 'pg'

# ELASTIC SEARCH
gem 'searchkick'
gem 'elasticsearch'
gem 'typhoeus' # https://github.com/ankane/searchkick#persistent-http-connections

# ASYNC JOBS
gem 'sidekiq'
# gem "sidekiq-cron"
# gem 'whenever', require: false
gem "activejob", require: "active_job"

# VIEW PROVIDERS
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
gem 'oj'
gem 'blueprinter'

# MIDDLEWARE
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'rack-proxy'

# DEPLOYMENT PROVIDERS
gem 'capistrano',         require: false
gem 'capistrano-rbenv',   require: false
gem 'capistrano-rails',   require: false
gem 'capistrano-bundler', require: false
gem 'capistrano-sidekiq', require: false
gem 'capistrano3-puma',   require: false

# WEB SERVER [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# API QUERY LANGUAGE
gem "graphql"

# OTHER
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'


# authentication & authorization
gem 'jwt'
gem 'pundit'

# Reduces boot times through caching; required in config/boot.rb
gem 'net-smtp'

# CORE: DATA STRUCTURES
gem 'paranoia', '~> 2.4' # soft delete
gem 'paper_trail' # track model changes
gem 'will_paginate' # pagination

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'rails', '~> 7.0.0'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "graphiql-rails"
  gem 'sprockets-rails'
end

group :development do
  gem 'bootsnap', '>= 1.4.4', require: false
  gem 'listen', '~> 3.3' # TODO: (Stephan) check the purpose of this
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'awesome_print'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'capistrano-rails-console'
  gem 'aws-sdk-ec2'
  gem 'aws-sdk-autoscaling'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
