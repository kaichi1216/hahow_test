require 'rails_helper'

RSpec.describe CreateCourseForm do
  describe "check form object" do

    it 'validate course、chapter、unit has limit once record' do
      course = Course.new(name: 'test course", lecturer: "Mr.Chang')
      course.chapters.new(name: 'test chapter')
      course.chapters.first.units.new(name: 'test unit', content: "content")
      form = CreateCourseForm.new(record: course)

      form.valid?

      expect(form.errors.any?).to eq (false)
      expect(form.record.chapters.length).to eq (1)
      expect(form.record.chapters.first.units.length).to eq (1)
    end

    it 'validate chapter、unit record' do
      course = Course.new(name: 'test course", lecturer: "Mr.Chang')
      form = CreateCourseForm.new(record: course)

      form.valid?

      expect(form.errors.any?).to eq (true)
      expect(form.errors.full_messages.count).to eq (2)
      expect(form.errors.full_messages).to eq (["Chapter must be present", "Unit must be present"])
    end

    it 'validate unit record' do
      course = Course.new(name: 'test course", lecturer: "Mr.Chang')
      course.chapters.new(name: 'test chapter')
      form = CreateCourseForm.new(record: course)

      form.valid?

      expect(form.errors.any?).to eq (true)
      expect(form.errors.full_messages.count).to eq (1)
      expect(form.errors.full_messages).to eq (["Unit must be present"])
    end
  end
end
