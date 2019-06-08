require 'isomorfeus-react-base'

# basics
require 'react/component/native_component_validate_prop'
require 'react/component/event_handler'
require 'react/component/api'
require 'react/component/callbacks'
require 'react/component/resolution'
require 'react/component/state'
require 'react/component/should_component_update'
require 'react/redux_component/api'
require 'react/redux_component/app_store_defaults'
require 'react/redux_component/component_class_store_defaults'
require 'react/redux_component/component_instance_store_defaults'
require 'react/redux_component/app_store_proxy'
require 'react/redux_component/class_store_proxy'
require 'react/redux_component/instance_store_proxy'
require 'react/redux_component/reducers'

require 'react/component/styles'
# init component reducers
React::ReduxComponent::Reducers.add_component_reducers_to_store

# init LucidApplicationContext (Store Provider and Consumer)
require 'lucid_app/context'
LucidApp::Context.create_application_context

require 'lucid_component/api'
require 'lucid_component/event_handler'
require 'lucid_component/initializer'
require 'lucid_app/api'

# LucidMaterial::Component
require 'lucid_material/component/api'
require 'lucid_material/component/native_component_constructor'
require 'lucid_material/component/mixin'
require 'lucid_material/component/base'
# LucidMaterial::App
require 'lucid_material/app/native_component_constructor'
require 'lucid_material/app/mixin'
require 'lucid_material/app/base'
