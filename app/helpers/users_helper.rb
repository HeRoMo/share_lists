
module UsersHelper
  GRAVATOR_BASE_URL = 'https://www.gravatar.com/avatar/'

  def gravator_icon(user, options={})
    hash = Digest::MD5.hexdigest(user.email.downcase)
    url = "#{GRAVATOR_BASE_URL}#{hash}"
    size = options[:size]||options["size"]
    if size.present?
      size = size.split('x').max.to_i unless size.is_a?(Fixnum)
      url+= "?s=#{size}" if size > 0
    end

    image_tag url, options
  end
end
