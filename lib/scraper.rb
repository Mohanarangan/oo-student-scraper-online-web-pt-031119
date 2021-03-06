require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
      doc.css("div.roster-cards-container").each do |card|
      card.css("div.student-card a").each do |student|
         student_name = student.css('.student-name').text
         student_location = student.css('.student-location').text

         student_profile_url = student.attr('href')

         students << {name: student_name , location: student_location, profile_url: student_profile_url}
        end
     end
     students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    doc = Nokogiri::HTML(open(profile_url))
    
    links = doc.css(".social-icon-container a" ).map { |el| el.attr('href')}

    links = doc.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}

    
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end

    
    
    
    student[:profile_quote] = doc.css(".profile-quote").text if doc.css(".profile-quote")
    
    student[:bio] = doc.css("div.description-holder p").text if doc.css("div.description-holder p")

    
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")


    student
  end

end

# find CSS selector for parent of all pictures.
#iterate over each picture and extract the name, location, profile- url
# create a hash for every picture and push it to array.


