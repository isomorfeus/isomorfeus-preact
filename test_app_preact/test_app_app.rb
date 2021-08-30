require_relative 'app_loader'

class TestAppApp < Roda
  include Isomorfeus::PreactViewHelper

  plugin :public, root: 'public'

  def page_content(host, location)
    STDERR.puts "AHA"
    rendered_tree = mount_component('TestAppApp', { location_host: host, location: location })
    <<~HTML
      <html>
        <head>
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
      page_content(env['HTTP_HOST'], '/')
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
