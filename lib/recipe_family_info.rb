module RecipeFamilyInfo
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

  def calculate_percentage(category)
    ((category / flour_amts) * 100).round(2)
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
