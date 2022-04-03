class ActsAsListGemAddPositionColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters , :position , :integer
    add_column :units , :position , :integer
  end
end
