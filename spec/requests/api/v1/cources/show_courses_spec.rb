require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  describe 'GET /show' do
    let!(:course) { FactoryBot.create(:course) }

    before do
      chapter = FactoryBot.create(:chapter, course: course)
      FactoryBot.create_list(:unit, 3, chapter: chapter)
      get "/api/v1/courses/#{course.id}"
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
    
    it 'returns course relation record' do
      expect(json["course"]["id"]).to eq(course.id)
    end
  end
end
