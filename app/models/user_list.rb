class UserList < ActiveRecord::Base
  MIN_RATING = 0
  MAX_RATING = 5

  before_validation :fix_rating!

  belongs_to :user
  belongs_to :list

  validates :user_id, presence:true, numericality: { only_integer: true }
  validates :list_id, presence:true, numericality: { only_integer: true }
  validates :rating, numericality: { only_integer: true }

  private
  def fix_rating!
    if self.rating < MIN_RATING
      self.rating = MIN_RATING
    elsif self.rating > MAX_RATING
      self.rating = MAX_RATING
    end
  end
end
