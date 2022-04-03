class CreateCourseForm
  include ActiveModel::Validations

  attr_reader :record
  attr_accessor :course
  attr_accessor :chapter
  attr_accessor :unit

  validate :check_all

  def initialize(params = {})
    @record = params.delete(:record)
  end

  private

  def check_all
    errors.generate_message(:course, :not_blank, message: "must be present") if record.blank?
    if record.chapters.empty?
      errors.add(:chapter, :not_empty, message: "must be present")
      errors.add(:unit, :not_empty, message: "must be present")
    end
    errors.add(:unit, :not_empty, message: "must be present") if record.chapters.any? { |chapter| chapter.units.empty? }
  end
end