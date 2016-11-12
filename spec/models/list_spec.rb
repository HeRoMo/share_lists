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

  describe "#add_fan" do
    let(:list){
      list = create(:list, {owner: @user})
      list.fans << @user
      list
    }
    it "increase fan" do
      user = create(:user)
      expect{
        list.add_fan(user, 5)
      }.to change(list.fans, :count).by(1)
      expect(list.user_lists.find_by(user_id:user.id).rating).to be 5
    end
    it "duplicate add_fan, updating rating" do
      user = create(:user)
      list.add_fan(user, 5)
      expect{
        list.add_fan(user, 3)
      }.to change(list.fans, :count).by(0)
      expect(list.user_lists.find_by(user_id:user.id).rating).to be 3
    end
  end

  describe "#fan?" do
    before do
      @list = create(:list, {owner: @user})
      @a_fan = create(:user)
      @list.fans << @a_fan
    end

    it "with fan" do
      expect(@list.fan? @a_fan).to be true
    end
    it "with not fan" do
      expect(@list.fan? @user).to be false
    end
  end

  describe "#remove_fan" do
    let(:list){
      list = create(:list, {owner: @user})
      list.fans << @user
      list
    }

    it "decrease fan" do
      expect{
        list.remove_fan(@user)
      }.to change(list.fans, :count).by(-1)
    end
  end

  describe "#rate_of" do
    let(:list){
      list = create(:list, {owner: @user})
      list.add_fan(@user,4)
      @other = create(:user)
      list.add_fan(@other,2)
      list
    }
    it "rating of fan" do
      expect(list.rating_of(@user)).to be 4
      expect(list.rating_of(@other)).to be 2
    end
    it "rating of not fan" do
      another = create(:user)
      expect(list.rating_of(another)).to be 0
    end
  end
end
