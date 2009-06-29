class Calculator
  include MassAssignable
  attr_accessible :level, :floor, :rarity, :bosses, :bills, :specialists
  attr_reader :stats
 
  def level=(value)
    @level = value.to_i
  end

  def floor=(value)
    @floor = value.to_i
  end

  def initialize(attributes = {})
    @stats = %w[hp sp atk def int res hit spd]
    @rarity = 1
    @bosses = []
    @bills = Hash.new(Array.new(10, 0))
    @specialists = Hash.new(Array.new(20, 0))
    self.attributes = attributes
  end

  def reset!
    @rarity = 1
    @bosses.clear
    @bills.clear
    @specialists.clear
  end

  def perfect!(stat)
    reset!
    @specialists[stat] = [6, 6, 6, 8, 8, 8, 8, 8, 8, 8,
                          6, 6, 7, 8, 8, 8, 8, 8, 8, 8]
    @bills[stat] = [2, 2, 2, 0, 0, 0, 0, 0, 0, 0]
    @rarity = 1.5
    @bosses = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  end

  def calculate(item)
    calculated = {}
    @stats.each do |stat|
      calculated['stat_'+stat] = calc_stat(stat, item['stat_'+stat], @level, @floor)
    end
    calculated['name'] = item.name
    calculated
  end

  def calc_stat(stat, value, level, floor)
    specialists = @specialists[stat]
    bills = @bills[stat]
    ll = 1 + 0.05 * level
    sign = (value < 0) ? -1 : (value > 0) ? 1 : 0
    n = sign * level
    highstat = 0
    lowstat = 0
    g = [0.01, 0.01, 0.02, 0.01, 0.01, 0.02, 0.01, 0.01, 0.02, 0.03]
    s = [3, 3, 6, 3, 3, 6, 3, 3, 6, 9]
    gg = 0
    ss = 0
    p = 0
    floor = floor / 10 - 1
    0.upto(floor) do |step|
      sboss = @bosses[step] || 0
      sg = g[step]
      sbill = bills.nil? ? 0 : bills[step]
      sbill ||= 0

      gg += sboss * sg * 10
      if sbill > 0 && sboss > 0 then
        n = level if sign == 0
        gg += sg * p if sboss == 2
        gg += sg * (p + 1) if sbill == 1
        gg += sg * (p + 2) if sbill == 2
        highstat += 1 if sbill == 2
        lowstat += 1 if sbill == 1
        p = lowstat + 2 * highstat
      else
        gg += sboss * (sg * p)
      end
      sboss.times do |boss_step|
        ss += s[step] * specialists[step + (boss_step*10)] if specialists[step + (boss_step)] > 0
      end
    end
    gg *= sign
    ((value * (@rarity + gg) + ss) * (1 + 0.05 * p) * ll + n).floor
  end
end
