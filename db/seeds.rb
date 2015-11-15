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



SEED_MULTIPLER = 1


NYT_RECIPE_URLS = [
  "http://cooking.nytimes.com/recipes/12878-maple-pecan-pancakes",
  "http://cooking.nytimes.com/recipes/1017125-amaranth-porridge-with-grated-apples-and-maple-syrup",
  "http://cooking.nytimes.com/recipes/1016605-the-only-ice-cream-recipe-youll-ever-need",
  "http://cooking.nytimes.com/recipes/1017426-eggplant-with-lamb-tomato-and-pine-nuts",
  "http://cooking.nytimes.com/recipes/1017758-sticky-cranberry-gingerbread",
  "http://cooking.nytimes.com/recipes/1017700-meatballs-with-any-meat"
]



# Build test users
foobar = User.create( :email => 'foobar@foo.com',
                      :password => 'password')
foobar.create_profile(:first_name => "Foo",
                      :last_name => "Bar",
                      :location => "Footown, OH")


# Build other users
(5*SEED_MULTIPLER).times do

  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  full_name = first_name + " " + last_name

  u = User.create(:email => Faker::Internet.email(full_name),
                  :password => 'password')
  u.create_profile( :first_name => first_name,
                    :last_name => last_name,
                    :location => Faker::Address.city + ", " + Faker::Address.state)
end


def scrape(recipe)
  # should not need to sleep here because that's included in Rake task
  Rake::Task['recipes:scrape_nyt'].invoke(recipe)
  Rake::Task['recipes:scrape_nyt'].reenable
end


# Add some recipes for each user
User.all.each do |user|

  (rand(2..4)*SEED_MULTIPLER).times do
    recipe = user.recipes.create(:url => NYT_RECIPE_URLS.sample)
    scrape(recipe)
  end

end