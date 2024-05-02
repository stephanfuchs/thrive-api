class Hash
  # extend Hash with useful default conversions
  # taken from https://stackoverflow.com/a/45851976
  def to_o
    JSON.parse to_json, object_class: OpenStruct
  end

  # taken from https://stackoverflow.com/a/14773555 and tweaked
  # removes key value pair if value is present
  # keeps empty sub-hashes
  def deep_clean(opts = {})
    inject({}) do |new_hash, (k, v)|
      if v.present?
        new_hash[k] = v.class == Hash ? v.deep_clean(opts) : v
      end
      new_hash
    end
  end
end