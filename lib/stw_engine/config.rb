module StwEngine
  extend self

  # modes
  MODES = %w{production placehold dummy}
  IMAGE_URL = 'http://images.shrinktheweb.com/xino.php?'
  ACCOUNT_URL = 'http://images.shrinktheweb.com/account.php?'

  def config c = {}
    # mandatory
    self.api_key = c[:api_key]
    self.api_secret = c[:api_secret]

    # optional
    self.size = c[:size] if c[:size]
    
  end

  def api_key=api_key
    @api_key=api_key
  end

  def api_key
    raise 'StwEngine error: No api_key defined!' if @api_key.nil?
    @api_key
  end

  def api_secret=api_secret
    @api_secret = api_secret
  end

  def api_secret
    raise 'StwEngine error: No api secret defined!' if @api_secret.nil?
    @api_secret
  end
  
  def size=size
    @size = size
  end

  def size    
    @size
  end

  def mode=mode
    raise "StwEngine error: Invalid mode, only #{ MODES.join(', ') } are allowed" unless MODES.include?(mode.to_s)
    @mode = mode.to_s
  end

  def mode
    @mode ||= 'production' # default: production
  end

  def api_version=api_version
    @api_version = api_version || 'v6' # set default to latest open version
  end

  def api_version
    @api_version || 'v6' #default: v6
  end

  def image_url=image_url
    @image_url = image_url || IMAGE_URL
  end

  def image_url
    # reference => http://url2png.com/docs/
    # currently all versions suggest 'beta'
    @image_url || IMAGE_URL
  end
  
   def account_url
    @account_url = ACCOUNT_URL
  end
  
   def account_url=account_url
    @account_url = ACCOUNT_URL
  end



  def default_size=default_size
    @default_size = default_size || "400x400"
  end

  def default_size
    @default_size || "400x400"
  end

  def token param
    case self.api_version
    when 'v6'
      Digest::MD5.hexdigest("#{param}#{self.private_key}")
    when 'v4', 'v3'
      Digest::MD5.hexdigest("#{self.private_key}+#{param}")
    end
  end
end
