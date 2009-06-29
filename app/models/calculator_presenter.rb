class CalculatorPresenter
  def self.build(attributes)
    if (!attributes.nil?) then
      attributes[:bills] = self.bill(attributes.delete(:bill))
      attributes[:rarity] = attributes[:rarity].to_f
      attributes[:level] = attributes[:level].to_i
      attributes[:floor] = attributes[:floor].to_i
      attributes[:bosses].collect! {|count| count.to_i}
      attributes[:specialists].each_value do |spec|
        spec.collect! {|count| count.to_i}
      end
      Calculator.new(attributes)
    end
  end

private
  def self.bill(bills)
    h = {}
    bills.each do |bill|
      h[bill[:stat]] ||= Array.new
      h[bill[:stat]][bill[:floor].to_i / 10 - 1] = bill[:type].to_i
    end
    h
  end
end
