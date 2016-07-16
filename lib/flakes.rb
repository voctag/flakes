class Flake < ActiveJob::Base
  # alias ActiveJob::Core#initialize before it is overwritten by ActiveModel::Model
  alias_method :active_job_initialize, :initialize

  include ActiveModel::Model

  def self.execute_later(*args)
    # initialize ActiveJob::Core only when Flake is enqueued to prevent conflics whith ActiveModel
    flake = new
    flake.send(:active_job_initialize, *args)
    flake.enqueue
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

  def success(*args)
    @success ||= default_success
    @success.call(*args)
  end

  def failure(*args)
    @failure ||= default_failure
    @failure.call(*args)
  end

  def default_success
    proc { true }
  end

  def default_failure
    proc do |args|
      obj = args || self
      raise obj.inspect
    end
  end
end
