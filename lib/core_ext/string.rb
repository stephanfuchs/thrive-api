# extend String with useful default conversions
class String
  def clean_spaces
    self.gsub(/[[:space:]]/, ' ')
  end
  def from_words_to_snake_case
    self.gsub(/\W/, '_').downcase
  end

  # # TODO: (Stephan) revisit after upgrading to Rails 5
  # # DEPRECATION WARNING: You attempted to assign a value which is not explicitly `true` or `false`
  # # ("True") to a boolean column. Currently this value casts to `false`. This will change to
  # # match Ruby's semantics, and will cast to `true` in Rails 5. If you would like to maintain the
  # # current behavior, you should explicitly handle the values you would like cast to `false`.
  # #
  # # https://blog.eq8.eu/til/convert-string-true-and-string-false-to-boolean-with-rails.html
  # # more details https://stackoverflow.com/a/44322375
  # def to_boolean
  #   ActiveRecord::Type::Boolean.new.cast(self)
  # end

  def to_class
    self.capitalize.scan(/[a-z|A-Z|0-9]/).join
  end

  # INFO: (Stephan) convert emojis into their html equivalent entity numbers
  #   See for examples https://www.w3schools.com/Html/html_emojis.asp
  def convert_emojis_to_html
    self.gsub(Unicode::Emoji::REGEX) { |entry| entry.each_codepoint.map { |codepoint| "&##{codepoint};" }.join }
  end
end
