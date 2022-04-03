require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe "validate columns" do

    it 'validate chapter column' do
      chapter = Chapter.new
      chapter.valid?
      expect(chapter.errors.any?).to eq (true)
      expect(chapter.errors.full_messages.include?("Name can't be blank")).to be (true)
    end
  end
end
