require 'mechanize'

namespace :recipes do
  desc 'Scrapes recipe from Food Network'
  task :scrape_fn, [:recipe] => :environment do |t, args|

    scraper = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.history_added = Proc.new { sleep 0.5 } # just in case
    end

    recipe = Recipe.find(args.recipe.id)

    scraper.get(recipe.url) do |page|

      recipe.title = page.search('h1[itemprop=name]').text.strip

      # having troubles with this one
      recipe.description = nil
      # recipe.description = page.at('body > div:nth-child(11) > div.row.split > article > div > section.lead-overview.section > div > div > div.col18 > p > q > span:nth-child(1)')      recipe.url = page.uri.to_s

      # instructions
      recipe.instructions.delete_all
      page.search('div[itemprop=recipeInstructions] > p:not(.copyright)').children.each_with_index do |step, index|
        recipe.instructions.build(body: step.text.strip.gsub( /<.+?>/, " ")) unless step.text.strip.to_s.empty?
      end

      recipe.author = page.search('div[itemprop=author] span[itemprop=name]').text.strip

      # ingredients
      recipe.ingredients.delete_all
      page.search('li[itemprop=ingredients]').each_with_index do |step, index|
        recipe.ingredients.build(body: step.text.strip.gsub(/\s+/, " ")) unless step.text.strip.to_s.empty?
      end

      recipe.photo_url = page.search("img[itemprop=image]").attribute('src')
    end

    recipe.save!

  end
end
