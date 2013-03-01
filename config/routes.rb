InvestmentGame::Application.routes.draw do
  resources :players do
    resources :tickers
  end

  root to: 'players#index'

end
