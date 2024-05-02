# frozen_string_literal: true

class Assesment < ApplicationRecord
	include ElasticSearch::UsersDynamicReindex

  enum state: [:assigned, :in_progress, :completed]
end
