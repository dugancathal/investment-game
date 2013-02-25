class TickersController < ApplicationController
  # GET /tickers
  # GET /tickers.json
  def index
    @tickers = if params[:player_id]
      @player = Player.find(params[:player_id])
      @player.tickers
    else
        @tickers = Ticker.order(:name)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tickers }
    end
  end

  # GET /tickers/1
  # GET /tickers/1.json
  def show
    @player = if params[:player_id]
      Player.find(params[:player_id])
    end
    @ticker = Ticker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticker }
    end
  end
end
