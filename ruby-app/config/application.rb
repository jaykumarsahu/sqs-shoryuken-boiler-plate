# frozen_string_literal: true

require 'active_support'
require 'logging'

class Application
  ENV_NAMES = %w[
    development production uat staging
  ].freeze
  class << self
    def env
      @env ||= ActiveSupport::StringInquirer.new(ENV['CURRENT_ENV'].to_s.downcase)
    end

    def root
      @root ||= Pathname.new(Dir.pwd)
    end

    def logger
      return @logger unless @logger.nil?

      level = env.development? ? :debug : :info
      @logger = build_logger('Shoryuken App', level)
    end

    def shoryuken_logger
      return @shoryuken_logger unless @shoryuken_logger.nil?

      @shoryuken_logger = build_logger('Shoryuken internal', :info)
    end

    private

    def build_logger(logger_name, log_level)
      logger = Logging.logger.new(logger_name)
      logger.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file(root.join('log', "#{ENV['CURRENT_ENV']}.log"))
      )
      logger.level = log_level
      logger
    end
  end
end
