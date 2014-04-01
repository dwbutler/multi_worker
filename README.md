# MultiWorker
[![Build Status](https://travis-ci.org/dwbutler/multi_worker.png?branch=master)](https://travis-ci.org/dwbutler/multi_worker) [![Code Climate](https://codeclimate.com/github/dwbutler/multi_worker.png)](https://codeclimate.com/github/dwbutler/multi_worker)

MultiWorker provides a common interface to the (many) Ruby queueing/worker libraries.
They are all very similar, but provide slightly different interfaces. This makes it difficult
to switch from one library to another, or to use multiple libraries at the same time.

Similar to MultiJSON or ExecJS, MultiWorker automatically detects installed queuing libaries
and the correct adapter is loaded up by default. Changing queueing libraries does not require
any change to worker code, as long as the standard interface is used.

## Installation

Add this line to your application's Gemfile:

    gem 'multi_worker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_worker

## Basic Usage

### Define worker

```ruby
require 'sidekiq'
require 'multi_worker'

class ExampleWorker
  worker

  def perform(foo, bar)
    # long running code
  end
end
```

### Queue jobs

```ruby
ExampleWorker.perform_async(1, 2)
# Equivalent:
MultiWorker.enqueue(ExampleWorker, 1, 2)
```

### Work jobs

Add to Rakefile:
```ruby
require 'resque'
require 'multi_worker/tasks'

# If not using Rails, define your own :environment task that will require dependencies
task :environment do
  require 'resque'
end
```

Run:

```
QUEUE=default rake multi_worker:work
```

## Advanced Configuration

```ruby
MultiWorker.configure do
  default_queue :processing
  default_adapter :resque
  default_options :retry => true
end

class AdvancedWorker
  worker :queue => :background, :unique => true, :adapter => :sidekiq

  def perform(foo)
    ...
  end
end
```

## Feature Comparison

| Library                  | Backends             | Status | Retry | Lock | Unique | Scheduling | Priority | Async Method Proxy | Rake Task | Inline |
|--------------------------|----------------------|--------|-------|------|--------|------------|----------|--------------------|-----------|--------|
| Resque                   | Redis                | Gem    | Gem   | Gem  | Gem    | Gem        |          | Gem                | ✓         | ✓      |
| Sidekiq                  | Redis                | Gem    | ✓     | Gem  | Gem    | ✓          |          | ✓                  | ✗         | ✓      |
| Delayed Job              | Active Record, Mongo |        |       |      |        | ✓          |          | ✓                  | ✓         | ✓      |
| Qu                       | Redis, Mongo, SQS    |        |       |      |        |            |          |                    | ✓         | ✓      |
| Queue Classic            | PostgreSQL           |        |       |      |        |            |          |                    | ✓         | ✗      |
| Que                      | PostgreSQL           |        |       |      |        | ✓          | ✓        |                    | ✓         | ✓      |
| Sneakers                 | RabbitMQ             |        |       |      |        |            |          |                    | ✗         | ✗      |
| TorqueBox Backgroundable | HornetQ              | ✓      |       |      |        |            |          | ✓                  | ✗         | ✗      |
| Backburner               | Beanstalkd           |        | ✓     |      |        | ✓          | ✓        | ✓                  | ✓         | ✓      |
| Threaded in Memory Queue | In-Memory            |        |       |      |        |            |          |                    | N/A       | ✓      |
| Sucker Punch             | In-Memory            |        |       |      |        |            |          |                    | N/A       | ✓      |
| Inline                   | N/A                  |        |       |      |        |            |          |                    | N/A       | ✓      |

## Contributing

1. Fork it ( http://github.com/dwbutler/multi_worker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
