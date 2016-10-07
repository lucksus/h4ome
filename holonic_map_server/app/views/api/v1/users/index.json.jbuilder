envelope json, response_state do
  json.array! @users, partial: 'api/v1/users/user', as: :user
end