# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Profile.delete_all
Recipe.delete_all
Ingredient.delete_all
Instruction.delete_all
Note.delete_all
Followership.delete_all
Share.delete_all



SEED_MULTIPLIER = 1
SQRT_MULTIPLIER = Math.sqrt(SEED_MULTIPLIER).to_i


NYT_RECIPE_URLS = [
  "http://cooking.nytimes.com/recipes/12878-maple-pecan-pancakes",
  "http://cooking.nytimes.com/recipes/1017125-amaranth-porridge-with-grated-apples-and-maple-syrup",
  "http://cooking.nytimes.com/recipes/1016605-the-only-ice-cream-recipe-youll-ever-need",
  "http://cooking.nytimes.com/recipes/1017426-eggplant-with-lamb-tomato-and-pine-nuts",
  "http://cooking.nytimes.com/recipes/1017758-sticky-cranberry-gingerbread",
  "http://cooking.nytimes.com/recipes/1017700-meatballs-with-any-meat"
]

EPI_RECIPE_URLS = [
  "http://www.epicurious.com/recipes/food/views/spiced-sweet-potato-and-parsnip-tian",
  "http://www.epicurious.com/recipes/food/views/pretzel-rolls-1107",
  "http://www.epicurious.com/recipes/food/views/caramel-chicken-51193220",
  "http://www.epicurious.com/recipes/food/views/peanut-and-scallion-relish-51224040",
  "http://www.epicurious.com/recipes/food/views/extra-buttery-mashed-spuds-51255540",
  "http://www.epicurious.com/recipes/food/views/spicy-shellfish-and-sausage-stew-108560"
]

FN_RECIPE_URLS = [
  "http://www.foodnetwork.com/recipes/food-network-kitchens/shrimp-and-chorizo-stew-recipe.html",
  "http://www.foodnetwork.com/recipes/food-network-kitchens/butternut-squash-soup-with-chicken-sausage-recipe.html",
  "http://www.foodnetwork.com/recipes/food-network-kitchens/moussaka-recipe4.html",
  "http://www.foodnetwork.com/recipes/patrick-and-gina-neely/fried-deviled-eggs-recipe.html",
  "http://www.foodnetwork.com/recipes/ree-drummond/all-purpose-meatballs.html",
  "http://www.foodnetwork.com/recipes/ina-garten/roasted-brussels-sprouts-recipe2.html"
]

ALL_URLS = NYT_RECIPE_URLS + EPI_RECIPE_URLS + FN_RECIPE_URLS



# Build test users
foobar = User.create( :email => 'foobar@foo.com',
                      :password => 'password')
foobar.create_profile(:first_name => "Foo",
                      :last_name => "Bar",
                      :location => "Footown, OH",
                      :avatar => open(Faker::Avatar.image.gsub(':', 's:')))


# Build other users
(5*SEED_MULTIPLIER).times do

  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  full_name = first_name + " " + last_name

  u = User.create(:email => Faker::Internet.email(full_name),
                  :password => 'password')
  u.create_profile( :first_name => first_name,
                    :last_name => last_name,
                    :location => Faker::Address.city + ", " + Faker::Address.state,
                    :avatar => open(Faker::Avatar.image.gsub(':', 's:')))
end


def scrape(recipe)
  # should not need to sleep here because that's included in Rake task
  site = URI.parse(recipe.url).host

  if site == "cooking.nytimes.com"
    Rake::Task['recipes:scrape_nyt'].invoke(recipe)
    Rake::Task['recipes:scrape_nyt'].reenable
  elsif site == "www.epicurious.com"
    Rake::Task['recipes:scrape_epicurious'].invoke(recipe)
    Rake::Task['recipes:scrape_epicurious'].reenable
  elsif site == "www.foodnetwork.com"
    Rake::Task['recipes:scrape_fn'].invoke(recipe)
    Rake::Task['recipes:scrape_fn'].reenable
  end
end


User.all.each do |user|

  # Add some recipes for each user
  (rand(2..4)*SQRT_MULTIPLIER).times do
    recipe = user.recipes.create(:url => ALL_URLS.sample)
    scrape(recipe)
  end


  # Make each user follow some other users
  user.following << User.all.sample(rand(0..3)*SQRT_MULTIPLIER)


  # Make each user share a recipe
  user.outgoing_shares.create(recipe_id: user.recipes.sample.id,
                              recipient_id: user.following.sample.id
                              ) unless user.following.empty?

end