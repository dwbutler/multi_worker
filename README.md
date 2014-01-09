# MultiWorker

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

```ruby
require 'sidekiq'
require 'multi_worker'

class ExampleWorker
  worker

  def perform(foo, bar)
    # long running code
  end
end

ExampleWorker.perform_async(1, 2)
MultiWorker.enqueue(ExampleWorker, 1, 2)
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

| Library                  | Backends             | Status   | Retry    | Lock | Unique | Delayed  | Inline |
|--------------------------|----------------------|----------|----------|------|--------|----------|--------|
| Resque                   | Redis                | Gem      | Gem      | Gem  | Gem    | Gem      | ✓      |
| Sidekiq                  | Redis                | Gem      | Built in | Gem  | Gem    | Built in | ✓      |
| Delayed Job              | Active Record, Mongo |          |          |      |        | Built in | ✓      |
| Qu                       | Redis, Mongo, SQS    |          |          |      |        |          | ✓      |
| Queue Classic            | PostgreSQL           |          |          |      |        |          | X      |
| Sneakers                 | RabbitMQ             |          |          |      |        |          | X      |
| TorqueBox Backgroundable | HornetQ              | Built in |          |      |        | Built in | X      |
| Threaded in Memory Queue | N/A                  |          |          |      |        |          | ✓      |
| Inline                   | N/A                  |          |          |      |        |          | ✓      |

## Contributing

1. Fork it ( http://github.com/<my-github-username>/multi_worker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
