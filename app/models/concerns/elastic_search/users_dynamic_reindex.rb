# frozen_string_literal: true

module ElasticSearch
  module UsersDynamicReindex
    extend ActiveSupport::Concern
    included do
      include ActiveJobPerformMixing
      after_commit :reindex_student_user

      def reindex_student_user
        return unless ENV['ELASTICSEARCH_URL'].present?

        user_id_method =
          [:users_reindex_user_id, :student_id, :user_id].find do |id_method|
            respond_to?(id_method)
          end
        reindexable_user_id = user_id_method.present? ? send(user_id_method) : nil

        return unless reindexable_user_id.present?

        # INFO: (Stephan) Based on `reindex(mode: :async)` and taken from https://github.com/ankane/searchkick/blob/v3.1.3/lib/searchkick/record_indexer.rb#L44-L49
        ReindexV2Job.perform_async([reindexable_user_id.to_s])
      end

      class << self
        def full_reindex
          return unless ENV['ELASTICSEARCH_URL'].present?
          searchkick_index.send(:bulk_indexer).import_scope(self)
        end

        def full_delete
          return unless ENV['ELASTICSEARCH_URL'].present?

          delete_records =
            elastic_search('*',
              load: false,
              smart_aggs: false,
              select: ['id'],
              page: 1,
              per_page: 10000,
              where: { tenant_uuid: Tenant.get_current_tenant_uuid }
            ).results.map do |result|
              # INFO: (Stephan) Issue comes from https://github.com/ankane/searchkick/blob/v3.1.3/lib/searchkick/process_batch_job.rb#L17-L26 +
              #                                  https://github.com/ankane/searchkick/blob/v3.1.3/lib/searchkick/record_data.rb#L29
              #                 Together with the delete logic which creates a new user through User.new(), it cannot find the user uuid, since it is not set
              User.new(id: result['id'], uuid: result['_id'])
            end.uniq

          # INFO: (Stephan) source https://github.com/ankane/searchkick/blob/v3.1.3/lib/searchkick/process_batch_job.rb#L32
          searchkick_index.send(:bulk_delete, delete_records)
        end

        def full_resync
          full_delete
          full_reindex
        end
      end
    end
  end
end
