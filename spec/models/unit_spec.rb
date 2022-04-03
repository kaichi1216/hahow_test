require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe "validate columns" do

    it 'validate unit column' do
      unit = Unit.new
      unit.valid?
      expect(unit.errors.any?).to eq (true)
      expect(unit.errors.full_messages.include?("Name can't be blank")).to be (true)
      expect(unit.errors.full_messages.include?("Content can't be blank")).to be (true)
    end
  end
end
