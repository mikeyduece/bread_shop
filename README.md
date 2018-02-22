# Bread Shop API [![Build Status](https://travis-ci.org/mikeyduece/bread_shop.svg?branch=master)](https://travis-ci.org/mikeyduece/bread_shop)

[![Waffle.io - Columns and their card count](https://badge.waffle.io/mikeyduece/bread_shop.svg?columns=all)](https://waffle.io/mikeyduece/bread_shop)


##### Versions  

<sup>Ruby 2.5.0</sup>  
  <sup>Rails 5.1.5</sup>
  
### Available Endpoints  
All requests require token from client app to be sent in the params. If no token is present, the request will be denied.   

`GET /:user_name/recipes?token=token` - Returns list of recipes that a user has created.
```ruby
  {
    recipes: [
    {
      id: integer,
      name: recipe_name,
      user_id: integer
    },
    ...
    ]
  }
```

`POST /:user_name/recipes?token=token` - Creates a new `Recipe` with associated `Ingredient` and `RecipeIngredient` records

Example payload sent to endpoint
```ruby
  {
    name: 'Baguette',
    ingredients: {
      'Flour' => {amount: 1.00},
      'Water' => {amount: 0.62},
      'Salt' => {amount: 0.02},
      'Yeast' => {amount: 0.02}
    }
  }
```

The response from the the `POST` request contains the submitted information along with baker's percentage(`bp`) and `total_percentage`. As seen below with the `GET` for a single recipe.

`GET /:user_name/recipes/:recipe_name?token=token` - Returns specific recipe.  
Example JSON response

```ruby
  {
    status: 200,
    recipe: {
      name: 'Baguette',
      ingredients: {
        'Flour' => {amount: 1.00, bp: 100.0},
        'Water' => {amount: 0.62, bp: 65.0},
        'Salt' => {amount: 0.02, bp: 2.0},
        'Yeast' => {amount: 0.02, bp: 2.0}
      },
      total_percentage: 169.0
    } 
  }
```
  
  
