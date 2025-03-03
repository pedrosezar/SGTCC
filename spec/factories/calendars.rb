FactoryBot.define do
  tccs = Calendar.tccs.values
  current_year = Calendar.current_year
  current_semester = Calendar.current_semester
  tcc_one = tccs.first
  tcc_two = tccs.last

  factory :calendar do
    extend FactoryBotEnhancements
    change_factory_to_find_or_create

    sequence(:year) { |n| Faker::Number.unique.number(digits: 4) || "20#{n}" }
    sequence(:semester) { tccs.first || tccs.last }
    tcc { tccs.sample }

    before :create do
      create_list(:base_activity_tcc_one, 2)
      create_list(:base_activity_tcc_two, 2)
    end

    before :destroy do
      activities.destroy_all
    end

    factory :current_calendar do
      year { current_year }
      semester { current_semester }
    end

    factory :current_calendar_tcc_one do
      year { current_year }
      semester { current_semester }
      tcc { tcc_one }
    end

    factory :current_calendar_tcc_two do
      year { current_year }
      semester { current_semester }
      tcc { tcc_two }
    end

    factory :previous_calendar_tcc_one do
      year { current_semester == 2 ? current_year : current_year.to_i - 1 }
      semester { current_semester == 1 ? current_semester + 1 : current_semester - 1 }
      tcc { tcc_one }
    end

    factory :previous_calendar_tcc_two do
      year { current_semester == 2 ? current_year : current_year.to_i - 1 }
      semester { current_semester == 1 ? current_semester + 1 : current_semester - 1 }
      tcc { tcc_two }
    end

    factory :calendar_tcc_one do
      tcc { tcc_one }
    end

    factory :calendar_tcc_two do
      tcc { tcc_two }
    end
  end
end
