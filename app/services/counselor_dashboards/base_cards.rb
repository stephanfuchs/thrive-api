# frozen_string_literal: true

# CounselorDashboards::BaseCards.new.clean_up_elastic_search_aggs_data(incoming_data)
# x1 = JSON.parse(File.read('spec/fixtures/counselor_dashboard/clean_up_elastic_search_aggs_data_last_login_data.json'))
# CounselorDashboards::BaseCards.new.clean_up_elastic_search_aggs_data(x1.dup)
# x2 = JSON.parse(File.read('spec/fixtures/counselor_dashboard/clean_up_elastic_search_aggs_data_lists_data.json'))
# CounselorDashboards::BaseCards.new.clean_up_elastic_search_aggs_data(x2.dup)
# x3 = JSON.parse(File.read('spec/fixtures/counselor_dashboard/clean_up_elastic_search_aggs_data_assesments_data.json'))
# CounselorDashboards::BaseCards.new.clean_up_elastic_search_aggs_data(x3.dup)

module CounselorDashboards
  class BaseCards < Base
    def body_options
      {
        body_options: {
          size: 0, # https://www.elastic.co/guide/en/elasticsearch/reference/6.7/returning-only-agg-results.html#returning-only-agg-results
          aggs: aggs_body
        }
      }
    end

    def query_hash
      [
        super,
        body_options,
      ].inject(&:deep_merge)
    end

    def search
      clean_up_elastic_search_aggs_data(super.aggs['graduation_year'])
    end

    def clean_up_elastic_search_aggs_data(incoming_data, key_value = nil)
      return unless incoming_data.is_a?(Hash)

      incoming_data = incoming_data.stringify_keys!
      return_hash = {}
      data_hash = {}
      key_value ||= incoming_data['key_as_string'].presence || incoming_data['key'].presence
      buckets_data = incoming_data['buckets']

      data_hash =
        # this is most basic key-value setup
        #   1. {"key": 0,"key_as_string": "false","doc_count": 2872} => { "false" => 2872 }
        #   2. it does not `to_as_string` and `from_as_string`
        if incoming_data.has_key?('key') &&
          incoming_data.has_key?('doc_count') &&
          incoming_data.values.map(&:class).exclude?(Hash)
          incoming_data['doc_count']
        # Array of Hashes
        elsif buckets_data
          buckets_data.map do |buckets_data_entry|
            self.send(__method__, buckets_data_entry)
          end.compact.inject(&:deep_merge) || {}
        # Hash
        else
          incoming_data.map do |data_key, data_value|
            self.send(__method__, data_value, data_key)
          end.compact.inject(&:deep_merge)
        end

      if key_value
        return_hash[key_value] = data_hash
      else
        return_hash = data_hash
      end

      return_hash
    end

    def call
      base_card_hash.deep_merge!(search)
    end
  end
end
