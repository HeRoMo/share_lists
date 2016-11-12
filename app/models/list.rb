# List
class List < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :user_lists,dependent: :destroy
  has_many :fans, foreign_key: :list_id ,through: :user_lists

  validates :title, presence: true
  validates :items, presence: true
  validates :owner, presence: true

  def item_array
    items.split("\n");
  end
end
