require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "validate columns" do

    it 'validate course column' do
      course = Course.new
      course.valid?
      expect(course.errors.any?).to eq (true)
      expect(course.errors.full_messages.include?("Name can't be blank")).to be (true)
      expect(course.errors.full_messages.include?("Lecturer can't be blank")).to be (true)
    end
  end
end
