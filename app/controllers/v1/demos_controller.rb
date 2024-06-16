module V1
  class DemosController < ::ApplicationController
    def index
      authorize :demo, :index?
      render json: { yes: true, no: 'maybe?' }
    end

    def show
      authorize :demo, :show?
      render json: { show: 'Yes admin!' }
    end

    def demo
      authorize :demo, :demo?
      render json: { demo: true }
    end
  end
end
