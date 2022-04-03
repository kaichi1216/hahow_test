require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  describe 'POST /create' do

    context 'success to create' do
      before do
        post '/api/v1/courses', params:
        {
          course:{
            name: Faker::Hobby.activity,
            lecturer: Faker::Name.name,
            description: Faker::Lorem.sentence,
            chapters_attributes: [
              {
                name: Faker::Hobby.activity,
                units_attributes: [
                  {
                    name: Faker::Hobby.activity,
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence
                  },
                  {
                    name: Faker::Hobby.activity,
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence
                  }
                ]
              }
            ]
          }
        }
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'create fail, chapter and unit cant be empty' do
      before do
        post '/api/v1/courses', params:
        {
          course:{
            name: Faker::Hobby.activity,
            lecturer: Faker::Name.name,
            description: Faker::Lorem.sentence
          }
        }
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(:not_acceptable)
      end

      it 'return chapter and unit must be present' do
        expect(json["errors"].count).to eq (2) 
        expect(json["errors"].first).to eq ("Chapter must be present")
        expect(json["errors"].last).to eq ("Unit must be present")
      end
    end

    context 'create fail, unit cant be empty' do
      before do
        post '/api/v1/courses', params:
        {
          course:{
            name: Faker::Hobby.activity,
            lecturer: Faker::Name.name,
            description: Faker::Lorem.sentence,
            chapters_attributes: [
              name: Faker::Hobby.activity
            ]
          }
        }
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(:not_acceptable)
      end

      it 'return unit must be present' do
        expect(json["errors"].count).to eq (1) 
        expect(json["errors"].first).to eq ("Unit must be present")
      end
    end

    context 'create fail, column need be present' do
      before do
        post '/api/v1/courses', params:
        {
          course:{
            name: "",
            lecturer: "",
            description: Faker::Lorem.sentence,
            chapters_attributes: [
              {
                name: Faker::Hobby.activity,
                units_attributes: [
                  {
                    name: Faker::Hobby.activity,
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence
                  },
                  {
                    name: Faker::Hobby.activity,
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence
                  }
                ]
              }
            ]
          }
        }
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(:not_acceptable)
      end

      it 'return course name and lecturer must be present error message' do
        expect(json["errors"].first).to eq ("Name can't be blank")
        expect(json["errors"].last).to eq ("Lecturer can't be blank")
      end
    end

    context 'create fail, tables column need be present' do
      before do
        post '/api/v1/courses', params:
        {
          course:{
            name: "",
            lecturer: "",
            description: Faker::Lorem.sentence,
            chapters_attributes: [
              {
                name: "",
                units_attributes: [
                  {
                    name: "",
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence
                  },
                  {
                    name: Faker::Hobby.activity,
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence
                  }
                ]
              }
            ]
          }
        }
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(:not_acceptable)
      end

      it 'return course name and lecturer、chapter name、unit name must be present error message' do
        expect(json["errors"].count).to eq (4)
      end
    end

    context 'create success, check query first course relation first unit name eq unit1' do
      before do
        post '/api/v1/courses', params:
        {
          course:{
            name: Faker::Hobby.activity,
            lecturer: Faker::Name.name,
            description: Faker::Lorem.sentence,
            chapters_attributes: [
              {
                name: Faker::Hobby.activity,
                units_attributes: [
                  {
                    name: Faker::Hobby.activity,
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence
                  },
                  {
                    name: "unit1",
                    description: Faker::Lorem.sentence,
                    content: Faker::Lorem.sentence,
                    position: 1
                  }
                ]
              }
            ]
          }
        }
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(:created)
      end

      it 'check units first record name' do
        expect(Course.first.chapters.first.units.first.name).to eq ("unit1")
      end
    end

  end
end
