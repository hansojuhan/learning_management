class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  # Deleted registrable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable


end
