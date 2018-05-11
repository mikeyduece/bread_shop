# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :target, class_name: 'User'
  belongs_to :recipe

  validates :user_id, presence: true
  validates :target_id, presence: true
  validates :recipe_id, presence: true

  include StreamRails::Activity
  as_activity

  def activity_notify
    [StreamRails.feed_manager.get_notification_feed(target_id)]
  end

  def activity_object
    self.recipe
  end
end
