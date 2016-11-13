require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do

  describe "#gravetor_icon" do
    let(:email){ 'gravator@sample.com' }
    let(:options){{}}
    subject{
      user = User.new({email:email})
      gravator_icon(user, options)
    }
    context "without options" do
      it{
        expect(
          subject=~/<img src="https:\/\/www.gravatar.com\/avatar\/[a-z0-9]+" alt="[a-z0-9]+" \/>/
        ).to be_truthy
      }
    end

    context "with size options" do
      let(:options){{size:50}}
      it{
        puts subject
        expect(
            subject=~/<img src="https:\/\/www.gravatar.com\/avatar\/[a-z0-9]+\?s=50" alt="[a-z0-9]+\?s=50" \/>/
        ).to be_truthy
      }
    end
  end
end
