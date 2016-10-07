class JwtService
  def build_token(payload)
    JWT.encode payload, RsaService.instance.private_key, 'RS512'
  end

  def user_id(token)
    begin
      decoded_token = JWT.decode token, RsaService.instance.public_key
      if decoded_token.is_a? Array
        return decoded_token[0]['user_id']
      else
        return nil
      end
    rescue JWT::DecodeError
      return nil
    end
  end
end
