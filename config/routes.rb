InvestmentGame::Application.routes.draw do
  resources :tickers
  resources :players do
    resources :tickers
  end

  root to: 'players#index'

end
