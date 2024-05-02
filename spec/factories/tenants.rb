FactoryBot.define do
  factory :tenant do
    name { 'companion-test' }
    sub_domain { 'companion-test' }
    api_access_token { 'this-api_access_token'}
    is_frozen { false }
  end
end
