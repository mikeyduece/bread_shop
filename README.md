# Bread Shop API [![Build Status](https://travis-ci.org/mikeyduece/bread_shop.svg?branch=master)](https://travis-ci.org/mikeyduece/bread_shop)

[![Waffle.io - Columns and their card count](https://badge.waffle.io/mikeyduece/bread_shop.svg?columns=all)](https://waffle.io/mikeyduece/bread_shop)


##### Versions  

<sup>Ruby 2.5.0</sup>  
  <sup>Rails 5.1.5</sup>
  
### Available Endpoints
`GET /:user_name/recipes` - Returns list of recipes that a user has created.
```ruby
  {
    recipe: {
      name: recipe_name,
      ingredients: {
        ingredient_name: {amount: float, bp: float},
        ...
      },
      total_percentage: float
    },
    ...
  }
```

`GET /:user_name/recipes/:recipe_name` - Returns specific recipe.

  
  
