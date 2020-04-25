# frozen_string_literal: true

class TestWorker < BaseWorker
  shoryuken_options queue: "#{Application.env}_test", auto_delete: true

  def run
    return if params.blank?

    Application.logger.info('============Test Msg Params=================')
    Application.logger.info(params)
    Application.logger.info('============================================')
  end
end
