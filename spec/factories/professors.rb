FactoryBot.define do
  factory :professor do
    sequence(:name) { |n| "Professor #{n}" }
    sequence(:username) { |n| "professor#{n}" }
    sequence(:email) { |n| "professor#{n}@gmail.com" }
    sequence(:lattes) { |n| "http://lattes.com.#{n}" }
    gender { Professor.genders.values.sample }
    is_active { Faker::Boolean.boolean }
    available_advisor { Faker::Boolean.boolean }
    working_area { Faker::Markdown.headers }
    password { 'password' }
    password_confirmation { 'password' }
    professor_type
    scholarity
  end
end
