# frozen_string_literal: true

attrs = if Application.env.development?
          {
            endpoint: ENV['SQS_ENDPOINT'],
            region: ENV['AWS_REGION']
          }
        else
          {
            access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
            region: ENV['AWS_REGION']
          }
        end

Shoryuken.configure_server do |config|
  config.sqs_client = Aws::SQS::Client.new(**attrs)

  config.options[:queues].each do |queue_name|
    config.sqs_client.create_queue(
      queue_name: queue_name,
      attributes: {
        Policy: {
          "Version": '2012-10-17',
          "Statement": [
            {
              "Action": ['sqs:*'],
              "Effect": 'Allow',
              "Resource": '*'
            }
          ]
        }.to_json
      }
    )
  end

  Shoryuken::Logging.logger = Application.shoryuken_logger
end

module Shoryuken
  module Middleware
    module Server
      class Timing
        include Util

        # Override method to log worker name.
        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def call(worker, queue, sqs_msg, _body)
          msg_prefix = "#{worker.class}:#{sqs_msg.message_id} => "
          started_at = Time.now.utc
          logger.info { msg_prefix + "started at #{started_at}" }
          yield

          total_time = elapsed(started_at)
          if (total_time / 1000.0) > (timeout = Shoryuken::Client.queues(queue).visibility_timeout)
            logger.warn { msg_prefix + "exceeded the queue visibility timeout by #{total_time - (timeout * 1000)} ms" }
          end

          logger.info { msg_prefix + "completed in: #{total_time} ms" }
        rescue StandardError => e
          logger.info { msg_prefix + "failed in: #{elapsed(started_at)} ms" }
          raise e
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
