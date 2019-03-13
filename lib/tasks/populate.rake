namespace :db do
  desc 'Erase and fill database'

  task populate: :environment do
    require 'faker'
    require 'cpf_cnpj'

    [Academic, Institution, ExternalMember].each(&:delete_all)
    Professor.where.not(username: 'marczal').destroy_all

    100.times do
      Academic.create(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        ra: Faker::Number.number(7),
        gender: Academic.genders.values.sample,
        password: '123456',
        password_confirmation: '123456'
      )
    end

    100.times do |index|
      Professor.create(
        name: Faker::Name.name,
        email: "professor#{index}@gmail.com",
        username: "professor#{index}",
        gender: Professor.genders.values.sample,
        lattes: "http://lattes.com.#{index}",
        is_active: Faker::Boolean.boolean,
        available_advisor: Faker::Boolean.boolean,
        working_area: Faker::Markdown.headers,
        professor_type_id: ProfessorType.pluck(:id).sample,
        professor_title_id: ProfessorTitle.pluck(:id).sample,
        password: '123456',
        password_confirmation: '123456'
      )
    end

    100.times do |index|
      ExternalMember.create(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        is_active: Faker::Boolean.boolean,
        working_area: Faker::Markdown.headers,
        gender: Academic.genders.values.sample,
        personal_page: "http://page.com.#{index}",
        professor_title_id: ProfessorTitle.pluck(:id).sample,
        external_member_type_id: ExternalMemberType.pluck(:id).sample
      )
    end

    100.times do
      Institution.create(
        name: Faker::Company.name,
        trade_name: Faker::Company.buzzword,
        cnpj: CNPJ.generate,
        external_member_id: ExternalMember.pluck(:id).sample
      )
    end
  end
end
