class @PollChart
  constructor: (dataDiv, paintTo = 'chart') ->
    div = $('<div></div>');
    div.html($(dataDiv).text());
    @data = JSON.parse(div.text());
    @paintTo = paintTo
    @type = @data.contract_type

  yAxis: ->
    [{
      title:
        text: 'Price/Premium'
      labels:
        formatter: ->
          '$' + @value
    }, {
      title:
        text: 'Profit/Loss'
      labels:
        formatter: ->
          '$' + @value
      opposite: true
    }]
    
  series: ->
    series = [{
      name: 'Profit/Loss'
      color: '#4572A7'
      type: 'column'
      data: @data.profits
      yAxis: 1
    }, {
      name: 'Stock Price'
      color: '#89A54E'
      type: 'spline'
      data: @data.prices
    }]
    if @type == 'call' || @type == 'put'
      series.push {
        name: 'Premium'
        data: @data.premium_prices
        type: 'spline'
      }, {
        name: 'Strike Price'
        data: @data.strike_price
        type: 'spline'
      }
    series


  paint: ->
    @chart = new Highcharts.Chart
      chart:
        renderTo: @paintTo
        zoomType: 'xy'
      title:
        text: @data.title
      xAxis: [{
        categories: @data.poll_dates
      }]
      yAxis: @yAxis()
      legend:
        layout: 'horizontal'
      series: @series()

jQuery ->
  if div = $("#chart-data script")
    new PollChart(div).paint()
