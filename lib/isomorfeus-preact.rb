if RUBY_ENGINE == 'opal'
  require 'isomorfeus-redux'
  require 'active_support/core_ext/string'
  require 'zeitwerk'

  if on_browser?
    require 'browser/event'
    require 'browser/event_target'
    require 'browser/delegate_native'
    require 'browser/element'
  end

  require 'isomorfeus/preact/config'

  # allow mounting of components
  if on_browser?
    require 'isomorfeus/top_level'
  else
    require 'isomorfeus/top_level_ssr'
  end

  # nanocss
  require 'nano_css'

  # preact
  require 'preact/version'
  require 'preact'
  require 'preact/ref'

  # props
  require 'isomorfeus/props/validate_hash_proxy'
  require 'isomorfeus/props/validator'
  require 'lucid_prop_declaration/mixin'
  require 'preact/params'
  require 'preact/props'

  # HTML Elements and Fragment support
  require 'preact/component/elements'

  # Preact Wrappers
  require 'preact/context_wrapper'
  require 'preact/native_constant_wrapper'

  # Preact::Component
  require 'preact/component/api'
  require 'preact/component/callbacks'
  require 'preact/component/initializer'
  require 'preact/component/native_component_constructor'
  require 'preact/state'
  require 'preact/component/resolution'
  require 'preact/component/mixin'
  require 'preact/component/base'

  # init LucidApplicationContext (Store Provider and Consumer)
  require 'lucid_app/context'
  LucidApp::Context.create_application_context

  class Object
    include Preact::Component::Resolution
  end

  Isomorfeus.zeitwerk = Zeitwerk::Loader.new

  Isomorfeus.zeitwerk.push_dir('isomorfeus_preact')
  require_tree 'isomorfeus_preact', autoload: true

  Isomorfeus.zeitwerk.push_dir('components')
else
  require 'uri'
  require 'oj'
  require 'opal'
  require 'opal-activesupport'
  require 'opal-zeitwerk'
  require 'isomorfeus-speednode'
  require 'isomorfeus-asset-manager'
  require 'isomorfeus-redux'
  require 'preact/version'
  require 'isomorfeus/preact/config'

  # props
  require 'isomorfeus/props/validate_hash_proxy'
  require 'isomorfeus/props/validator'
  require 'lucid_prop_declaration/mixin'

  if Isomorfeus.development?
    require 'net/http'
    Isomorfeus.ssr_hot_asset_url = 'http://localhost:3036/assets/'
  end

  Isomorfeus.server_side_rendering = true

  # caches
  require 'isomorfeus/preact/thread_local_component_cache'
  require 'isomorfeus/preact/memcached_component_cache'
  require 'isomorfeus/preact/redis_component_cache'
  require 'isomorfeus/preact_view_helper'

  Isomorfeus.component_cache_init do
    Isomorfeus::ThreadLocalComponentCache.new
  end

  Opal.append_path(__dir__.untaint)

  require 'concurrent'
  require 'zeitwerk'

  Isomorfeus.zeitwerk = Zeitwerk::Loader.new
  Isomorfeus.zeitwerk_lock = Concurrent::ReentrantReadWriteLock.new if Isomorfeus.development?
  # nothing to push_dir to zeitwerk here, as components are available only within browser/SSR

  require 'isomorfeus/preact/imports'
  Isomorfeus.node_paths << File.expand_path(File.join(File.dirname(__FILE__), '..', 'node_modules'))
  Isomorfeus::Preact::Imports.add
end
