require 'etc'
Iodine.threads = ENV['THREADS'] ? ENV['THREADS'].to_i : 4
Iodine.workers = ENV['WORKERS'] ? ENV['WORKERS'].to_i : Etc.nprocessors

if ENV['REDIS_URL']
  Iodine::PubSub.default = Iodine::PubSub::Redis.new(ENV['REDIS_URL'])
  puts "* Using Redis for pub/sub."
else
  puts "* Using Iodine for pub/sub within the process cluster."
end
