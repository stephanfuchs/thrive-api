require 'rails_helper'

RSpec.describe Tenant, type: :model do
  let!(:tenant) { create(:tenant) }

  it '.sub_domain' do
    expect(tenant.sub_domain).to eq 'companion-test'
  end
end
