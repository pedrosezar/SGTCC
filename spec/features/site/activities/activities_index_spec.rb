require 'rails_helper'

describe 'Site::calendar', :js, type: :feature do
  before do
    create(:page, url: 'calendario')
  end

  describe '#index' do
    let!(:calendar_tcc_one) { create(:current_calendar_tcc_one) }
    let!(:activity_tcc_one) { create(:activity_tcc_one, calendar: calendar_tcc_one) }
    let!(:calendar_tcc_two) { create(:current_calendar_tcc_two) }
    let!(:activity_tcc_two) { create(:activity_tcc_two, calendar: calendar_tcc_two) }

    before do
      visit site_calendar_path
    end

    it 'shows all activities for tcc one' do
      within('table.tcc_one') do
        expect(page).to have_contents([activity_tcc_one.name,
                                       activity_tcc_one.deadline])
      end
    end

    it 'shows all activities for tcc two' do
      visit site_calendar_path

      within('table.tcc_two') do
        expect(page).to have_content(activity_tcc_two.name)
        expect(page).to have_content(activity_tcc_two.deadline)
      end
    end

    it 'shows icon to info activities' do
      activity_tcc_one.update(base_activity_type: create(:base_activity_type_info))

      visit site_calendar_path

      within('table.tcc_one') do
        expect(page).to have_css('i.fas.fa-info')
      end
    end

    it 'shows icon to send document activities' do
      visit site_calendar_path

      within('table.tcc_one') do
        expect(page).to have_css('i.fas.fa-file-upload')
      end
    end

    it 'active calendar link' do
      expect(page).to have_selector("a[href='#{site_calendar_path}'].active")
    end
  end
end
