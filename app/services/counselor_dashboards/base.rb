# frozen_string_literal: true

module CounselorDashboards
  class Base
    attr_reader :tenant_uuid, :mentor_id

    # INFO: (Stephan) ensure that we pass the right args
    def check_type_error(*args_list)
      raise TypeError, 'The type of at least one argument is incorrect' if args_list.any? { |args_entry| args_entry.is_a?(Hash) }
    end

    def initialize(tenant, mentor_id = nil)
      raise CialfoException::ElasticSearchMissingTenantUuid.new unless tenant.kind_of?(Tenant) && tenant.uuid.present?

      @tenant_uuid = tenant.uuid
      @mentor_id = mentor_id
    end

    def allowed_entries
      {}
    end

    def clean_entries(key_entry, value_entry)
      value_entry = value_entry.to_s.to_sym
      allowed_entries[key_entry].include?(value_entry) ? value_entry : allowed_entries[key_entry].first
    end

    def query_hash
      {
        load: false,
        smart_aggs: false,
        where: {
          tenant_uuid: tenant_uuid,
          mentor_ids: mentor_id
        }.deep_clean
      }
    end

    def search
      @search ||= User.elastic_search('*', **query_hash)
    end
  end
end
