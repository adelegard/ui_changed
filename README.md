## Ui_Changed

[![Build Status](https://secure.travis-ci.org/adelegard/ui_changed.png?branch=master)](http://travis-ci.org/adelegard/ui_changed)
[![Gem Version](https://badge.fury.io/rb/ui_changed.png)][gem]

This rails plugin provides an interface for detecting differences in your UIs by comparing screenshots.

## Installation

Ui_Changed works with Rails 3.1 and up. You can add it to your Gemfile with:

```ruby
gem 'ui_changed'
```

Then install it with:

    bundle install

Ui_Changed needs some database tables generated in order to function properly. To add these to your existing database:

    rake ui_changed:install:migrations

This command copies over the necessary migrations from ui_changed. To execute these run the following

    rake db:migrate
    
Add ui_changed.yml to your config directory:

```yml
defaults: &defaults
  control_path: "public/screenshots/control/"
  test_path: "public/screenshots/test/"
  compare_path: "public/screenshots/compare/"
  auth_username:
  auth_password:
  control_url: "http://some_control_url"
  test_url: "http://some_test_url"
  skip_url_reg_exp:
  skip_query_strings: true
  email_results_to:
  email_after_control_crawl: true
  email_after_test_crawl: true
  email_after_compare: true
  email_after_compare_with_diffs: true
  email_after_compare_with_diffs_on_zero_found: true

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```

Add the required resque.rb file to your config/initializers directory. This can be done with the following built-in generator:

    rails generate ui_changed:resque

Or add it yourself:

```ruby
# config/initializers/resque.rb

Resque.redis = "localhost:6379"
Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds

# mailer queue name
Resque::Mailer.default_queue_name = 'ui_changed_mailer'
```

If you want Ui_Changed to send out emails, then you will need to configure an action mailer in your application/development/production rb file. For example:

```ruby
config.action_mailer.default_url_options = { :host => 'localhost:3000' }

config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "your_gmail_username@gmail.com",
  :password             => "your_gmail_password",
  :authentication       => :plain,
  :enable_starttls_auto => true
}

```

Add the following to your routes.rb file:

```ruby
mount UiChanged::Engine, :at => "ui_changed"
```

Ui_Changed uses ImageMagick under the covers. Installing it via [HomeBrew][homebrew] seems to be the easiest:

    brew install imagemagick


[Download][selenium_downloads] the selenium-server-standalone jar file and place it someplace safe:

    selenium-server-standalone-2.##.0.jar

## Usage

Start up your resque crawl worker. This guy will do all of our crawling/comparing work in the background:

    rake resque:work QUEUE=crawl

Start up your resque email worker. This guy will send out emails in the background:

    rake resque:work QUEUE=ui_changed_mailer

Start up your selenium server. This guy does the work of saving our screenshots to the filesystem:

    java -jar path/to/your/selenium_server/selenium-server-standalone-2.##.0.jar

Start up your Rails webserver. This is not strickly required if you intend on just using the rake tasks.

    rails s

... and browse to

    http://localhost:3000/ui_changed

Hit the "Start All" button to perform the control, test, and comparison all at once. If you only want to generate the "Control" screenshots, then just click that one (etc).

## Rake usage

A good amount of the functionality exposed via the web interface can also be done via Rake tasks:

    rake ui_changed:crawl_for_control
    rake ui_changed:crawl_for_test
    rake ui_changed:crawl_for_control_and_test
    rake ui_changed:crawl_for_control_and_compare
    rake ui_changed:crawl_for_test_and_compare
    rake ui_changed:compare

## Contributing to Ui_Changed

Once you've made your great commits:

1. [Fork][forking] Ui_Changed
2. Create a feature branch
3. Write your code (and tests please)
4. Push to your branch's origin
5. Create a [Pull Request][pull requests] from your branch
6. That's it!

## Links

* Code: `git clone git://github.com/adelegard/ui_changed.git`
* Bugs: <https://github.com/adelegard/ui_changed/issues>

## Copyright

Copyright © 2013 Alex Delegard. See LICENSE.txt for
further details.

[gem]: https://rubygems.org/gems/ui_changed
[forking]: http://help.github.com/forking/
[pull requests]: http://help.github.com/pull-requests/
[selenium_downloads]: http://code.google.com/p/selenium/downloads/list
[homebrew]: http://mxcl.github.com/homebrew/