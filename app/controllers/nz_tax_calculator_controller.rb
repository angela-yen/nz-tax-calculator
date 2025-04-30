class NzTaxCalculatorController < ApplicationController
  # Defining the tax brackets and rates as a constant array of objects
  TAX_BRACKETS = [
    { max_income: 15600, rate: 0.105 },
    { max_income: 53500, rate: 0.175 },
    { max_income: 78100, rate: 0.30 },
    { max_income: 180000, rate: 0.33 },
    { max_income: Float::INFINITY, rate: 0.39 }
  ].freeze #adding .freeze to make brackets immutable

  def index
  end

  def calculate
    # Takes the value that was input by the user and transforms it into a string.
    annual_income_value = params[:income].to_i

    # This calls the calculate_tax method with the annual income value from the params, then returns 2 values.
    raw_tax, @tax_breakdown = calculate_tax(annual_income_value)

    # Ensure that our calculated tax amount is in 2 decimals, as required for monetary standards.
    @tax_amount = format('%.2f', raw_tax)

    render :index
  end

  #
  # NOTE: Initial Draft Method (before refactoring)
  #         def calculate
  #           p = params[:num].to_i
  #           set_tier_values
  #
  #           @result = case p
  #             when 0..15600
  #               p * 0.105
  #             when 15601..53500
  #               (p - 15600) * 0.175 + @tier_1
  #             when 53501..78100
  #               (p - 53500) * 0.30 + @tier_1 + @tier_2
  #             when 78101..180000
  #               (p - 78100) * 0.33 + @tier_1 + @tier_2 + @tier_3
  #             else
  #               if p >= 180001
  #                 (p - 180000) * 0.39 + @tier_1 + @tier_2 + @tier_3 + @tier_4
  #               else
  #                 'An error has occurred'
  #               end
  #             end
  #
  #             @result = format('%.2f', @result)
  #
  #             render :index
  #           end
  #

  private

  def calculate_tax(income)
    # Initial tax
    tax = 0
    # Initial tax bracket
    previous_tax_bracket_cap = 0
    # Initial tax breakdown
    breakdown = []

    # We loop through each tax bracket defined above
    TAX_BRACKETS.each do |bracket|
      # Break out of loop if the income is less than the previous tax bracket cap.
      # As this means we have the correct tax calculated for the cap
      break if income <= previous_tax_bracket_cap

      # Maximum for the tax bracket
      cap = bracket[:max_income]
      # Tax rate for the tax bracket
      rate = bracket[:rate]
      # We take the minimum between the income and the maximum of income for the tax bracket.
      # This means we only tax income up the maximum of the tax bracket, and exclude values above this (as this will be taxed at the next tax bracket rate).
      # Then we minus the previous tax bracket cap as th value has already been calculated
      taxable = [income, cap].min - previous_tax_bracket_cap

      # We now calculate the total tax for the amount that is taxable (for the tax bracket)
      tax_paid = taxable * rate

      # This creates an array of objects that gives us the required information to populate the breakdown table
      breakdown << {
        range: "$#{previous_tax_bracket_cap + 1} - $#{cap == Float::INFINITY ? '∞' : cap}",
        rate: rate,
        taxable: taxable,
        tax_paid: tax_paid
      }

      # We now add to previously calculated tax to get the total amount of tax (inital 0)
      tax += tax_paid
      # Now we set the maximum of this tax bracket as the cap and loop again if required.
      previous_tax_bracket_cap = cap
    end

    # This will then ouput our final tax amount and the breakdown values to populate our table.
    [tax, breakdown]
  end

  #
  # Note: Initial sudo code to understand tax bracket.
  #       When you earn within the bracket, it gets taxed at that rate and any value above the bracket will
  #       get taxed at the higher bracket. However, this is incremental to the earnings. i.e. if I earned
  #       $60000, I would get taxed at 10.5% for the first $15600, then 17.5% for next $37899, then at 30% for
  #       the remainder $6501.
  #

  #
  # Note: Initial Draft Method (before refactoring)
  #       def set_tier_values
  #         @tier_1 = 15600 * 0.105                     # Tax for first $15,600
  #         @tier_2 = (53500 - 15600) * 0.175           # Tax for $15,601 - $53,500
  #         @tier_3 = (78100 - 53500) * 0.30            # Tax for $53,501 - $78,100
  #         @tier_4 = (180000 - 78100) * 0.33           # Tax for $78,101 - $180,000
  #       end
  #
end
