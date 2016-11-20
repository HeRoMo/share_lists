require 'rails_helper'

RSpec.describe "lists/index", type: :view do
  before(:each) do
    owner = create(:user)
    assign(:lists, create_list(:list, 2, {owner:owner}))
  end

  pending "renders a list of lists" do
    render
  end
end
