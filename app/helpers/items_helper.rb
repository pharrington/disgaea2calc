module ItemsHelper
  def bill_type_helper
    [ ['No Bill', 0],
      ['Small Stat-up', 1],
      ['High Stat-up', 2],
    ]
  end

  def stats
    %w[ hp sp atk def int res hit spd ]
  end

  def stat_choices
    stats.collect {|stat| [stat.upcase, stat.upcase]}.unshift(['All Possibilities', 'ALL'])
  end

  def bill_stat_helper
    stats.collect {|stat| [stat.upcase, stat]}
  end

  def bill_floor_helper
    (1..9).collect { |i| i * 10 }
  end

  def rarity_options_helper
    [ ['Normal', 1],
      ['Rare', 1.25],
      ['Legendary', 1.5],
    ]
  end

  def bosses_options_helper
    [ ['Not Killed', 0],
      ['Single Killed', 1],
      ['Double Killed', 2],
    ]
  end

  def bosses_label_helper(floor)
    if floor == 10 then
      title = 'Item God'
    elsif floor % 3 == 0 then
      title = "Floor #{floor * 10} Item King"
    else
      title = "Floor #{floor * 10} Item General"
    end
    "#{title} Defeated?"
  end

  def ordinal_text(int)
    case int
    when 1: "first"
    when 2: "second"
    when 3: "third"
    end
  end
end
