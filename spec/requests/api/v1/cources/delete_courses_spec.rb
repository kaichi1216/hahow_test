require 'rails_helper'

RSpec.describe 'Courses', type: :request do
  describe "DELETE /destroy" do
    let!(:course) { FactoryBot.create(:course) }

    before do
      chapter = FactoryBot.create(:chapter, course: course)
      FactoryBot.create_list(:unit, 3, chapter: chapter)
      delete "/api/v1/courses/#{course.id}"
    end

    it 'returns status code 202' do
      expect(response).to have_http_status(:accepted)
      expect(Course.count).to eq (0)
      expect(Chapter.count).to eq (0)
      expect(Unit.count).to eq (0)
    end
  end
end
