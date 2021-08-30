require_relative 'all_component_types_app'

if !Isomorfeus.development?
  Isomorfeus.zeitwerk.setup
  Isomorfeus.zeitwerk.eager_load

  run AllComponentTypesApp.app
else
  Isomorfeus.zeitwerk.enable_reloading
  Isomorfeus.zeitwerk.setup
  Isomorfeus.zeitwerk.eager_load

  run ->(env) do
    write_lock = Isomorfeus.zeitwerk_lock.try_write_lock
    if write_lock
      Isomorfeus.zeitwerk.reload
      Isomorfeus.zeitwerk_lock.release_write_lock
    end
    Isomorfeus.zeitwerk_lock.with_read_lock do
      AllComponentTypesApp.call env
    end
  end
end
