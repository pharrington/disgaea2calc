class ItemsController < ApplicationController
  def index
    names = ['Ultimus', 'Yoshitsuna', 'Drill Emperor', 'Lovely Cupid', 'Etoile', 'Apocalypse', 'Omniscient Rod', 'Babylon Crown', 'The Fool', 'Super Robo Suit', 'Cosmos Muscle', 'Prinny Suit', 'Makai Wars', 'Felicitation']
    @items = Item.find_all_by_name(names)
    @heading = 'Choose the item you want to calculate stats for'
  end

  def search
    name = "%#{params[:name]}%"
    @items = Item.find(:all, :conditions => ['name LIKE ?', name])
    @heading = 'Choose the item you want to calculate stats for'
    render :action => 'index'
  end

  def show
    @item = Item.find(params[:id])
    @heading = "#{@item.name} Base stats"
  end

  def calc_basic
    item = Item.find(params[:id])
    @heading = "#{item.name}'s Calculated Stats"
    @stat = params[:calculator][:stat]
    calculator = Calculator.new(params[:calculator])
    if @stat == 'ALL' then
      @calculated = {}
      calculator.stats.each do |stat|
        calculator.perfect!(stat)
        @calculated[stat] = calculator.calculate(item)
      end
    else
      calculator.perfect!(@stat.downcase)
      @calculated = calculator.calculate(item)
    end
  end

  def show_advanced
    @item = Item.find(params[:id])
    @heading = "#{@item.name} Base stats:"
  end

  def calc_advanced
    calc = CalculatorPresenter.build(params[:calculator_presenter])
    @item = Item.find(params[:id])
    @heading = "#{@item.name}'s Calculated Stats"
    @calculated = calc.calculate(@item)
  end
end
