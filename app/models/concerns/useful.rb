module Useful
  extend ActiveSupport::Concern

  def useful_names_hash
    Hash[pluck(:id, :name)]
  end

  def base_search_cleaning(search_source_input_values)
    if search_source_input_values.class != String
      return where('1=1')
    end

    # INFO: (Stephan) added this replace setup to deal with non utf-8 encoding
    #                 https://stackoverflow.com/a/29877417
    search_input_values =
      search_source_input_values.encode('UTF-8', invalid: :replace, replace: ' ')

    if search_input_values.blank?
      return where('1=1')
    end

    search_values = search_input_values.strip.split.map { |chunk| "%#{chunk}%" }

    yield(search_values.join, search_values)
  end

  def or_merge_subqueries(*queries)
    queries.flatten.map do |query|
      arel_table[:id].in(Arel.sql(query))
    end.reduce(:or)
  end
end
