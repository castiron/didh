class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments

  def screen_name
    if self.alias
      self.alias
    elsif self.name
      self.name
    else
      'no name'
    end

  end

end
