# Bread Shop API [![Build Status](https://travis-ci.org/mikeyduece/bread_shop.svg?branch=master)](https://travis-ci.org/mikeyduece/bread_shop)

[![Waffle.io - Columns and their card count](https://badge.waffle.io/mikeyduece/bread_shop.svg?columns=all)](https://waffle.io/mikeyduece/bread_shop)


##### Versions

<sup>Ruby 2.5.0</sup> <sup>/</sup> <sup>Rails 5.1.5</sup>

---

### Endpoints
All requests require token from client app to be sent in the params. If no token is present, the request will be denied.

Base URL for all requests is `https://bread-shop-api.herokuapp.com/api/v1`

`GET /users/:email/recipes?token=token` - Returns list of recipes that a user has created.

```ruby
{
  recipes: [
  {
    id: integer,
    name: recipe_name,
    user_id: integer,
    created_at: date
  },
  ...
  ]
}
```    

`POST /users/:email/recipes?token=token` - Creates a new `Recipe` with associated `Ingredient` and `RecipeIngredient` records

Example payload sent to endpoint:
```ruby
  {
    name: 'baguette',
    ingredients: {
      'flour' => {amount: 1.00},
      'water' => {amount: 0.62},
      'salt' => {amount: 0.02},
      'yeast' => {amount: 0.02}
    }
  }
```

The response from the the `POST` request contains the submitted information along with baker's percentage and `total_percentage`. As seen below with the `GET` for a single recipe.

`GET /users/:email/recipes/:recipe_name?token=token` - Returns specific recipe.
Example JSON response

```ruby
  {
    status: 200,
    recipe: {
      name: 'baguette',
      ingredients: {
        'flour' => {amount: 1.00, bakers_percentage: 100.0},
        'water' => {amount: 0.65, bakers_percentage: 65.0},
        'salt' => {amount: 0.02, bakers_percentage: 2.0},
        'yeast' => {amount: 0.02, bakers_percentage: 2.0}
      },
      total_percentage: 169.0
    }
  }
```

`GET /families?token=token` Returns a list of all recipes grouped by family name.

```ruby
  {
    status: 200,
    recipes: {
      [
        'Lean' => [{
          name: 'Recipe Name',
          family: 'Lean'
          user: {
            name: 'Name',
            email: 'email@email.com'
          },
          ...
          }]
      ]
    }
  }
```

`GET /families/:family_name?token=token` Returns a list of all recipes that are associated with that family_name.

```ruby
  [
    {
    recipe_name: 'Recipe Name',
    family: 'Family Name',
    user: {
      name: 'Name',
      email: 'email@email.com'
          }
    },
  ...
  ]
```

`GET /recipes/:recipe_name/new_totals` Given a request with a recipe and amounts, the request params would look like so.

```Ruby
  {
    recipe: {
      name: 'baguette',
      ingredients: {
        'flour' => { amount: 1.00, bakers_percentage: 100.0 },
        'water' => { amount: 0.62, bakers_percentage: 62.0  },
        'yeast' => { amount: 0.02, bakers_percentage: 2.0 },
        'salt'  => { amount: 0.02, bakers_percentage: 2.0 }
      },
      total_percentage: 166.0,
      new_dough_weight: 10.0
    }
  }
```

The return from the previous request would be the recipe with the new amounts.
```Ruby
  {
    recipe: {
      name: 'baguette',
      ingredients: {
        'flour' => { amount: 6.02 },
        'water' => { amount: 3.73 },
        'yeast' => { amount: 0.12 },
        'salt'  => { amount: 0.12 }
      },
      total_percentage: 166.0
    }
  }
```

---
### Activity Feed
#### Follows

`POST /users/:email/follow/:target_email` 

>Allows one user to follow another. Once the follow record is persisted, the target user is sent a notification.

`DELETE /users/:email/unfollow/:target_email`

>Allows a user to unfollow a user if already followed.

#### Notification

`GET /users/:email/feeds/notification`

>Sends the notification to the user when followed.

#### Flat Feed

`GET /users/:email/feeds/flat`

>Gets the feed for a given user. So far, showing when another user (that the current user follows) creates a new recipe
