require 'mechanize'


namespace :recipes do
  desc 'Scrapes recipe from NYT'
  task :scrape_nyt, [:url] => :environment do |t, args|



    # Recipe = Struct.new(:title, :description, :url, :steps, :author, :ingredients, :photo_url)

    scraper = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.history_added = Proc.new { sleep 0.5 } # just in case
    end

    recipe = Recipe.new

    scraper.get(args.url) do |page|

      recipe.title = page.search('.recipe-title').text.strip
      #recipe.description = page.search('.topnote > p:not(.related-article)').text.strip
      #recipe.url = page.uri.to_s

      #recipe.steps = []
      page.search('.recipe-steps').children.each_with_index do |step, index|
        recipe.instructions.build(body: step.text.strip) unless step.text.strip.to_s.empty?
      end

      recipe.author = page.search('.byline-name').text.strip

      #recipe.ingredients = []
      page.search('.recipe-ingredients')[0].children.each_with_index do |step, index|
        recipe.ingredients.build(name: step.text.strip.gsub(/\s+/, " ")) unless step.text.strip.to_s.empty?
        #recipe.ingredients << step.text.strip.gsub(/\s+/, " ") unless step.text.strip.to_s.empty?
      end

      recipe.photo_url = page.search('.media-container').children[1]['src']
      recipe.user_id = 1
    end


    recipe.save!


  end
end