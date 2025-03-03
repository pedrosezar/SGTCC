require 'rails_helper'

describe 'Calendar::index', type: :feature, js: true do
  let(:professor) { create(:professor_tcc_one) }
  let!(:calendars) { create_list(:calendar_tcc_one, 3) }
  let!(:current_calendar_tcc_one) { create(:current_calendar_tcc_one) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index' do
    it 'shows all the tcc one calendars' do
      index_url = tcc_one_professors_calendars_tcc_one_path
      visit index_url

      calendars.each do |calendar|
        expect(page).to have_link(calendar.year_with_semester,
                                  href: tcc_one_professors_calendar_activities_path(calendar))
        expect(page).to have_contents([short_date(calendar.created_at)])
      end
      expect(page).to have_selector("a[href='#{index_url}'].active")
    end

    it 'shows the orientations by calendar' do
      orientation = create(:orientation, calendars: [current_calendar_tcc_one])
      index_url = tcc_one_professors_calendar_orientations_path(current_calendar_tcc_one)
      visit index_url

      expect(page).to have_content(orientation.short_title)
      expect(page).to have_content(orientation.advisor.name)
      expect(page).to have_content(orientation.academic.name)

      orientation.calendars.each do |calendar|
        expect(page).to have_content(calendar.year_with_semester_and_tcc)
      end

      expect(page).to have_selector("a[href='#{index_url}'].active")
    end
  end
end
