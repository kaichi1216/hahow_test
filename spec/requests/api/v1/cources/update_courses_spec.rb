require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  describe "PATCH /update" do
    let!(:course) { FactoryBot.create(:course) }

    before do
      chapter = FactoryBot.create(:chapter, course: course)
      FactoryBot.create_list(:unit, 3, chapter: chapter)
    end

    context 'success to update course name column' do
      before do
        patch "/api/v1/courses/#{course.id}", params:
        {
          course:{
            name: "course1"
          }
        }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
        expect(Course.first.name).to eq ("course1")
      end
    end

    context 'unsuccess to update course name' do
      before do
        patch "/api/v1/courses/#{course.id}", params:
        {
          course:{
            name: ""
          }
        }
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(:not_acceptable)
        expect(json["errors"].first).to eq("Name can't be blank")
        expect(Course.first.name).not_to eq ("")
      end
    end

    context 'success to update chapter name and unit name columns' do
      before do
        chapter = course.chapters.first
        unit = course.units.second

        patch "/api/v1/courses/#{course.id}", params:
        {
          course:{
            chapters_attributes: [
              {
                id: chapter.id,
                name: "chapter1",
                units_attributes: [
                  {
                    id: unit.id,
                    content: "unit content"
                  }
                ]
              }
            ]
          }
        }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
        expect(course.chapters.first.name).to eq ("chapter1")
        expect(course.units.second.content).to eq ("unit content")
      end
    end

    context 'success to update chapter and unit(chapter qunaity is 1, unit quantity is 3)' do
      before do
        patch "/api/v1/courses/#{course.id}", params:
        {
          course:{
            chapters_attributes: [
              {
                name: Faker::Hobby.activity,
                units_attributes: [
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

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
        expect(course.chapters.count).to eq (2)
        expect(course.units.count).to eq (4)
      end
    end

    context 'success to update chapter and unit position' do
      before do
        chapter = FactoryBot.create(:chapter, course: course)
        FactoryBot.create_list(:unit, 3, chapter: chapter)

        patch "/api/v1/courses/#{course.id}", params:
        {
          course:{
            chapters_attributes: [
              {
                id: course.chapters.first.id,
                name: "change position to second",
                position: 2,
                units_attributes: [
                  {
                    id: course.units.first.id,
                    name: "change position to third",
                    position: 3
                  }
                ]
              }
            ] 
          }
        }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
        expect(course.chapters.second.name).to eq ("change position to second")
        expect(course.chapters.second.units.third.name).to eq ("change position to third")
      end
    end
  end
end
