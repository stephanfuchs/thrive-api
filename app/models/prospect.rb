# frozen_string_literal: true

class Prospect < ApplicationRecord
  self.table_name = 'transaction'
  include ElasticSearch::Prospects

  # default_scope -> { active }

  # belongs_to :user

  # scope :active, -> { where(deletedat: nil, disabled: false) }
end
