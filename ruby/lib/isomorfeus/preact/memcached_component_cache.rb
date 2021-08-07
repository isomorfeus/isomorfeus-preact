module Isomorfeus
  module Preact
    class MemcachedComponentCache
      def initialize(*args)
        @dalli_client = Dalli::Client.new(*args)
      end

      def fetch(key)
        json = @dalli_client.get(key)
        Oj.load(json, mode: :strict)
      end

      def store(key, rendered_tree, response_status, styles)
        json = Oj.dump([rendered_tree, response_status, styles], mode: :strict)
        @dalli_client.set(key, json)
      end
    end
  end
end
