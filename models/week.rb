class Week < ActiveRecord::Base
  def self.get year, week
    w = Week.where(:year => year, :week => week).first
    w = Week.new(:year => year, :week => week) if w.nil?
    return w
  end

  def date
    return "#{self.year}-W#{"%02d" % self.week}-1"
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
      if Money::HIDE
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
