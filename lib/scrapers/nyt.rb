require 'mechanize'
require 'csv'

Recipe = Struct.new(:title, :description, :url, :steps, :author, :ingredients, :photo_url)

scraper = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.history_added = Proc.new { sleep 0.5 } # just in case
end

recipe = Recipe.new

scraper.get('http://cooking.nytimes.com/recipes/1017773-fannie-farmers-parker-house-rolls') do |page|

  recipe.title = page.search('.recipe-title').text.strip
  recipe.description = page.search('.topnote > p:not(.related-article)').text.strip
  recipe.url = page.uri.to_s

  recipe.steps = []
  page.search('.recipe-steps').children.each_with_index do |step, index|
    recipe.steps << step.text.strip unless step.text.strip.to_s.empty?
  end

  recipe.author = page.search('.byline-name').text.strip

  recipe.ingredients = []
  page.search('.recipe-ingredients')[0].children.each_with_index do |step, index|
    recipe.ingredients << step.text.strip.gsub(/\s+/, " ") unless step.text.strip.to_s.empty?
  end

  recipe.photo_url = page.search('.media-container').children[1]['src']
end

# debug
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
