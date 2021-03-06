describe "DotLedger.Views.Accounts.Show", ->
  createModel = ->
    new DotLedger.Models.Account
      name: 'Some Account'
      type: 'Savings'
      number: '123'
      id: 1
      unsorted_transaction_count: 5
      sorted_transaction_count: 10
      review_transaction_count: 15
      balance: 123.45
      updated_at: '2013-01-01T01:00:00Z'
      account_group_id: 2
      account_group_name: "Personal"

  createView = (model = createModel()) ->
    queryParams = new DotLedger.Models.QueryParams
      tab: 'sorted'
      page: 1

    balances = new DotLedger.Collections.Balances

    view = new DotLedger.Views.Accounts.Show
      model: model
      params: queryParams
    view

  it "should be defined", ->
    expect(DotLedger.Views.Accounts.Show).toBeDefined()

  it "should use the correct template", ->
    expect(DotLedger.Views.Accounts.Show).toUseTemplate('accounts/show')

  it "can be rendered", ->
    view = createView()
    expect(view.render).not.toThrow()

  it "renders the account group name", ->
    view = createView().render()
    expect(view.$el).toHaveText(/Personal/)

  it "renders the account name", ->
    view = createView().render()
    expect(view.$el).toHaveText(/Some Account/)

  it "renders the account type", ->
    view = createView().render()
    expect(view.$el).toHaveText(/Savings/)

  it "renders the account number", ->
    view = createView().render()
    expect(view.$el).toHaveText(/123/)

  it "renders the updated at time", ->
    view = createView().render()
    expect(view.$el).toContainElement('time[datetime="2013-01-01T01:00:00Z"]')

  it "renders the account balance", ->
    view = createView().render()
    expect(view.$el).toHaveText(/\$123.45/)

  it "renders the account edit link", ->
    view = createView().render()
    expect(view.$el).toContainElement('a[href="/accounts/1/edit"]')

  it "renders the statement import link", ->
    view = createView().render()
    expect(view.$el).toContainElement('a[href="/accounts/1/import"]')

  it "renders the sorted transactions tab link", ->
    view = createView().render()
    expect(view.$el).toContainElement('a[data-tab=sorted]')

  it "renders the sorted transactions tab label with count", ->
    view = createView().render()
    expect(view.$el).toContainText(/Sorted 10/)

  it "renders the review transactions tab link", ->
    view = createView().render()
    expect(view.$el).toContainElement('a[data-tab=review]')

  it "renders the unsorted transactions tab label with count", ->
    view = createView().render()
    expect(view.$el).toContainText(/Unsorted 5/)

  it "renders the unsorted transactions tab link", ->
    view = createView().render()
    expect(view.$el).toContainElement('a[data-tab=unsorted]')

  it "renders the review transactions tab label with count", ->
    view = createView().render()
    expect(view.$el).toContainText(/Review 15/)
