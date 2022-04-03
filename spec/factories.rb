FactoryBot.define do
  factory :course do
    name { Faker::Hobby.activity }
    lecturer { Faker::Name.name }
    description { Faker::Lorem.sentence }
  end

  factory :chapter do
    name { Faker::Hobby.activity }
  end

  factory :unit do
    name { Faker::Hobby.activity }
    description { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
  end
end
