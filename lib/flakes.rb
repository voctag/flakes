class Flake

  public

  def self.input_params
    @input_params
  end

  def on_success(&callback)
    @success = callback
    return self
  end

  def on_failure(&callback)
    @failure = callback
    return self
  end

  private

  attr_reader :repo, :params

  def self.default_repo(default_repo)
    define_method :initialize do |params = nil, repo = default_repo|
      @repo = repo

      input_params = self.class.input_params

      if input_params.present?
        input_params.each do |name|
          instance_variable_set("@#{name}", params[name])
          self.class.send(:attr_reader, name)
        end
      end

    end
  end

  def self.allow_params(*params)
    @input_params = params
  end

  def success(*args)
    @success ||= Proc.new { |args| args }
    @success.call(*args)
  end

  def failure(*args)
    @failure ||= default_failure
    @failure.call(*args)
  end

  def default_failure
    Proc.new do |args|
      obj = args || self
      raise obj.inspect
    end
  end
end
