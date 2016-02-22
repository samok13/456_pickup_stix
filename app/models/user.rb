class User < ActiveRecord::Base
  has_many :bookmarks, dependent: :destroy
  has_many :playlists, dependent: :destroy

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true

  has_secure_password
   validates :password, 
            :length => { :in => 8..24 }, 
            :allow_nil => true

  def name 
    "#{@first_name} #{@last_name}"
  end          
end
