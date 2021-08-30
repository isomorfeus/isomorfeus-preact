require 'spec_helper'

RSpec.describe 'Server Side Rendering' do
  before do
    @doc = visit('/ssr')
  end
  it 'renders on the server' do
    skip unless Isomorfeus.server_side_rendering
    expect(@doc.html).to include('Rendered!')
  end

  it 'save the application state for the client' do
    skip unless Isomorfeus.server_side_rendering
    state_json = @doc.evaluate_script('JSON.stringify(ServerSideRenderingStateJSON)')
    state = Oj.load(state_json, mode: :strict)
    expect(state).to have_key('application_state')
    expect(state).to have_key('instance_state')
    expect(state).to have_key('class_state')

    # does not work like this when autoloading
    #expect(state['application_state']).to have_key('a_value')
    #expect(state['application_state']['a_value']).to eq('application store works')
    #expect(state['class_state']).to have_key('HelloComponent')
    #expect(state['class_state']['HelloComponent'])
    #expect(state['class_state']['HelloComponent']['a_value']).to eq('component class store works')
    #expect(state['class_state']['HelloComponent']).to have_key('instance_defaults')
    #expect(state['class_state']['HelloComponent']['instance_defaults']).to have_key('a_value')
    #expect(state['class_state']['HelloComponent']['instance_defaults']['a_value']).to eq('component store works')
  end

  it 'save the application state for the client, also on subsequent renders' do
    skip unless Isomorfeus.server_side_rendering
    # just the same as above, just a second time, just to see if the store is initialized correctly
    state_json = @doc.evaluate_script('JSON.stringify(ServerSideRenderingStateJSON)')
    state = Oj.load(state_json, mode: :strict)
    expect(state).to have_key('application_state')
    expect(state).to have_key('instance_state')
    expect(state).to have_key('class_state')

    # does not work like this when autoloading
    #expect(state['application_state']).to have_key('a_value')
    #expect(state['application_state']['a_value']).to eq('application store works')
    #expect(state['class_state']).to have_key('HelloComponent')
    #expect(state['class_state']['HelloComponent'])
    #expect(state['class_state']['HelloComponent']['a_value']).to eq('component class store works')
    #expect(state['class_state']['HelloComponent']).to have_key('instance_defaults')
    #expect(state['class_state']['HelloComponent']['instance_defaults']).to have_key('a_value')
    #expect(state['class_state']['HelloComponent']['instance_defaults']['a_value']).to eq('component store works')
  end

  it 'it returns 404 if page not found' do
    skip unless Isomorfeus.server_side_rendering
    # just the same as above, just a second time, just to see if the store is initialized correctly
    @doc = visit('/whatever')
    expect(@doc.response.status).to eq(404)
  end
end
