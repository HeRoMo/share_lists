require 'rails_helper'

RSpec.describe UserList, type: :model do

  describe "#fix_rating!" do
    it "valid rate" do
      ul = UserList.create(user_id:1, list_id:1, rating: 3)
      expect(ul.rating).to eq 3
    end

    context "minus rate fixed to 0" do
      it{
        ul = UserList.create(user_id:1, list_id:1, rating: -1)
        expect(ul.rating).to eq 0
      }
    end

    context "big rate fixed to 5" do
      it{
        ul = UserList.create(user_id:1, list_id:1, rating: 10)
        expect(ul.rating).to eq 5
      }
    end
  end
end
