class RsaService
  include Singleton
  attr_reader :private_key

  def initialize
    @private_key = OpenSSL::PKey::RSA.generate 2048
  end

  def public_key
    @private_key.public_key
  end
end
