class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :answer_games, through: :games
  has_many :games
  has_many :decks, through: :games
  validates :email, uniqueness: true, :presence => true
  validates :password, :presence => true


  def self.autentic(email, password) 
   User.find_by(email: email, password: password)
  end
end

