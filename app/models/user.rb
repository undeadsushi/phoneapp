class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  # attr_accessor :name, :email, :password, :password_confirmation, :provider, :uid

has_many :receipts


  def self.find_for_facebook_oauth(auth)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        pass = Devise.friendly_token[0,20]
        user = User.new(name: auth.extra.raw_info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email,
                           password: pass,
                           password_confirmation: pass
                          )
        user.skip_confirmation!
        user.save
      end
      user
  end
end

