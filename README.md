# Bread Shop API [![Build Status](https://travis-ci.org/mikeyduece/bread_shop.svg?branch=master)](https://travis-ci.org/mikeyduece/bread_shop)

[![Waffle.io - Columns and their card count](https://badge.waffle.io/mikeyduece/bread_shop.svg?columns=all)](https://waffle.io/mikeyduece/bread_shop)


##### Versions

<sup>Ruby 2.5.0</sup> <sup>/</sup> <sup>Rails 5.1.5</sup>

---

### Endpoints
All requests require token from client app to be sent in the params. If no token is present, the request will be denied.

Base URL for all requests is `https://bread-shop-api.herokuapp.com/api/v1`

`GET /users/:id/recipes?token=token` - Returns list of recipes that a user has created.

```ruby
[
  {
    :id=>1,
    :name=>"1Recipe",
    :tags=>[],
    :total_percent=>nil,
    :ingredient_list=>
     { 
      :"9Ingredient"=>{:amount=>8.64, :bakers_percentage=>nil}, 
      :"8Ingredient"=>{:amount=>6.01, :bakers_percentage=>nil},
      :"7Ingredient"=>{:amount=>3.38, :bakers_percentage=>nil} 
    },
    :family=>"Sweet",
    :created_at=>"Created on 24 JUL '18 at 16:57",
    :user=>{:id=>1, :name=>"Jamis", :email=>"giovanna@kleinmurray.info", :uid=>"1uid", :zipcode=>"53370-1675"}
  },
  ...
]
```    

`POST /users/:id/recipes?token=token` - Creates a new `Recipe` with associated `Ingredient` and `RecipeIngredient` records

Example payload sent to endpoint:
```ruby
  {
    {
      name: 'baguette',
      ingredients: [
        { name: 'flour', amount: 1.00 },
        { name: 'water', amount: 0.62 },
        { name: 'yeast', amount: 0.02 },
        { name: 'salt', amount: 0.02 }
      ]
    }
```

The response from the the `POST` request contains the submitted information along with baker's percentage and `total_percentage`. As seen below with the `GET` for a single recipe.

`GET /users/:id/recipes/:recipe_id?token=token` - Returns specific recipe.
Example JSON response

```ruby
  {
    :id=>1,
    :name=>"1Recipe",
    :tags=>["awesome", "bread"],
    :total_percent=>441.48,
    :ingredient_list=>
     {
       :"51Ingredient"=>{:amount=>1.37, :bakers_percentage=>20.66},
       :"50Ingredient"=>{:amount=>6.9, :bakers_percentage=>104.07},
       :"49Ingredient"=>{:amount=>2.36, :bakers_percentage=>35.6},
       :"48Ingredient"=>{:amount=>7.14, :bakers_percentage=>107.69},
       :"47Ingredient"=>{:amount=>0.81, :bakers_percentage=>12.22},
       :"46Ingredient"=>{:amount=>4.06, :bakers_percentage=>61.24},
       :flour=>{:amount=>6.63, :bakers_percentage=>100.0} 
     },
   :family=>"Rich",
   :created_at=>"Created on 24 JUL '18 at 16:54"
  }
```

`GET /families?family_name=:family_name&token=token` Returns a list of all recipes that are associated with that family_name.

```ruby
{
  :name=>"Soft",
  :recipes=>
  [
    {
      :id=>1,
      :name=>"1Recipe",
      :tags=>[],
      :total_percent=>nil,
      :ingredient_list=>
       {
         :"9Ingredient"=>{:amount=>3.94, :bakers_percentage=>nil},
         :"8Ingredient"=>{:amount=>0.15, :bakers_percentage=>nil},
         :"7Ingredient"=>{:amount=>4.1, :bakers_percentage=>nil}
       },
      :family=>"Soft",
      :created_at=>"Created on 24 JUL '18 at 17:00"
    },
    ...
  ]
}
```

`GET /recipes/:recipe_id/new_totals` Given a request with a recipe and amounts, the request params would look like so.

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
  :id=>"5",
  :name=>"baguette1",
  :tags=>[""],
  :total_percent=>"166.0",
  :ingredient_list=>
    {
      :salt=>{:amount=>0.04, :bakers_percentage=>"2.0"},
      :yeast=>{:amount=>0.04, :bakers_percentage=>"2.0"},
      :water=>{:amount=>1.24, :bakers_percentage=>"62.0"},
      :flour=>{:amount=>2.0, :bakers_percentage=>"100.0"}
    },
 :family=>"Lean",
 :created_at=>"Created on 24 JUL '18 at 17:02"
}
```

##### Likes
`POST /users/:id/like/:recipe_id` 
>Allows one user to like another users recipes

`DELETE /users/:id/unlike/:recipe_id` 
>Allows a user to unlike a recipe that they previously 'liked'.


---
### Activity Feed
#### Follows

`POST /users/:id/follow/:target_id` 

>Allows one user to follow another. Once the follow record is persisted, the target user is sent a notification.

`DELETE /users/:id/unfollow/:target_id`

>Allows a user to unfollow a user if already followed.

#### Notification

`GET /users/:id/feeds/notification`

>Sends the notification to the user when followed. Also sends notification to the user who initiated the follow, of when the target user creates a new recipe or when someone likes one of their recipes.

#### Flat Feed

`GET /users/:id/feeds/flat`

>Gets the feed for a given user. So far, showing when another user (that the current user follows) creates a new recipe

#### Nutrition Label
Analysis of recipe information provided by [Edamam](https://www.edamam.com/)


`GET /recipes/:recipe_id/label?token=token`

JSON return is formatted as follows:

```ruby
{:uri=>"http://www.edamam.com/ontologies/edamam.owl#recipe_214022f9049e45f08add17c376e94174",
 :yield=>"6.0",
 :calories=>"1134",
 :totalWeight=>"366.9477944061093",
 :dietLabels=>"[\"LOW_FAT\"]",
 :healthLabels=>"[\"SUGAR_CONSCIOUS\", \"VEGAN\", \"VEGETARIAN\", \"PEANUT_FREE\", \"TREE_NUT_FREE\", \"ALCOHOL_FREE\"]",
 :cautions=>"[]",
 :totalNutrients=>
  "{:ENERC_KCAL=>{:label=>\"Energy\", :quantity=>1134.6358003197763, :unit=>\"kcal\"}, :FAT=>{:label=>\"Fat\", :quantity=>7.236244240028524, :unit=>\"g\"}, :FASAT=>{:label=>\"Saturated\", :quantity=>1.0187089435831413, :unit=>\"g\"}, :FAMS=>{:label=>\"Monounsaturated\", :quantity=>2.89822568212125, :unit=>\"g\"}, :FAPU=>{:label=>\"Polyunsaturated\", :quantity=>1.0689896390453246, :unit=>\"g\"}, :CHOCDF=>{:label=>\"Carbs\", :quantity=>221.158655373815, :unit=>\"g\"}, :FIBTG=>{:label=>\"Fiber\", :quantity=>23.620539579684102, :unit=>\"g\"}, :SUGAR=>{:label=>\"Sugars\", :quantity=>0.6919551575150892, :unit=>\"g\"}, :PROCNT=>{:label=>\"Protein\", :quantity=>51.581050685490524, :unit=>\"g\"}, :NA=>{:label=>\"Sodium\", :quantity=>848.4708254170117, :unit=>\"mg\"}, :CA=>{:label=>\"Calcium\", :quantity=>58.96385049716603, :unit=>\"mg\"}, :MG=>{:label=>\"Magnesium\", :quantity=>90.39350476839596, :unit=>\"mg\"}, :K=>{:label=>\"Potassium\", :quantity=>867.3025375480865, :unit=>\"mg\"}, :FE=>{:label=>\"Iron\", :quantity=>4.352621896354764, :unit=>\"mg\"}, :ZN=>{:label=>\"Zinc\", :quantity=>6.73028187609825, :unit=>\"mg\"}, :P=>{:label=>\"Phosphorus\", :quantity=>672.2664257899635, :unit=>\"mg\"}, :VITC=>{:label=>\"Vitamin C\", :quantity=>0.1862563717977682, :unit=>\"mg\"}, :THIA=>{:label=>\"Thiamin (B1)\", :quantity=>7.13072737908717, :unit=>\"mg\"}, :RIBF=>{:label=>\"Riboflavin (B2)\", :quantity=>2.5859301658243297, :unit=>\"mg\"}, :NIA=>{:label=>\"Niacin (B3)\", :quantity=>28.161849920507834, :unit=>\"mg\"}, :VITB6A=>{:label=>\"Vitamin B6\", :quantity=>1.0440449216950036, :unit=>\"mg\"}, :FOLDFE=>{:label=>\"Folate equivalent (total)\", :quantity=>1519.4324188944154, :unit=>\"µg\"}, :FOLFD=>{:label=>\"Folate (food)\", :quantity=>1519.4324188944154, :unit=>\"µg\"}, :VITB12=>{:label=>\"Vitamin B12\", :quantity=>0.04345982008614591, :unit=>\"µg\"}, :TOCPHA=>{:label=>\"Vitamin E\", :quantity=>0.1537678127811309, :unit=>\"mg\"}, :VITK1=>{:label=>\"Vitamin K\", :quantity=>1.0171808929693453, :unit=>\"µg\"}}",
 :totalDaily=>
  "{:ENERC_KCAL=>{:label=>\"Energy\", :quantity=>56.731790015988814, :unit=>\"%\"}, :FAT=>{:label=>\"Fat\", :quantity=>11.13268344619773, :unit=>\"%\"}, :FASAT=>{:label=>\"Saturated\", :quantity=>5.093544717915707, :unit=>\"%\"}, :CHOCDF=>{:label=>\"Carbs\", :quantity=>73.71955179127167, :unit=>\"%\"}, :FIBTG=>{:label=>\"Fiber\", :quantity=>94.4821583187364, :unit=>\"%\"}, :PROCNT=>{:label=>\"Protein\", :quantity=>103.16210137098105, :unit=>\"%\"}, :NA=>{:label=>\"Sodium\", :quantity=>35.352951059042155, :unit=>\"%\"}, :CA=>{:label=>\"Calcium\", :quantity=>5.896385049716603, :unit=>\"%\"}, :MG=>{:label=>\"Magnesium\", :quantity=>22.59837619209899, :unit=>\"%\"}, :K=>{:label=>\"Potassium\", :quantity=>24.7800725013739, :unit=>\"%\"}, :FE=>{:label=>\"Iron\", :quantity=>24.181232757526466, :unit=>\"%\"}, :ZN=>{:label=>\"Zinc\", :quantity=>44.868545840654996, :unit=>\"%\"}, :P=>{:label=>\"Phosphorus\", :quantity=>96.03806082713764, :unit=>\"%\"}, :VITC=>{:label=>\"Vitamin C\", :quantity=>0.3104272863296137, :unit=>\"%\"}, :THIA=>{:label=>\"Thiamin (B1)\", :quantity=>475.381825272478, :unit=>\"%\"}, :RIBF=>{:label=>\"Riboflavin (B2)\", :quantity=>152.11353916613703, :unit=>\"%\"}, :NIA=>{:label=>\"Niacin (B3)\", :quantity=>140.80924960253918, :unit=>\"%\"}, :VITB6A=>{:label=>\"Vitamin B6\", :quantity=>52.20224608475018, :unit=>\"%\"}, :FOLDFE=>{:label=>\"Folate equivalent (total)\", :quantity=>379.85810472360384, :unit=>\"%\"}, :VITB12=>{:label=>\"Vitamin B12\", :quantity=>0.7243303347690985, :unit=>\"%\"}, :TOCPHA=>{:label=>\"Vitamin E\", :quantity=>0.7688390639056546, :unit=>\"%\"}, :VITK1=>{:label=>\"Vitamin K\", :quantity=>1.2714761162116817, :unit=>\"%\"}}"}
  ```
