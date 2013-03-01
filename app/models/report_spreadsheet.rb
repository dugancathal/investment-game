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
  end

  def write_future_pl_put
  end

  def write_contract_counts
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
