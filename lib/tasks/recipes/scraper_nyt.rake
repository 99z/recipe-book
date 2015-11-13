require 'mechanize'


namespace :recipes do
  desc 'Scrapes recipe from NYT'
  task :scrape_nyt, [:recipe] => :environment do |t, args|

    scraper = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      # agent.history_added = Proc.new { sleep 0.5 } # just in case
    end

    recipe = Recipe.find(args.recipe.id)

    scraper.get(recipe.url) do |page|

      recipe.title = page.search('.recipe-title').text.strip
      recipe.description = page.search('.topnote > p:not(.related-article)').text.strip
      recipe.url = page.uri.to_s

      # instructions
      recipe.instructions.delete_all
      page.search('.recipe-steps').children.each_with_index do |step, index|
        recipe.instructions.build(body: step.text.strip) unless step.text.strip.to_s.empty?
      end

      recipe.author = page.search('.byline-name').text.strip

      # ingredients
      recipe.ingredients.delete_all
      page.search('.recipe-ingredients')[0].children.each_with_index do |step, index|
        recipe.ingredients.build(name: step.text.strip.gsub(/\s+/, " ")) unless step.text.strip.to_s.empty?
      end

      # get an error for undefined method [] if no pic
      media_container = page.search('.media-container')
      recipe.photo_url = media_container.children[1]['src'] unless media_container.empty?
    end


    recipe.save!


  end
end