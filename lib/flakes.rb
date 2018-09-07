require "active_job"
require "active_model"

class Flake < ActiveJob::Base
  class Error < StandardError
  end

  # alias ActiveJob::Core#initialize before it is overwritten by ActiveModel::Model
  alias_method :active_job_initialize, :initialize

  include ::ActiveModel::Model

  def self.execute(args = {})
    new(args).execute
  end

  def self.execute_later(args = {})
    options = {}
    options[:wait] = args.delete(:wait) if args.key?(:wait)

    # initialize ActiveJob::Core only when Flake is enqueued to prevent conflics with ActiveModel::Model
    flake = new
    flake.send(:active_job_initialize, args)

    if queue_adapter.class.name.demodulize == "InlineAdapter"
      flake.enqueue
    else
      flake.enqueue(options)
    end
  end

  singleton_class.send(:alias_method, :perform_later, :execute_later)

  def perform(args = {})
    args.each { |key, value| instance_variable_set(:"@#{key}", value) }
    execute
  end

  def execute(*)
    raise NotImplementedError, "no `execute` method defined for #{self.class}"
  end

  def on_success(&callback)
    @success = callback
    self
  end

  def on_failure(&callback)
    @failure = callback
    self
  end

  private

  def with_valid_params
    if block_given? && valid?
      ApplicationRecord.transaction do
        yield
      end
    else
      failure(errors)
    end
  end

  def success(*args)
    if args.size == 1 && args.first.respond_to?(:errors) && args.first.errors.present?
      failure(args.first.errors)
    else
      @success ||= default_success
      @success.call(*args)
      args.first
    end
  end

  def failure(*args)
    @failure ||= default_failure
    @failure.call(*args)
    false
  end

  def default_success
    proc { true }
  end

  def default_failure
    proc do |args|
      obj = args || self

      raise(Error, obj.errors.full_messages) if obj.respond_to?(:errors)
      raise(Error, obj.full_messages) if obj.is_a?(ActiveModel::Errors)
      raise(Error, obj.inspect)
    end
  end
end
