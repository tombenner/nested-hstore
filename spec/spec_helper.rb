require 'nested-hstore'

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

db_path = Pathname.new(File.expand_path('../db', __FILE__))
require db_path.join('create_posts.rb')
ActiveRecord::Base.establish_connection(YAML.load_file(db_path.join('connection.yml')))

