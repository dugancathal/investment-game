class @PollChart
  constructor: (dataDiv, paintTo = 'chart') ->
    div = $('<div></div>');
    div.html($(dataDiv).text());
    @data = JSON.parse(div.text());
    @paintTo = paintTo

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
      yAxis: [{
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
      legend:
        layout: 'horizontal'
      series: [{
        name: 'Profit/Loss'
        color: '#4572A7'
        type: 'column'
        data: @data.profits
        yAxis: 1
      }, {
        name: 'Price/Premium'
        color: '#89A54E'
        type: 'spline'
        data: @data.prices
      }]

jQuery ->
  if div = $("#chart-data script")
    new PollChart(div).paint()
