# frozen_string_literal: true

# Model for the users
class User < ApplicationRecord
  has_many :donated_pickups, class_name: 'Pickup', foreign_key: 'donor_id'
  has_many :received_pickups, class_name: 'Pickup', foreign_key: 'receiver_id'
  has_many :donated_requests, class_name: 'Request', foreign_key: 'donor_id'
  has_many :received_requests, class_name: 'Request', foreign_key: 'receiver_id'
  has_many :time_slots, class_name: 'TimeSlot', foreign_key: 'donor_id'
  has_many :items
  has_many :reviews, foreign_key: 'user_id'
  has_many :received_reviews, class_name: 'Review', foreign_key: 'donor_id'
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.will_save_change_to_address? }

  # for chat feature
  has_many :messages, dependent: :destroy

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_initialize
    names = auth['info']['name'].split

    # Update the user's attributes
    user.update(
      email: auth.info.email,
      first: names[0],
      last: names[1..].join(' ')
    )

    # Save the user
    user.save

    user
  end
end
