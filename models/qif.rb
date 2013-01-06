require 'hashie'
require 'csv'
class Qif
  def self.open(filename)
    file = File.open(filename, "r")
    data = file.read
    return new(data)
  ensure
    file.close
  end

  def initialize(data)
    @hash = self.class.parse(data)
    super
  end

  def to_csv
    @hash.map do |row|
      [row.date,
       row.name,
       row.net,
       row.gross].to_csv
    end.join
  end

  private
  def self.parse(data)
    rows = []
    data.split(/\^\n/).map{|c| c.split(/\n/).reject{|c| c.match(/^[^DTPNA]/)}}.each do |c|
      row = {}
      row["date"] = c.detect{|d| d.match(/^D/)}.sub(/^D/,"").strip
      row["net"] = c.detect{|d| d.match(/^T/)}.sub(/^T/,"").strip
      row["gross"] = c.detect{|d| d.match(/^T/)}.sub(/^T/,"").strip
      row["name"] = c.detect{|d| d.match(/^P/)}.sub(/^P/,"").strip
      rows << Hashie::Mash.new(row)
    end
    rows
  end


end
