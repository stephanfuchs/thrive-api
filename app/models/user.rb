# frozen_string_literal: true

class User < ApplicationRecord
  include Users::Search
  include Users::UserTypeMasks
  include Users::UserRoles
  include ElasticSearch::Users
  include ElasticSearch::UsersDynamicReindex

  has_one   :mentor
  has_one   :signature, class_name: :UserSignature, dependent: :destroy
  has_one   :student

  has_many  :assesments, as: :assesmentable
  has_many  :session_tokens

  scope :active, -> { where(is_active: true) }
  scope :confirmed, -> { where(is_confirmed: true) }
  scope :not_deleted, -> { where(is_deleted: false) }
  scope :student, -> { where(user_type_mask: 1) }

  alias_method :users_reindex_user_id, :id # INFO: (Viral) used for ElasticSearch::UsersDynamicReindex
end
