FactoryGirl.define do
  factory :server do
    name { FFaker::Movie.title }
    addr { FFaker::Internet.ip_v4_address }
    generate_keys { "1" }
  end
end