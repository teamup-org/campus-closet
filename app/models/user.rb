# frozen_string_literal: true

# Model for the users
class User < ApplicationRecord
  has_many :donated_pickups, class_name: 'Pickup', foreign_key: 'donor_id', dependent: :destroy
  has_many :received_pickups, class_name: 'Pickup', foreign_key: 'receiver_id', dependent: :destroy
  has_many :donated_requests, class_name: 'Request', foreign_key: 'donor_id', dependent: :destroy
  has_many :received_requests, class_name: 'Request', foreign_key: 'receiver_id', dependent: :destroy
  has_many :time_slots, class_name: 'TimeSlot', foreign_key: 'donor_id', dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :reviews, foreign_key: 'user_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', foreign_key: 'donor_id', dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.will_save_change_to_address? }

  # for chat feature
  has_many :messages, dependent: :destroy

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, unless: -> { password.blank? }
  validates :password_confirmation, presence: true, if: -> { password.present? }

  def self.from_omniauth(auth)
    return nil if auth.nil?

    user = where(email: auth.info.email).first_or_initialize do |u|
      names = auth['info']['name'].split
      u.first = names[0]
      u.last = names[1..].join(' ')
      u.password = SecureRandom.hex(10)
    end

    user.save
    user
  end
end
