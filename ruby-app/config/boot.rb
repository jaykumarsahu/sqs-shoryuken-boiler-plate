# frozen_string_literal: true

require 'erb'
require_relative 'environment'

# Load db config and establish connection
db_config = ERB.new(File.read('config/database.yml')).result
db_config = YAML.safe_load(db_config, [], [], true)
db_config = db_config.with_indifferent_access[ENV['CURRENT_ENV']]
ActiveRecord::Base.establish_connection(**db_config)

# Setup logger for activerecord
ActiveRecord::Base.logger = Application.logger

['config/initializers', 'app/workers'].each do |dir_name|
  Dir[File.expand_path(Application.root.join("#{dir_name}/*.rb"))].sort.each do |file|
    require file
  end
end

CODE_LOADER = Zeitwerk::Loader.new
CODE_LOADER.push_dir(Application.root.join('app/models'))
CODE_LOADER.enable_reloading if Application.env.development?
CODE_LOADER.setup
