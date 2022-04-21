class Course < ApplicationRecord
  has_many :chapters, -> { order 'chapters.position ASC' }, dependent: :destroy, inverse_of: :course
  has_many :units, through: :chapters
  accepts_nested_attributes_for :chapters, allow_destroy: true

  validates_presence_of :name, :lecturer
end
