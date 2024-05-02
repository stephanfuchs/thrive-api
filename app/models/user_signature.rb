# frozen_string_literal: true

class UserSignature < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :uploader, class_name: :User, required: true
end
