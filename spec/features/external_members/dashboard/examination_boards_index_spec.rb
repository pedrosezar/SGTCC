require 'rails_helper'

describe 'ExaminationBoard::index', type: :feature, js: true do
  let(:external_member) { create(:external_member) }
  let!(:examination_boards) { create_list(:examination_board_tcc_one, 2) }

  before do
    examination_boards.each do |examination_board|
      examination_board.external_members << external_member
    end
    login_as(external_member, scope: :external_member)
    visit external_members_root_path
  end

  describe '#index' do
    context 'when shows the examination boards' do
      it 'shows the examination boards' do
        examination_boards.each do |examination_board|
          expect(page).to have_link(examination_board.orientation.academic_with_calendar,
                                    href: external_members_examination_board_path(
                                      examination_board
                                    ))
          expect(page).to have_contents([examination_board.orientation.advisor.name_with_scholarity,
                                         examination_board.place,
                                         datetime(examination_board.date)])
        end
      end
    end
  end
end
