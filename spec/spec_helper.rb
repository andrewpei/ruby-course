# Require our project, which in turns requires everything else
require './lib/task-manager.rb'

# RSPec.configure do |config|
#   config.before(:each) do
#     TM:orm.instance_variable_set(:@db_adapter, PG.connect(host: 'localhost', dbname: 'tm-db-test'))
# end