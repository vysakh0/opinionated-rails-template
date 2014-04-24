def source_paths
    [File.expand_path(File.dirname(__FILE__))]
end
gsub_file "Gemfile", /.*sqlite3.*/, ""
gem 'devise'
gem_group :development, :test do
    gem 'factory_girl_rails'
    gem 'rspec-rails', '~> 3.0.0.beta'
    gem 'simplecov'
    gem 'rspec', '~> 3.0.0.beta2'
    gem 'sqlite3'
    gem 'faker'
    gem 'letter_opener'
    gem 'capistrano', '3.1'
    gem 'capistrano-bundler'
    gem 'capistrano-rails'
    gem 'capistrano3-unicorn'
end
gem_group :production do
  gem 'pg'
  gem 'unicorn'
end
gem_group :test do
  gem 'database_cleaner'
  gem "shoulda-matchers"
  gem "shoulda-callback-matchers", ">=0.3.2"
end
gem "active_model_serializers"
gem 'foundation-rails', '~> 5.1.1'
gsub_file "Gemfile", /.*coffee-rails.*/, ""
gsub_file "Gemfile", /.*jbuilder.*/, ""
gsub_file "Gemfile", /.*turbolinks.*/, ""

gsub_file "app/assets/javascripts/application.js", /.*turbolinks.*/, ""

run "bundle install --local"

run "rm README.rdoc"
copy_file "gen-README.md",  "README.md"

run "rm -rf test"
generate 'rspec:install'

environment <<-FILE
  config.generators do |g|
    g.helpers false
    g.javascripts false
    g.stylesheets false
  end
FILE

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

# home file

generate :controller, "home"
route "root 'home#index'"
route "get '*foo', to:'static_pages#index'"
create_file "app/views/home/index.html", ""

git add: "."
git commit: %Q{ -m 'Create a home controller with index action that handles all actions' }

# using devise user

generate 'devise:install'
generate :devise, "User"
copy_file "gen-controller.rb",  "app/controllers/api/v1/users_controller.rb"
inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-'RUBY'

  namespace :api do
    namespace :v1 do
      resources :users do
        get 'current', on: :collection
      end
    end
  end
  RUBY
end

git add: "."
git commit: %Q{ -m 'Create user resource using devise' }

# sessions
#
copy_file "gen-session.rb",  "app/controllers/api/v1/sessions_controller.rb"
inject_into_file 'config/routes.rb', after: "namespace :v1 do\n" do <<-'RUBY'

  namespace :api do
    namespace :v1 do
      resources :users do
        get 'current', on: :collection
      end
    end
  end
  RUBY
end

gsub_file "app/models/user.rb", /.*devise.*/, ""
gsub_file "app/models/user.rb", /.*:recoverable.*/, ""

inject_into_class 'app/models/user.rb', 'User' do <<-'RUBY'
  devise :database_authenticatable, :registerable, :confirmable,
  :recoverable, :rememberable, :trackable, :validatable

  def send_on_create_confirmation_instructions
    #send_devise_notification(:confirmation_instructions)
  end

  def generate_token_for(token_type)
    self.class.verifier("User-#{token_type}").generate([id, Time.now])
  end

  def self.find_token_by(token_type, token)
    user_id, timestamp = verifier("User-#{token_type}").verify(token)
    case token_type
    when "oauth_token"
      raise "Token expired" if timestamp < 10.days.ago
    when "password_reset"
      raise "Token expired" if timestamp < 1.day.ago
    end
    User.find(user_id)
  end


  def self.verifier(sign)
    Rails.application.message_verifier(sign)
  end
  RUBY
end

git add: "."
git commit: %Q{ -m 'Create sessions controller, password related logics' }


run 'bundle exec cap install'

copy_file "production.rb",  "config/environments/staging.rb"

staging_site = ask("What is your staging site url?")
app_name     = ask("What is your app name?")
environment "config.action_mailer.default_url_options = {host: '#{staging_site}'}", env: 'staging'
environment "config.action_mailer.delivery_method = :smtp", env: 'staging'

environment "config.action_mailer.default_url_options = {host: '#{staging_site}'}", env: 'production'
environment "config.action_mailer.delivery_method = :smtp", env: 'production'
environment "config.action_mailer.default_url_options = {host: 'http://localhost:3000'}", env: 'development'
environment "config.action_mailer.delivery_method = :letter_opener", env: 'development'

template "gen-nginx.erb", "config/nginx.conf" , { app_name: app_name, staging_site: staging_site}
template "gen-unicorn.erb", "config/unicorn/staging.rb" , { app_name: app_name, staging_site: staging_site}

run "rm config/deploy/staging.rb"
template "gen-staging.erb", "config/deploy/staging.rb" , { app_name: app_name, staging_site: staging_site}

repo_user_name = ask("What is your repo user name?")
repo_name = ask("What is your repo name?")
run "rm config/deploy.rb"
template "gen-deploy.erb", "config/deploy.rb" , { app_name:       app_name,
                                                      staging_site:   staging_site,
                                                      repo_name:      repo_name,
                                                      repo_user_name: repo_user_name
                                                    }

db_name = ask("What is your db name?")
user_name = ask("What is your db user name?")
password = ask("What is your db password?")
template "gen-database.erb", "config/database.example.yml" , {db_name: db_name, user_name: user_name, password: password}

git add: "."
git commit: %Q{ -m 'Set capistrano, unicorn, nginx configs' }
