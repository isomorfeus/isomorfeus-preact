require_relative 'app_loader'

class TestAppApp < Roda
  include Isomorfeus::PreactViewHelper
  use Isomorfeus::AssetManager::RackMiddleware

  plugin :public, root: 'public'

  def page_content(host, location)
    req = Rack::Request.new(env)
    skip_ssr = req.params.key?("skip_ssr") ? true : false
    rendered_tree = mount_component('TestAppApp', { location_host: host, location: location }, 'ssr.js', skip_ssr: skip_ssr)
    <<~HTML
      <html>
        <head>
          <meta charset="UTF-8">
          <title>Welcome to TestAppApp</title>
          #{script_tag 'web.js'}
          <style id="css-server-side" type="text/css">#{ssr_styles}</style>
        </head>
        <body>
          #{rendered_tree}
          <div id="test_anchor"></div>
        </body>
      </html>
    HTML
  end

  route do |r|
    r.root do
      begin
        page_content(env['HTTP_HOST'], '/')
      rescue Exception => e
        Isomorfeus.raise_error(error: e)
      end
    end

    r.public

    r.get 'favicon.ico' do
      r.public
    end

    r.get 'ssr' do
      rendered_tree = mount_component('TestAppApp', { location_host: env['HTTP_HOST'],  location: env['PATH_INFO'] })
      content = <<~HTML
      <html>
        <head>
          <meta charset="UTF-8">
          <title>Welcome to TestAppApp</title>
          <style id="css-server-side" type="text/css">#{ssr_styles}</style>
        </head>
        <body>
          #{rendered_tree}
          <div id="test_anchor"></div>
        </body>
      </html>
      HTML
      response.status = ssr_response_status
      content
    end

    r.get do
      content = page_content(env['HTTP_HOST'], env['PATH_INFO'])
      response.status = ssr_response_status
      content
    end
  end
end
