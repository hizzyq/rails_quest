class Quest3AccessGateController < ApplicationController
  # TODO: Add routes in config/routes.rb and finish the controller logic for Quest 3.
  # The quest expects a mix of GET / POST / PATCH / DELETE, conditional redirects,
  # and visible before_action / after_action callbacks.

  # Quest3DataService probes POST/PATCH/DELETE actions without a browser CSRF token.
  # Disable CSRF verification here so the probe can validate route/controller logic.
  skip_forgery_protection


  # Register callbacks here.
  before_action :calculate_clearance, only: [:clearance]
  after_action :set_trace_header, only: [:clearance]

  before_action :extract_token, only: [:granted]
  after_action :set_token_checked_header, only: [:granted]

  def ping
    render plain: 'ACCESSGATE PING OK', status: :ok
  end

  def scan
    agent = params[:agent]
    sector = params[:sector]

    render plain: "SCAN RESULT: #{agent} -> sector #{sector}", status: :ok
  end

  def power
    current = params[:current].to_i
    boost = params[:boost].to_i
    total = current + boost

    render plain: "POWER TOTAL: #{total}", status: :ok
  end

  def stale_logs
    count = params[:count]

    render plain: "STALE LOGS CLEARED: #{count}", status: :ok
  end

  def clearance
    render plain: "CLEARANCE TOTAL: #{@clearance_total}", status: :ok
  end

  def verify
    token = params[:token]

    if token&.start_with?('alpha')
      redirect_to "/access_gate/granted?token=#{token}", allow_other_host: true
    else
      # Ветка для отклонённого токена (например, omega-9)
      redirect_to "/access_gate/denied?token=#{token}", allow_other_host: true
    end
  end

  def granted
    render plain: "TOKEN ACCEPTED: #{@token}", status: :ok
  end

  def denied
    render plain: ""
  end

  private

  def calculate_clearance
    level = params[:level].to_i
    boost = params[:boost].to_i
    @clearance_total = level + boost
  end

  def set_trace_header
    response.headers['X-Access-Gate-Trace'] = 'CLEAREANCE_GRANTED'
  end

  def extract_token
    @token = params[:token]
  end

  def set_token_checked_header
    response.headers['X-Access-Gate-Trace'] = 'token_checked'
  end

  # Implement callbacks here
  # response.set_header("X-Access-Gate-Trace", "") may be helpful
end
