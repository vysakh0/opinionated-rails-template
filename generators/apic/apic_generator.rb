class ApicGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def copy_controller_file
    template "controller.rb", "app/controllers/api/v1/#{file_name}_controller.rb"
  end
  def inject_route
    inject_into_file 'config/routes.rb', after: "namespace :v1 do\n" do <<-RUBY
        resources :#{file_name}
      RUBY
    end
  end
  def model_name
   class_name.singularize
  end
end
