FactoryBot.define do
  factory :signature do
    orientation
    document
    signature_code
    user_id { Faker::Number.non_zero_digit }
    user_type { 'AD' }
    status { false }

    factory :signature_signed do
      status { true }
    end

    factory :academic_signature do
      user_type { 'AC' }
    end

    factory :external_member_signature do
      user_type { 'ES' }
    end

    factory :professor_supervisor_signature do
      user_type { 'PS' }
    end

    factory :academic_signature_signed do
      user_type { 'AC' }
      status { true }
    end

    factory :external_member_signature_signed do
      user_type { 'ES' }
      status { true }
    end
  end
end
