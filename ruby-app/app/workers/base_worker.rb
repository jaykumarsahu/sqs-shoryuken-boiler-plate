# frozen_string_literal: true

class BaseWorker
  include Shoryuken::Worker

  attr_reader :params

  def perform(sqs_msg, params)
    sqs_msg.delete
    @params = parse_params(params)
    begin
      run
    rescue StandardError => e
      # log errors
      raise e
    end
  end

  private

  def parse_params(params)
    JSON.parse(params).with_indifferent_access
  rescue StandardError
    # {}
    params
  end
end
