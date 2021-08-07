if ENV['RACK_ENV'] && ENV['RACK_ENV'] != 'development'
  require_relative 'test_app_app'

  Isomorfeus.zeitwerk.setup
  Isomorfeus.zeitwerk.eager_load

  run TestAppApp.app
else
  require_relative 'test_app_app'

  Isomorfeus.zeitwerk.enable_reloading
  Isomorfeus.zeitwerk.setup
  Isomorfeus.zeitwerk.eager_load

  run ->(env) do
    Isomorfeus.zeitwerk_lock.with_write_lock do
      Isomorfeus.zeitwerk.reload
    end
    Isomorfeus.zeitwerk_lock.with_read_lock do
      TestAppApp.call env
    end
  end
end
