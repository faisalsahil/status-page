class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :user_type, :time_zone, :history, :tweetformat, :tweetincidentformat, :emailsubjectformat, :emailbodyformat, :emailsubjectincidentformat, :emailbodyincidentformat
  # attr_accessible :title, :body
  has_one :customizepage

  # validates_presence_of :username
  has_many :incidents
  has_many :components
  has_many :datasources
  has_many :statuses
  has_many :subscribers
  has_many :states

  has_many :clients

  has_one :payment


  def self.from_omniauth(auth)
    user = where(auth.slice("uid")).first || create_from_omniauth(auth)
    user.oauth_token = auth["credentials"]["token"]
    user.oauth_secret = auth["credentials"]["secret"]
    user.save!
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.uid_twitter = auth["uid"]
      user.name_twitter = auth["info"]["nickname"]
    end
  end

  def twitter
   
    @twitter ||= Twitter::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_secret)

  end

end
