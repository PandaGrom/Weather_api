class ApplicationService
  def self.call(*args, **key_value, &block)
    new(*args, **key_value, &block).call
  end
end
