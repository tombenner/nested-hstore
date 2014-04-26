Nested Hstore
=============
Store nested hashes and other types in ActiveRecord hstores

Overview
--------

Postgres hstores offer a number of benefits, but they don't natively support multi-level data. Nested Hstore adds this support to ActiveRecord, letting you treat an hstore like a NoSQL-like document.

[Hstore functions](http://www.postgresql.org/docs/9.1/static/hstore.html) are still supported at the root level.

It also lets you store data types other than hashes in an hstore. All of the following values will be returned verbatim:

```ruby
class User < ActiveRecord::Base
  serialize :my_property, ActiveRecord::Coders::NestedHstore
end

# Nested hash
user.my_property = {
  'name' => 'Jane Doe',
  'comment_ids' => [34, 67, 82],
  'location' => {
    'id' => 15,
    'city' => 'San Francisco',
    'state' => 'CA'
  }
}

# Array
user.my_property = [34, 67, 82]

# Array of nested hashes
user.my_property = [
  {
    'id' => 15,
    'username' => 'janedoe'
  },
  {
    'id' => 16,
    'username' => 'johndoe'
  }
]

# Integer
user.my_property = 43

# Float
user.my_property = 43.1

# String
user.my_property = 'janedoe'
```

Installation
------------

Include it in your Gemfile:

    gem 'nested-hstore'

Set up [activerecord-postgres-hstore](https://github.com/diogob/activerecord-postgres-hstore) if you haven't already. Instead of using ActiveRecord::Coders::Hstore, use:

```ruby
class User < ActiveRecord::Base
  serialize :my_property, ActiveRecord::Coders::NestedHstore
end
```

Testing
-------

Nested Hstore is tested against ActiveRecord 3 and 4. If you'd like to submit a PR, please be sure to use [Appraisal](https://github.com/thoughtbot/appraisal) to test your changes in both contexts:

```bash
appraisal rspec
```

License
-------

Nested Hstore is released under the MIT License. Please see the MIT-LICENSE file for details.
