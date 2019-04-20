require 'rails_helper'

describe 'Activity::index', type: :feature do
  describe '#index' do
    context 'when shows all activities with tcc 1' do
      it 'shows all activities with tcc 1 options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        calendar = create(:calendar_tcc_two)
        activity = create(:activity_tcc_two, calendar: calendar)

        visit responsible_calendar_activities_tcc_two_index_path(calendar)

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       short_date(activity.created_at)])
      end
    end
  end
end
