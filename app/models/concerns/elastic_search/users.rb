# frozen_string_literal: true

# INFO: (Stephan) good sources
#   1. https://tiagoamaro.com.br/2014/12/11/multi-tenancy-with-searchkick/
#   2. https://dev.to/mahmoudsultan36/patching-searchkich-gem-to-add-custom-queries-by-default-21m0

module ElasticSearch
  module Users
    extend ActiveSupport::Concern
    included do
      searchkick callbacks: false, merge_mappings: true, 
      settings: {
        # See
        # 1. https://stackoverflow.com/questions/22099906/unexpected-case-insensitive-string-sorting-in-elasticsearch
        # 2. https://www.elastic.co/guide/en/elasticsearch/reference/6.8/analysis-normalizers.html
        analysis: {
          normalizer: {
            base_normalizer: {
              type: 'custom',
              filter: ['lowercase', 'asciifolding']
            }
          }
        }
      }, 
      mappings: {
        properties: {
          last_login: {
            type: 'date'
          },
          last_login_comparison: {
            type: 'date'
          },
          last_name: {
            type: 'keyword',
            'normalizer': 'base_normalizer'
          }
        }
      }

      scope :search_import, -> {
        student.active.confirmed.not_deleted
        .includes(
          :assesments,
          student: [:student_mentors, :student_colleges])
        .select("
          users.*,
          '#{Tenant.get_current_tenant_uuid}' AS search_import_tenant_uuid
        ")
      }

      def search_document_id
        uuid
      end

      def search_data
        # INFO: (Stephan) taken from https://github.com/cialfo/app-cialfo-co-api/blob/83c747d4890ac9e98a00b95e7ebff3f35a14614a/app/views/v3/students/partials/_assesments.json.jbuilder
        assesment_data =
          Constants::Assessments::AVAILABLE.reduce({}) do |return_hash, available_assesment|
            assesment_entry = assesments.find { |assesment| assesment.external_id == available_assesment[:id] }
            if assesment_entry.present?
              return_hash[available_assesment[:student_search_key]] = assesment_entry&.state == 'completed'
            end
            return_hash
          end
        assesment_state_data =
          Constants::Assessments::AVAILABLE.reduce({}) do |return_hash, available_assesment|
            assesment_entry = assesments.find { |assesment| assesment.external_id == available_assesment[:id] }
            if assesment_entry.present?
              return_hash[available_assesment[:student_search_key]] = assesment_entry&.state
            end
            return_hash
          end
        base_lists_stats_data =
          student ? StudentCollege.get_colleges(student.id).group_by(&:app4_list_id) : {}

        lists_stats_data =
          StudentCollege::IN_LIST_IDS_HASH.reduce({}) do |return_hash, (list_name, list_id)|
            return_hash[list_name] = (base_lists_stats_data[list_id]&.length || 0) > 0
            return_hash
          end
        lists_count_data =
          StudentCollege::IN_LIST_IDS_HASH.reduce({}) do |return_hash, (list_name, list_id)|
            return_hash[list_name] = base_lists_stats_data[list_id]&.length || 0
            return_hash
          end
        last_login_comparison = last_login.presence || 0
        slice(
          :first_name,
          :id,
          :last_login,
          :last_name,
          :preferred_name
        ).merge(
          assesments_completed: assesment_data,
          assesments_states: assesment_state_data,
          registered: last_login_comparison != 0,
          graduation_year: student&.graduation_year,
          last_login_comparison: last_login_comparison,
          last_registration_sent_at: registration_email_sent_at,
          lists_counts: lists_count_data,
          lists_stats: lists_stats_data,
          mentor_ids: student&.student_mentors&.map(&:mentor_id) || [],
          tenant_uuid: respond_to?(:search_import_tenant_uuid) ? search_import_tenant_uuid : Tenant.get_current_tenant_uuid,
        )
      end

      def should_index?
        student? && is_active && is_confirmed && !is_deleted
      end
    end
  end
end
