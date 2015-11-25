require 'mechanize'


namespace :recipes do
  desc 'Scrapes recipe from Epicurious'
  task :scrape_epicurious, [:recipe] => :environment do |t, args|

    scraper = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.history_added = Proc.new { sleep 0.5 } # just in case
    end

    recipe = Recipe.find(args.recipe.id)

    scraper.get(recipe.url) do |page|

      recipe.title = page.search('.title-source h1').text.strip
      recipe.description = page.search('.dek p').text.strip
      recipe.url = page.uri.to_s

      # instructions
      recipe.instructions.delete_all
      page.search('.preparation-steps').children.each_with_index do |step, index|
        recipe.instructions.build(body: step.text.strip) unless step.text.strip.to_s.empty?
      end

      recipe.author = page.search('.byline.author').text.strip

      # ingredients
      recipe.ingredients.delete_all
      page.search('li.ingredient').each_with_index do |step, index|
        recipe.ingredients.build(name: step.text.strip.gsub(/\s+/, " ")) unless step.text.strip.to_s.empty?
      end

      recipe.photo_url = nil
      meta_property = page.at('meta[property="og:image"]')[:content]
      recipe.photo_url = meta_property unless meta_property.empty?
    end

    recipe.save!

  end
end