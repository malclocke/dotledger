DotLedger.module 'Views.Payments', ->
  class @ProjectedBalanceGraph extends Backbone.Marionette.ItemView
    tagName: 'div'

    template: 'payments/projected_balance_graph'

    initialize: (options)->
      @balances = new DotLedger.Collections.ProjectedBalances()
      @params = options.params

    events:
      'click a[data-period]': 'clickPeriod'

    setActivePeriod: ->
      @$el.find("a[data-period]").parent().removeClass('active')
      @$el.find("a[data-period='#{@params.get('period')}']").parent().addClass('active')

    clickPeriod: (event)->
      event.preventDefault()
      @params.set(period: $(event.target).data('period'))
      @setActivePeriod()
      @fetchBalances()

    fetchBalances: ->
      date_from = moment()
      date_to = moment().add(@params.get('period'), 'days')
      
      @balances.fetch
        data:
          date_from: DotLedger.Helpers.Format.queryDate(date_from)
          date_to: DotLedger.Helpers.Format.queryDate(date_to)

    ui:
      balanceGraph: '.balance .graph'
      balanceTooltip: '.balance .tooltip'
      balanceTooltipInner: '.balance .tooltip .tooltip-inner'

    balanceGraphData: ->
      [
        {
          color: 'rgb(111, 202, 194)'
          data: @balances.map (balance) ->
            [DotLedger.Helpers.Format.unixMilliTimestamp(balance.get('date')), balance.get('balance')]
        }
      ]

    balanceGraphOptions: ->
      series:
        shadowSize: 1
        lines:
          show: true
          lineWidth: 2
          fill: true
          fillColor: 'rgba(111, 202, 194, 0.6)'
      grid:
        borderWidth: 0
        hoverable: true
      points:
        radius: 2
      xaxis:
        mode: "time"
        timeformat: "%e %b"
        tickLength: 0
      yaxis:
        tickColor: 'rgba(238, 238, 238, 1)'

    renderBalanceGraph: ->
      @setActivePeriod()

      if @isRendered
        @graph = $.plot(@ui.balanceGraph, @balanceGraphData(), @balanceGraphOptions())
        @ui.balanceGraph.bind "plothover", (event, pos, item) =>
          if item
            balance = DotLedger.Helpers.Format.money(item.datapoint[1])
            @ui.balanceTooltipInner.html(balance)
            @ui.balanceTooltip.css(
              top: item.pageY - 35
              left: item.pageX - 40
            ).addClass('in')
          else
            @ui.balanceTooltip.removeClass('in')

    onRender: ->
      @balances.on 'sync', =>
        @renderBalanceGraph()

      @fetchBalances()
      _.defer(=> @renderBalanceGraph())
