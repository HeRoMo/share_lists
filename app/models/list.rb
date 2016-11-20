# List
class List < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :user_lists ,dependent: :destroy
  has_many :fans ,through: :user_lists, source: :user

  validates :title, presence: true
  validates :items, presence: true
  validates :owner, presence: true

  default_scope -> { includes(:owner) }

  # items の値をリストで取得する
  # 改行コード区切りでリスト化された値を得る
  # @return [Array] item [String] のリスト
  def item_array
    items.split("\n");
  end

  # user がリストのファンか判定する
  #
  # @return [Boolean] ファンである時 true、それ以外はfalse
  def fan?(user)
    fans.include? user
  end

  # fan にuser を追加する。
  # すでにuser が fan であるときは rate の更新のみ行う
  # @param
  def add_fan(user, rating = 0)
    ul = user_lists.find_by(user_id:user.id)||UserList.new(user:user, list:self)
    ul.rating = rating
    ul.save!
  end

  # fan から user を削除する
  # @param [User] ユーザ
  def remove_fan(user)
    self.fans.delete(user)
  end

  def rating_of(user)
    ul = user_lists.find_by(user_id:user.id)
    (ul.present?)? ul.rating : 0
  end
end
