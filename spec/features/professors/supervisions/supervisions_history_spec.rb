require 'rails_helper'

describe 'Supervision::index', type: :feature do
  let(:professor) { create(:professor) }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the supervisions' do
      it 'shows all the supervisions' do
        orientation = create(:current_orientation_tcc_one)
        orientation.professor_supervisors << professor

        index_url = professors_supervisions_history_path
        visit index_url

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_link(orientation.academic.name,
                                  href: professors_supervision_path(orientation))

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end

        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
