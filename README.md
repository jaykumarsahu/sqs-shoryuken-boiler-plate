## Installation

1. Install [Docker](https://www.docker.com/)
1. Install [Docker Compose](https://docs.docker.com/compose/install/)
1. Create a file `config/database.yml`. Please check the file `config/database.yml.example.yml` for reference.
1. Create a file `.env`. Please check the file `.env.example` for reference.

## Usage

1.  `make build` to launch the application for the first time
1.  `make start` to launch the application
1.  `make down` to bring down all docker containers
1.  `make console` command lets you interact with your application from the command line. On the underside, application console uses [Pry](https://github.com/pry/pry), so if you've ever used it, you'll be right at home. This is useful for testing out quick ideas with code and changing the data server-side.

## Broadcast message using AWS CLI

```
aws --endpoint-url http://localhost:9324 sqs send-message --queue-url http://localhost:9324/queue/development_test --message-body "Hello SQS"
```

## Notes
1. Please explore [SQS](https://aws.amazon.com/sqs/) for better understanding of the application.
1. To process SQS message, We are using [Shoryuken](https://github.com/phstc/shoryuken) gem which is a Amazon SQS thread-based message processor.
1. To add/update queues, Please check the file `config/shoryuken.yml`.
