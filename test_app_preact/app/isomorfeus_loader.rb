require 'opal'
start = Time.now
require 'isomorfeus-redux'
IX_REQUIRE_TIME = (Time.now - start) * 1000
i_start = Time.now
require 'isomorfeus-preact'
IP_REQUIRE_TIME = (Time.now - i_start) * 1000

%x{
  class NativeComponent extends Opal.global.Preact.Component {
    constructor(props) {
      super(props);
    }
    render() {
      return Opal.global.Preact.createElement('div', null, 'A');
    }
  }
  Opal.global.NativeComponent = NativeComponent;

  class TopNativeComponent extends Opal.global.Preact.Component {
    constructor(props) {
      super(props);
    }
    render() {
      return Opal.global.Preact.createElement('div', null, 'TopNativeComponent');
    }
  }
  Opal.global.TopNativeComponent = TopNativeComponent;

  Opal.global.NestedNative = {};
  class AnotherComponent extends Opal.global.Preact.Component {
    constructor(props) {
      super(props);
    }
    render() {
      return Opal.global.Preact.createElement('div', null, 'NestedNative.AnotherComponent');
    }
  }
  Opal.global.NestedNative.AnotherComponent = AnotherComponent;
}

require_tree 'components', :autoload
i_start = Time.now
Isomorfeus.start_app!
IP_LOAD_TIME = (Time.now - i_start) * 1000
APP_LOAD_TIME = (Time.now - start) * 1000
