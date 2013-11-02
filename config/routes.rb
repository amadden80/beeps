SineGen::Application.routes.draw do
  root :to => 'sine#index'
  get '/sine' => 'sine#sine'
end