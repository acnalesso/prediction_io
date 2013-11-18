module PredictionIO

  ##
  # Defines a fake logger
  # stubs method error.
  Logger = Object.new

  def Logger.error(notice); @notice = notice; end
  def Logger.read; @notice; end

end
