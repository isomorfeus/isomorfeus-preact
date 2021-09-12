require_relative 'app_loader'

class AllComponentTypesApp < Roda
  include Isomorfeus::PreactViewHelper
  extend Isomorfeus::Transport::Middlewares
  use_isomorfeus_middlewares

  plugin :public, root: 'public'

  def page_content(env, location)

    begin
      <<~HTML
        <html>
          <head>
            <title>Welcome to AllComponentTypesApp</title>
            #{script_tag 'web.js'}
            <style id="css-server-side" type="text/css">#{ssr_styles}</style>
          </head>
          <body>
            #{mount_component('AllComponentTypesApp', { location_host: env['HTTP_HOST'], location: location })}
          </body>
        </html>
      HTML
    rescue Exception => e
      STDERR.puts e.message
      STDERR.puts e.backtrace.join("\n")
    end
  end

  route do |r|
    r.root do
      content = page_content(env, '/')
      response.status = ssr_response_status
      content
    end

    r.public

    r.get 'favicon.ico' do
      r.public
    end

    r.get do
      content = page_content(env, env['PATH_INFO'])
      response.status = ssr_response_status
      content
    end
  end
end
