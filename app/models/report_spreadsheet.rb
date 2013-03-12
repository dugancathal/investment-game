require 'spreadsheet'

#  The format we are trying to generate is
#  
#  Row 1: header
#  Row 2-3: blank
#  Row 4-5: Long/Short/Call headers
#  Row 6-16: Long/Short/Call data
#  Row 17-18: blank
#  Row 20-21: Future/P&L/Put headers
#  Row 22-32: Future/P&L/Put data

class ReportSpreadsheet
  GAME_LENGTH = 10
  EMPTY_CELL = ['']

  def initialize(player)
    @player = player
  end

  def filename
    Rails.root.join('public', "spreadsheet-#{@player.username}.xls")
  end

  def generate!
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet name: 'Tables'
    write_headers
    write_long_short_call
    write_future_pl_put
    write_contract_counts
    @book.write(filename.to_s)
  end

  def write_long_short_call
    call_stock = @player.call.ticker.related_stock.contract_for(@player)
    poll_dates.each_with_index do |date, i|
      row = []
      row += [ i, @player.long.poll_on(date).value, @player.long.profit_on(date).value ]
      row += EMPTY_CELL
      row += [ i, @player.short.poll_on(date).value, @player.short.profit_on(date).value ]
      row += EMPTY_CELL
      row += [ i, call_stock.poll_on(date).value, @player.call.poll_on(date).value, @player.call.poll_on(date).value, @player.call.profit_on(date).value ]
      @sheet.row(i+5).replace row
    end
  end

  def write_future_pl_put
    put_stock = @player.put.ticker.related_stock.contract_for(@player)
    poll_dates.each_with_index do |date, i|
      row = []
      row += [ i, @player.future.poll_on(date).value, @player.future.profit_on(date).value ]
      row += EMPTY_CELL
      row += [ i, @player.pl_for_date(date)]
      row += EMPTY_CELL + EMPTY_CELL
      row += [ i, put_stock.poll_on(date).value, @player.put.poll_on(date).value, @player.put.poll_on(date).value, @player.put.profit_on(date).value ]
      @sheet.row(i+19).replace row
    end
  end

  def write_contract_counts
    @sheet[3, 15] = 'Contract Counts'
    [:long, :short, :call, :put, :future].each_with_index do |stock_type, i|
      @sheet[4+i, 15] = stock_type.to_s.titlecase
      @sheet[4+i, 16] = Contract.where(player_id: @player.id, type: stock_type.to_s.classify).first.value
    end
  end

  # Header rows are as follows (in CSV)
  #
  # Row 1:  header,,,,,,
  # Row 4:  ,LONG,,,SHORT,,,,CALL
  # Row 18: ,FUTURE,,,P&L,,,,PUT
  def write_headers
    @sheet.row(0).replace [header]
    @sheet.row(3).replace name_header_row(@player.longs.first.ticker_name, @player.shorts.first.ticker_name, @player.calls.first.ticker_name)
    @sheet.row(4).replace data_header_row(long_short_headers, long_short_headers, call_put_headers)

    @sheet.row(17).replace name_header_row(@player.futures.first.ticker_name, 'Total P&L', @player.puts.first.ticker_name)
    @sheet.row(18).replace data_header_row(long_short_headers, overall_headers, call_put_headers)
  end
  
  def name_header_row(item1, item2, item3)
    EMPTY_CELL + Array(item1) +
    EMPTY_CELL*3 + Array(item2) +
    EMPTY_CELL*4 + Array(item3)
  end

  def data_header_row(item1, item2, item3)
    Array(item1) + EMPTY_CELL +
    Array(item2) + EMPTY_CELL +
    Array(item3)
  end

  def header
    "Tables of Data for Investment Game #{Time.now.year}"
  end

  def long_short_headers
    ['Week', 'Stock Price', 'Profit/Loss']
  end

  def call_put_headers
    ['Week', 'Stock Price', 'Strike Price', 'Premium', 'Profit/Loss']
  end

  def overall_headers
    ['Week', 'Profit/Loss', '']
  end

  def poll_dates
    Poll.friday_dates
  end
end
