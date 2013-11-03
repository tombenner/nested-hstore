Nested Hstore
=============
Store nested hashes and other types in ActiveRecord hstores

Overview
--------

Postgres hstores offer a number of benefits, but they don't natively support multi-level data. Nested Hstore adds this support to ActiveRecord, letting you treat an hstore like a NoSQL-like document.

[Hstore functions](http://www.postgresql.org/docs/9.1/static/hstore.html) are still supported at the root level.

It also lets you store data types other than hashes in an hstore. All of the following values will be returned verbatim:

```ruby
# Nested hash
post.my_hstore = {
  'title' => 'My Post',
  'comment_ids' => [34, 67, 82],
  'user' => {
    'id' => 15,
    'username' => 'janedoe'
  }
}

# Array
post.my_hstore = [34, 67, 82]

# Array of nested hashes
post.my_hstore = [
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
post.my_hstore = 43

# Float
post.my_hstore = 43.1

# String
post.my_hstore = 'janedoe'
```

Installation
------------

Include it in your Gemfile:

    gem 'nested-hstore'

Set up [activerecord-postgres-hstore](https://github.com/diogob/activerecord-postgres-hstore) if you haven't already. Instead of using ActiveRecord::Coders::Hstore, use:

```ruby
class Post < ActiveRecord::Base
  serialize :my_store, ActiveRecord::Coders::NestedHstore
end
```

License
-------

Nested Hstore is released under the MIT License. Please see the MIT-LICENSE file for details.
