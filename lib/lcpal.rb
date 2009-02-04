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
    search_form = get_form
    complete_form( search_form, params )
    results_page = submit_form( search_form )
    # TODO: handle multiple pages of results
    return parse_results( results_page.body )
  end
  
  private
   
    def get_form
      page = @agent.get SEARCH_PAGE
      page.form_with :action => 'results.cfm'
    end
    
    def complete_form form, params
      #all the form inputs have to be present for the search to work, even if they're empty strings
      %w(ACCT fname lname number DIRECTION STREET SUFFIX).each do |k|
        form[k] = ''
      end
        
      params.each do |k,v|
        case k
        when :first_name
          form['fname'] = v
        when :last_name
          form['lname'] = v
        else
          form[k.to_s] = v
        end
      end
    end
    
    def submit_form form
      @agent.submit form
    end
    
    # using an HTML parser like HPricot and searching with xpath would be the ideal way to do this
    # however, the html on the results page is so bad, most parsers will choke on it
    # we therefore have to resort to scanning the html as a string
    def parse_results html # :nodoc:
      html.scan(/ACCT\.cfm\?ACCOUNT=(\d*)/).flatten
    end
end