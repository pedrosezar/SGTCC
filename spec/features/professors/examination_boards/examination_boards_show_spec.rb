require 'rails_helper'

describe 'ExaminationBoard::show', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientation) { create(:orientation, advisor: professor) }
  let!(:examination_board) { create(:proposal_examination_board, orientation: orientation) }

  before do
    create(:document_type_adpp)
    examination_board.professors << professor
    login_as(professor, scope: :professor)
    visit professors_examination_board_path(examination_board)
  end

  describe '#show' do
    context 'when shows the examination_board' do
      it 'shows the examination board' do
        expect(page).to have_contents([examination_board.orientation.title,
                                       examination_board.orientation.academic_with_calendar,
                                       examination_board.orientation.advisor.name_with_scholarity,
                                       examination_board.place,
                                       complete_date(examination_board.date),
                                       complete_date(examination_board.created_at),
                                       complete_date(examination_board.updated_at)])

        examination_board.professors.each do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end

        examination_board.external_members.each do |external_member|
          expect(page).to have_content(external_member.name_with_scholarity)
        end
      end
    end

    context 'when generates the non attendance defense minutes', js: true do
      it 'shows the view defense minutes button' do
        find('#generate_non_attendance_defense_minutes').click
        expect(page).to have_alert(text: 'Você tem certeza que deseja gerar a Ata de Defesa')

        find('.swal-button--confirm', match: :first).click # confirmation
        expect(page).to have_alert(text: 'Ata de Defesa gerada com sucesso!')

        find('.swal-button--confirm', match: :first).click # success message
        expect(page).to have_link(text: 'Visualizar Ata de Defesa')

        find('#view_defense_minutes').click

        examination_board.reload
        expect(page).to have_contents([examination_board.academic_document_title,
                                       orientation.academic.name,
                                       orientation.advisor.name_with_scholarity,
                                       document_date(examination_board.date),
                                       document_date(Document.first.created_at),
                                       examination_board.situation_translated])

        orientation.supervisors do |supervisor|
          expect(page).to have_content(supervisor.name_with_scholarity)
        end

        examination_board.professors do |professor|
          expect(page).to have_content(professor.name_with_scholarity)
        end
      end
    end

    context 'when shows the academic activity' do
      let(:academic) { orientation.academic }
      let(:academic_activity) { examination_board.academic_activity }

      before do
        create(:proposal_academic_activity, academic: academic,
                                            calendar: orientation.calendars.first)
        visit professors_examination_board_path(examination_board)
      end

      it 'shows the academic activity' do
        expect(page).to have_contents([academic.name,
                                       academic_activity.title,
                                       academic_activity.summary])

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url)])
      end
    end
  end
end
