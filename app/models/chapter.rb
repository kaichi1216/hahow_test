class Chapter < ApplicationRecord
  belongs_to :course
  has_many :units, -> { order 'units.position ASC' }, dependent: :destroy, inverse_of: :chapter
  accepts_nested_attributes_for :units

   #'acts_as_list' gem provide method
  acts_as_list scope: :course

  validates_presence_of :name
end
