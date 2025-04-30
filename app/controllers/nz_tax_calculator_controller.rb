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
    # require 'byebug'; byebug
    # Takes the value that was input by the user and transforms it into a string.
    annual_income_value = params[:income].to_i
    raw_tax, @tax_breakdown = calculate_tax(annual_income_value)

    # Ensure that our calculated tax amount is in 2 decimals, as required for monetary standards.
    @tax_amount = format('%.2f', raw_tax)

    render :index
  end

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
        range: "$#{previous_tax_bracket_cap + 1} – $#{cap == Float::INFINITY ? '∞' : cap}",
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
end
