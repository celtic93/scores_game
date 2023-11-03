# frozen_string_literal: true

class Match::Parser
  LIVE_SCORES_WEBSITE = 'https://www.livesoccertv.com/match/'

  def extract_link(link_path)
    uri = "#{LIVE_SCORES_WEBSITE}#{link_path}"
    page = Nokogiri::HTML(URI.parse(uri).open)

    home_team = page.css('body > div.lstv-grid > main > div.m-teams > a:nth-child(1)')[0]&.text
    guest_team = page.css('body > div.lstv-grid > main > div.m-teams > a:nth-child(3)')[0]&.text
    result = page.css('body > div.lstv-grid > main > div.m-logos > div.m-score > div.m-result')[0]&.text
    status = page.css('body > div.lstv-grid > main > div.m-logos > div.m-score > div.m-status')[0]&.text

    Result.new(home_team, guest_team, result, status)
  end

  class Result
    attr_reader :home_team, :guest_team, :result, :status

    def initialize(home_team, guest_team, result, status)
      @home_team = home_team
      @guest_team = guest_team
      @result = result
      @status = status
    end
  end
end
