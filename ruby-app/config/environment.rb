# frozen_string_literal: true

require 'bundler'
require_relative 'application'

if Application::ENV_NAMES.include?(Application.env)
  Bundler.require(:default, Application.env)
  require 'active_support/core_ext/hash'
else
  Application.logger.error 'Please specify correct environment name.'
  exit
end
