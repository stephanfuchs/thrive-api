class PgApplicationRecord < ApplicationRecord
  self.abstract_class = true
  establish_connection DB_PG
  extend Useful
end
