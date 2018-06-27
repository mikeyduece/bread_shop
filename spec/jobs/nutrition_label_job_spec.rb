require 'rails_helper'

RSpec.describe NutritionLabelJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class).on_queue('default')
  end

  it 'is in default queue' do
    expect(NutritionLabelJob.new.queue_name).to eq('default')
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
