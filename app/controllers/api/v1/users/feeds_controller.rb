# frozen_string_literal: true

class Api::V1::Users::FeedsController < Api::V1::ApplicationController
  before_action :authenticate_user!
  before_action :create_enricher

  def user
    feed = StreamRails.feed_manager.get_user_feed(current_user.id)
    results = feed.get['results']
    activities = @enricher.enrich_activities(results)
    render(json: activities)
  end

  def flat
    results_stream(:flat)
    # feed = StreamRails.feed_manager.get_news_feeds(current_user.id)[:flat]
    # results = feed.get['results']
    # activities = @enricher.enrich_activities(results)
    # render(json: activites)
  end

  def aggregated
    feed = StreamRails.feed_manager.get_news_feeds(current_user.id)[:aggregated]
    results = feed.get['results']
    activities = @enricher.enrich_aggregated_activities(results)
    render(json: activities)
  end

  def notification
    feed = StreamRails.feed_manager.get_notification_feed(current_user.id)
    results = feed.get['results']
    activities = @enricher.enrich_aggregated_activities(results)
    render(json: activities)
  end

  private

  def create_enricher
    @enricher = StreamRails::Enrich.new
  end

  def results_stream(feed_type)
    feed = StreamRails.feed_manager.get_news_feeds(current_user.id)[feed_type]
    results = feed.get['results']
    activities = @enricher.enrich_activities(results)
    render(json: activities)
  end
end
