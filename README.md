PredictionIO
============

[![Build Status](https://secure.travis-ci.org/acnalesso/prediction_io.png?branch=master)](http://travis-ci.org/acnalesso/prediction_io)

PredictionIO is an open source machine learning server for software developers to create predictive features,
such as personalization, recommendation and content discovery.

-------------------------------------------------------------------------------------------------------------

How to install?
---------------
Add this to your Gemfile

    gem 'prediction_io'

Install with Bundler

    bundle install

Install with gem install

    gem install prediction_io

---------------------------------------------------------------------------------------------------------------

Configurations have to be pre-defined in config/prediction_io.yml
 Such as:

    user:
      username: batman
      password: secret

    api:
      appkey: my_supersecret_key
      host: http://localhost:3000
      timeout: 5
      proxy: null
      pool: 5

Bear in mind:
-------------

PredictionIO::Worker is responsible for 'getting the job done' whenenver you make
a request. ( e.g aget(1), acreate(1) )
It is also smart enough to call a fallback when an exception is encoutered, therefore,
Whenever a exception is raised it will call a fallback which will return an instance of
OpenStruct object with two methods defined:
* notice -> What the exception raised has returned.
* worker -> The worker assigned to that particular job.

The catch here is, if you call a method that an instance of OpenStruct does not respond to
it will return nil, this prevents other exceptions from being raised.
For example:

```ruby
  PredictionIO::User.adelete(4){ |response|
    puts response.id
  }
  # => nil

  PredictionIO::User.adelete(4) { |r|
    puts r.notice.response.code
  }
  # => 404
```

Usage:
-----

###Creating an user

```ruby
  Prediction::User.acreate(1, { pio_latlgn: [ 23.0, 20.1 ] })

  # Or if you need to do something with the response:
  Prediction::User.acreate(1, { pio_latlgn: [ 23.0, 20.1 ] }) { |u|
  # this will be called whenever this job is done.
    puts u.id
  }
  # => 1
```

###Getting an user

```ruby
  Prediction::User.aget(1)

  # OR

  Prediction::User.aget(1, { extra_params }) { |u| print u.id }
```

###Deleting an user
```ruby
  PredictionIO::User.adelete(1)
  # OR
  PredictionIO::User.adelete(1) { |u| ... }
```


This project rocks and uses MIT-LICENSE.
=======================================
