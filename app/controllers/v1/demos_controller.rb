module V5
  class DemosController < V5::ApplicationController
    def index
      authorize :demo, :index?
      render json: { yes: true, no: 'maybe?' }
    end

    def show
      authorize :demo, :show?
      tenant_json = TenantBlueprint.render(Tenant.get_current_tenant, view: :extended)
      render json: tenant_json
    end

    def demo
      authorize :demo, :demo?
      render json: { demo: true }
    end
  end
end
