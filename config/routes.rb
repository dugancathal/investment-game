InvestmentGame::Application.routes.draw do
  resources :players, only: [:index, :show, :new, :create] do
    resources :tickers, only: [:index, :show]
    resources :contracts, only: [:show, :edit, :update]

    get 'download', on: :member
  end

  root to: 'players#index'

end
