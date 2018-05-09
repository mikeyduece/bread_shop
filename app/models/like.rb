# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  validates :user_id, presence: true
  validates :recipe_id, presence: true

  # include StreamRails::Activity
  # as_activity

  # def activity_notify
  #   [StreamRails.feed_manager.get_notification_feed(recipe_id)]
  # end

  # def activity_object
  #   target = Recipe.find(recipe_id)
  # end
end
