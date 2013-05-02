  require 'wordnet'
  raw_config = File.read(Rails.root + "config/t2seederconfig.yml")
  APP_CONFIG = YAML.load(raw_config)[Rails.env]

  # For developing aspects of the seeder, the following is convenient. 
  # It is a call to an entry point of T2Seeder

  unless Rails.env=="production"
  # Load t2Seeder.rb file
   load Rails.root+"app/developer.rb"
  # Include the module named T2seeder, found inside t2Seeder.rb
    include Developer  
  end
