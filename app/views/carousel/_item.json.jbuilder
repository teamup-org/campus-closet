# frozen_string_literal: true

json.extract! item, :id, :color_id, :type_id, :gender_id, :description, :status_id, :size_id, :condition_id,
              :created_at, :updated_at
json.url item_url(item, format: :json)
