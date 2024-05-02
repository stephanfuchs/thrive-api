# frozen_string_literal: true

class Tenant < ApplicationRecord

  scope :get_all_active_tenants, -> { where(is_frozen: false) }
  scope :not_reserved, -> { where(is_reserved: false) }
  scope :live, -> { get_all_active_tenants.not_reserved }

  def switch
    Apartment::Tenant.switch!(sub_domain)
  end

  class << self
    def current
      find_by(sub_domain: Apartment::Tenant.current)
    end

    def get_current_tenant
      self.where(sub_domain: Apartment::Tenant.current).first
    end

    def get_current_tenant_uuid
      get_current_tenant&.uuid.presence || '00000000-0000-0000-0000-000000000000'
    end
  end
  
  def frozen?
    is_frozen
  end

end
