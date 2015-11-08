require 'mechanize'
require 'csv'

Recipe = Struct.new(:title, :description, :url, :steps, :author, :ingredients, :photo_url)

scraper = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.history_added = Proc.new { sleep 0.5 } # just in case
end

recipe = Recipe.new

scraper.get('http://cooking.nytimes.com/recipes/1016329-red-velvet-cake') do |page|

  recipe.title = page.search('.recipe-title').text.strip
  recipe.description = page.search('.topnote > p:not(.related-article)').text.strip
  recipe.url = page.uri.to_s

  recipe.steps = []
  page.search('.recipe-steps').children.each_with_index do |step, index|
    recipe.steps[index] = step.text.strip
    recipe.steps = recipe.steps.reject { |r| r.to_s.empty? }
  end

  recipe.author = page.search('.byline-name').text.strip

  recipe.ingredients = []
  page.search('.recipe-ingredients')[0].children.each_with_index do |step, index|
    recipe.ingredients[index] = step.text.strip.gsub("\n", '').squeeze("             ")
    recipe.ingredients = recipe.ingredients.reject { |r| r.to_s.empty? }
  end

  recipe.photo_url = page.search('.media-container').children[1]['src']
end

# puts recipe.title
# puts recipe.description
# puts recipe.url
# puts recipe.steps
# puts recipe.author
# puts recipe.ingredients
# puts recipe.photo_url

CSV.open('recipe.csv', 'a') do |csv|
  csv << [ recipe.title, recipe.description, recipe.url, recipe.steps, recipe.author, recipe.ingredients, recipe.photo_url ]
end
