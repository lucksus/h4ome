# spec/support/auth_helpers.rb
module AuthHelpers

  def authWithUser(user)
    headers['JWT'] = JwtService.new.build_token user_id: user.id
  end

  def clearAuthToken
    headers['JWT'] = nil
  end

  def headers
    @headers ||= Hash.new
  end
end
