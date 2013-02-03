# Ui_Changed

This rails plugin provides an interface for detecting differences in your UIs by comparing screenshots.

## Installation

Ui_Changed works with Rails 3.1 and up. You can add it to your Gemfile with:

```ruby
gem 'ui_changed'
```

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

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```

Ui_Changed uses ImageMagick under the covers. Installing it via [HomeBrew][homebrew] seems to be the easiest:

    brew install imagemagick


[Download][selenium_downloads] the selenium-server-standalone jar file and place it someplace safe:

    selenium-server-standalone-2.##.0.jar

## Usage

Start up your resque worker. This guy will do all of our work in the background:

    rake resque:work QUEUE=*

Start up your selenium server. This guy does the work of saving our screenshots to the filesystem:

    java -jar path/to/your/selenium_server/selenium-server-standalone-2.##.0.jar

Start up your Rails webserver. This is not strickly required if you intend on just using the rake tasks.

    rails s

... and browse to

    http://localhost:3000/ui_changed

Hit the "Start All" button to perform the control, test, and comparison all at once. If you only want to generate the "Control" screenshots, then just click that one.

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

[forking]: http://help.github.com/forking/
[pull requests]: http://help.github.com/pull-requests/
[selenium_downloads]: http://code.google.com/p/selenium/downloads/list
[homebrew]: http://mxcl.github.com/homebrew/