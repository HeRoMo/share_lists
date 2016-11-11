require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#create' do
    let(:email){'valid@email.com'}
    let(:password){'password'}
    context 'valid params' do
      it {
        expect{
          User.create({
              email: email,
              password: password,
              password_confirmation: password
          })
        }.to change(User, :count).by(1)
      }
    end
    context 'without email' do
      let(:email){nil}
      it {
        expect{
          User.create({
              email: email,
              password: password,
              password_confirmation: password
          })
        }.to change(User, :count).by(0)
      }
    end
    context 'different password_confirmation' do
      it {
        expect{
          User.create({
              email: email,
              password: password,
              password_confirmation: "different"
          })
        }.to change(User, :count).by(0)
      }
    end
  end

  describe '#update' do
    let(:new_email){'new@email.com'}
    let(:new_password){'new_password'}
    context 'update email only' do
      subject{
        user = create :user
        user.update!({email:new_email})
        user
      }
      it {expect(subject.changed?).to be false}
      it {expect(subject.persisted?).to be true}
      it {expect(subject.created_at).not_to eq subject.updated_at}
    end
    context 'update password' do
      subject{
        user = create :user
        user.update!({password:new_password, password_confirmation: new_password})
        user
      }
      it{expect(subject.changed?).to be false}
      it{expect(subject.persisted?).to be true}
    end
  end

  describe '#destory' do
    it{
      user = create :user
      expect{
        user.delete
      }.to change(User, :count).by(-1)
    }
    it {
      user = create :user
      user.delete
      expect(user.destroyed?).to be true
    }

  end
end
