class TenantBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :name, :sub_domain
  end

  view :extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
