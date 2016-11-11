require 'rails_helper'

RSpec.describe "lists/show", type: :view do
  before(:each) do
    owner = create(:user)
    @list = assign(:list, create(:list, {owner:owner}))
  end

  it "renders attributes in <p>" do
    render
  end
end
