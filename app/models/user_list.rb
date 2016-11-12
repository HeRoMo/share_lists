class UserList < ActiveRecord::Base

  belongs_to :fan, foreign_key: :id, class_name: 'User'
  belongs_to :favorite_list, foreign_key: :id, class_name: 'List'
end
