class HealthcheckController < ApplicationController
  def health
    render plain: 'OK'
  end
end
