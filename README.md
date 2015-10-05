# simple_presenter

[![](https://dl.dropboxusercontent.com/u/1540890/simple_presenter.svg)](http://github.com/fnando/burgundy)

## Installation

```
gem install simple_presenter
```

## Usage

```ruby
class User < ActiveRecord::Base
  # implements the following attributes: name, email, password_hash, password_salt
end

class UserPresenter < Presenter
  expose :name, :email
end

user = UserPresenter.new(User.first)
users = UserPresenter.map(User.all)
```

If you're using Simple Presenter within Rails, presenters also have access to:

* route helpers: just use the `routes` or `r` methods
* view helpers: just use the `helpers` or `h` methods
* I18n methods: just use the `translate`, `t`, `localize` or `l` methods

If you want to to use `*_url` route methods, make sure you set the `default_url_options` option. You can use the `config.simple_presenter.default_url_options` method, which defaults to `config.action_mailer.default_url_options`. You can add something like the following to your `config/environments/development.rb`, for instance:

```ruby
config.simple_presenter.default_url_options = {:host => "localhost:3000"}
```

For additional usage, check the specs.

## TO-DO

* Recognize ActiveRecord objects and automatically expose attributes used by url and form helpers (like `Model.model_name`, `Model#to_key`, and `Model#to_param`).
* Override `respond_to?` to reflect exposed attributes.

## Troubleshooting

If you're having problems because already have a class/module called Presenter that is conflicting with this gem, you can require the namespace and inherit from `SimplePresenter::Base`.

```ruby
require "simple_presenter/namespace"

class UserPresenter < SimplePresenter::Base
end
```

If you're using Rails/Bundler or something like that, remember to override the `:require` option.

  # Gemfile
  source :rubygems

  gem "simple_presenter", :require => "simple_presenter/namespace"

## Maintainer

* Nando Vieira (http://nandovieira.com.br)

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
