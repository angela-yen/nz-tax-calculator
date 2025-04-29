class NzTaxCalculatorController < ApplicationController
  def index
  end

  def calculate
    p = params[:num].to_i
    set_tier_values

    @result = case p
              when 0..15600
                p * 0.105
              when 15601..53500
                (p - 15600) * 0.175 + @tier_1
              when 53501..78100
                (p - 53500) * 0.30 + @tier_1 + @tier_2
              when 78101..180000
                (p - 78100) * 0.33 + @tier_1 + @tier_2 + @tier_3
              else
                if p >= 180001
                  (p - 180000) * 0.39 + @tier_1 + @tier_2 + @tier_3 + @tier_4
                else
                  'An error has occurred'
                end
              end

    @result = format('%.2f', @result)

    render :index
  end

  private

  def calculate_tax(income)
    total_tax = 0
    previous_limit = 0

    TAX_BRACKETS.each do |bracket|
      if income > previous_limit
        taxable_income = [income - previous_limit, bracket[:max_income] - previous_limit].min
        total_tax += taxable_income * bracket[:rate]
        previous_limit = bracket[:max_income]
      else
        break
      end
    end

    total_tax
  end

  def set_tier_values
    @tier_1 = 15600 * 0.105                     # Tax for first $15,600
    @tier_2 = (53500 - 15600) * 0.175           # Tax for $15,601 - $53,500
    @tier_3 = (78100 - 53500) * 0.30            # Tax for $53,501 - $78,100
    @tier_4 = (180000 - 78100) * 0.33            # Tax for $78,101 - $180,000
  end
end
