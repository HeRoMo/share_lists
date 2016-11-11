require 'rails_helper'

RSpec.describe List, type: :model do

  before(:all) do
    @user = create(:user)
  end
  after(:all) do
    @user.destroy
  end

  describe "#create" do
    it 'valid' do
      expect{
        List.create(
            { title: 'hoge',
              items: 'fuga',
              owner: @user }
        )
      }.to change(List, :count).by(1)
    end
  end
  describe "#item_array" do
    it {
      list = create(:list,{
          owner: @user,
          items: "item-1\nitem-2\nitem-3"
      })
      expect(list.item_array.length).to be 3
    }

  end
  describe "#destroy" do
    it "delete single list" do
      list = create(:list,{owner: @user})
      expect{
        list.destroy
      }.to change(List, :count).by(-1)
    end
    it "delete user with list" do
      owner = create(:user, email:'owner@email.com')
      create_list(:list, 20, {owner: owner})
      expect{ owner.destroy }.to change(List,:count).by(-20)
    end
  end
end
