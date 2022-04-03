require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  describe 'GET /index' do
    before do
      course = FactoryBot.create(:course)
      chapter = FactoryBot.create(:chapter, course: course)
      FactoryBot.create_list(:unit, 3, chapter: chapter)

      get '/api/v1/courses'
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
    
    it 'returns all courses' do
      expect(json["courses"].count).to eq(1)
    end

    it 'check first course record' do
      expect(json["courses"].first["name"]).to eq(Course.first.name)
      expect(json["courses"].first["chapters"].count).to eq(1)
      expect(json["courses"].first["chapters"].first["name"]).to eq(Chapter.first.name)
      expect(json["courses"].first["chapters"].first["units"].count).to eq(3)
      expect(json["courses"].first["chapters"].first["units"].first["position"]).to eq(1)
    end


  end
end
