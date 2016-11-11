# List
class List < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'

  validates :title, presence: true
  validates :items, presence: true
  validates :owner, presence: true

  def item_array
    items.split("\n");
  end
end
