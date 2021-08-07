module Isomorfeus
  module Preact
    class RedisComponentCache
      def initialize(*args)
        @redis_client = Redis.new(@args)
      end

      def fetch(key)
        json = @redis_client.get(key)
        Oj.load(json, mode: :strict)
      end

      def store(key, rendered_tree, response_status, styles)
        json = Oj.dump([rendered_tree, response_status, styles], mode: :strict)
        @redis_client.set(key, json)
      end
    end
  end
end
