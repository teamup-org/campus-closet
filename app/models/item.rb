# frozen_string_literal: true

# /models
class Item < ApplicationRecord
  belongs_to :color
  belongs_to :type
  belongs_to :gender
  belongs_to :status
  belongs_to :size
  belongs_to :condition
  has_one_attached :image
  has_many :pickups
  has_many :requests
  belongs_to :user
  has_one :chatroom, dependent: :destroy

  def self.search(query)
    keywords = query.downcase.split(/\s+/)

    items = Item.joins(:color, :type, :gender, :size, :condition)

    where_clause = keywords.map do |keyword|
      "(LOWER(colors.name) LIKE '%#{keyword}%' OR LOWER(types.name) LIKE '%#{keyword}%' OR LOWER(genders.name) LIKE '%#{keyword}%' OR LOWER(sizes.name) LIKE '%#{keyword}%' OR LOWER(conditions.name) LIKE '%#{keyword}%')"
    end.join(" AND ")

    items = items.where(where_clause).distinct

    items
  end
end
