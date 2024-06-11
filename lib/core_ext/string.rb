# extend String with useful default conversions
class String
  def clean_spaces
    self.gsub(/[[:space:]]/, ' ')
  end
  def from_words_to_snake_case
    self.gsub(/\W/, '_').downcase
  end

  # https://blog.eq8.eu/til/convert-string-true-and-string-false-to-boolean-with-rails.html
  # more details https://stackoverflow.com/a/44322375
  def to_boolean
    ActiveRecord::Type::Boolean.new.cast(self)
  end

  def to_class
    self.capitalize.scan(/[a-z|A-Z|0-9]/).join
  end

  # INFO: (Stephan) convert emojis into their html equivalent entity numbers
  #   See for examples https://www.w3schools.com/Html/html_emojis.asp
  def convert_emojis_to_html
    self.gsub(Unicode::Emoji::REGEX) { |entry| entry.each_codepoint.map { |codepoint| "&##{codepoint};" }.join }
  end
end
