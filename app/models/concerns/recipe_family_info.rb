# frozen_string_literal: true

module RecipeFamilyInfo
  def calculate_family
    case
    when lean  then update_attribute(:family_id, family_assignment('Lean'))
    when soft  then update_attribute(:family_id, family_assignment('Soft'))
    when sweet then update_attribute(:family_id, family_assignment('Sweet'))
    when rich  then update_attribute(:family_id, family_assignment('Rich'))
    when slack then update_attribute(:family_id, family_assignment('Slack'))
    end
    family_id
  end

  def family_assignment(name)
    Family.find_by(name: name).id
  end

  def sum_recipe_ingredient_amounts(category)
    category_id = Category.find_by(name: category).id
    recipe_ingredients.joins(:ingredient)
      .where(ingredients: { category_id: category_id })
      .sum(:amount)
  end

  def destroy_all_recipe_ingredients
    recipe_ingredients.delete_all
  end
#---Above here
  def sweetener_percentage
    sweets = sweetener_amounts
    calculate_percentage(sweets)
  end

  def fat_percentage
    fats = fat_amounts
    calculate_percentage(fats)
  end

  def water_percentage
    water = water_amt
    calculate_percentage(water)
  end

  def lean
    return true if sweet_and_fat_amts.all? { |amt| low.include?(amt) }
  end

  def soft
    if (water_percentage + fat_percentage) < 70.0 &&
        moderate.include?(sweetener_percentage) &&
        moderate.include?(fat_percentage)
      true
    end
  end

  def rich
    if (moderate.include?(sweetener_percentage) &&
        high.include?(fat_percentage)) ||
        high.include?(fat_percentage)
      true
    end
  end

  def slack
    return true if water_percentage + fat_percentage > 70.0
  end

  def sweet
    return true if sweet_and_fat_amts.all? { |amt| high.include?(amt) }
  end

  def low
    (0.0..4.99)
  end

  def moderate
    (5.0..10.0)
  end

  def high
    (11.0..25.0)
  end

  def sweet_and_fat_amts
    [sweetener_percentage, fat_percentage]
  end

  def calculate_percentage(category_amount)
    ((category_amount / flour_amts) * 100).round(2)
  end

  def sweetener_amounts
    sum_recipe_ingredient_amounts('sweetener')
  end

  def fat_amounts
    sum_recipe_ingredient_amounts('fat')
  end

  def water_amt
    sum_recipe_ingredient_amounts('water')
  end
end
