DB_PG = YAML::load(ERB.new(File.read(Rails.root.join('config','database_pg.yml'))).result, aliases: true)[Rails.env]
