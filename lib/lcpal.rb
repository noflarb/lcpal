require 'mechanize'
require 'hpricot'

class LCPAL
  SEARCH_PAGE = 'http://www.leonpa.org/search2.cfm'
  
  def initialize
    @agent = WWW::Mechanize.new
    # @agent.set_proxy 'localhost', '8888'
  end
  
  # Search for accounts by name and get an array of account numbers
  def search params
    @search_form ||= get_form
    complete_form( params )
    @results_page = submit_form
    # TODO: handle multiple pages of results
    return parse_results
  end
  
  private
   
   # get the mechanize representation of the search form
    def get_form
      page = @agent.get SEARCH_PAGE
      page.form_with :action => 'results.cfm'
    end
    
    # set all the form search fields to blank values
    def reset_form
      #all the form inputs have to be present for the search to work, even if they're empty strings
      %w(ACCT fname lname number DIRECTION STREET SUFFIX).each do |k|
        @search_form[k] = ''
      end
    end
    
    # fill out the search form with the hash values
    def complete_form params
      reset_form
      params.each do |k,v|
        case k
        when :first_name
          @search_form['fname'] = v
        when :last_name
          @search_form['lname'] = v
        else
          @search_form[k.to_s] = v
        end
      end
    end
    
    # execute the search by posting the form
    def submit_form
      @agent.submit @search_form
    end
    
    # using an HTML parser like HPricot and searching with xpath would be the ideal way to do this
    # however, the html on the results page is so bad, most parsers will choke on it
    # we therefore have to resort to scanning the html as a string
    def parse_results
      @results_page.body.scan(/ACCT\.cfm\?ACCOUNT=(\d*)/).flatten
    end
end