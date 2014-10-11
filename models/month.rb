class Month < ActiveRecord::Base
  def self.get year, month
    m = Month.where(:year => year, :month => month).first
    m = Month.new(:year => year, :month => month) if m.nil?
    return m
  end

  # TODO(natwelch): AVG values?
  def set account_name, amount
    self[account_name] = amount
  end

  def accounts
    self.accounts_json = "{}" if self.accounts_json.nil?
    return JSON.parse self.accounts_json
  end

  def [] key
    acc = self.accounts
    return acc[key]
  end

  def []= key, value
    acc = self.accounts
    acc[key] = value
    self.accounts = acc
  end

  def accounts= val
    return self.accounts_json = val.to_json
  end

  def csv_names
    return self.accounts.keys.sort.map {|k|
      if MoneyApp::HIDE
        "\"#{k.hash}\""
      else
        "\"#{k}\""
      end
    }.join(',')
  end

  def csv_values
    ret = []
    self.accounts.keys.sort.each do |k|
      ret.push self[k]
    end

    return ret.join ','
  end
end
