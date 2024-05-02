# frozen_string_literal: true

module CounselorDashboards
  class CounselorBase
    attr_reader :students, :graduation_year, :dashboard_user, :dashboard_user_id, :current_user

    def initialize(params, current_user)
      @graduation_year    = graduation_year
      @dashboard_user_id  = params[:dashboard_user_id]
      @current_user       = current_user
    end

    def students
      @students ||= if dashboard_user_id.blank? && current_user.admin?
        Student.where(graduation_year: graduation_year)
      else
        dashboard_user&.mentor&.students&.where(graduation_year: graduation_year)
      end
    end

    def graduation_year
      date = Time.now
      return date.year + 1 if date.month >= 8

      date.year
    end

    def dashboard_user
      @dashboard_user ||= begin
        return current_user if current_user.mentor? && !current_user.admin?
        User.find_by(id: dashboard_user_id)
      end
    end

    def current_tenant
      @current_tenant ||= Tenant.get_current_tenant
    end

    def country_ids
      names = []
      case app_type
      when 'usa'
        names << 'United States'
      when 'canada'
        names << 'Canada'
      when 'anz'
        names = ['Australia', 'New Zealand']
      end

      CountryTranslation.where(name: names).pluck(:id)
    end

    def region_based_dap_ids
      (DirectApplyProgram.joins(:school).where(schools: { country_id: country_ids }).pluck(:id).presence || [-1]).join(',')
    end

    def dap_ucas_ids
      @dap_ucas_ids ||= DirectApplyProgram.ucas.pluck(:id)
    end
  end
end
