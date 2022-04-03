class Unit < ApplicationRecord
  belongs_to :chapter

  #'acts_as_list' gem provide method
  acts_as_list scope: :chapter

  validates_presence_of :name
  validates_presence_of :content
end
