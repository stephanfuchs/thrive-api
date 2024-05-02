# frozen_string_literal: true

module CounselorDashboards
  class CommonAppStatusCard < CounselorBase
    def initialize(params, current_user)
      super(params, current_user)
    end

    def call
      {
        "ferpa_status": {
          "true": students.waived.count,
          "false": students.where.not(ferpa_status: 1).count
        },
        "common_app_linked": {
          "true": CommonAppAccount.where(tenant_id: current_tenant.id, user_id: students.map(&:user_id)).where.not(common_app_id: nil).count,
          "false": CommonAppAccount.where(tenant_id: current_tenant.id, user_id: students.map(&:user_id)).where(common_app_id: nil).count
        }
      }
    end
  end
end
