require 'mechanize'

module DataMapper
  module Adapters
    class LcpaAdapter < AbstractAdapter
      SEARCH_PAGE = 'http://www.leonpa.org/search2.cfm'
      SUPPORTED_PROPERTIES = [:first_name, :last_name, :person_first_name, :person_last_name]

      def initialize(name, options)
        @agent = WWW::Mechanize.new
        @search_form ||= get_form
        @agent.set_proxy 'localhost', '8888'
      end

      def read_many(query)
        Collection.new(query) do |set|
          read(query, set, true)
        end
      end

      def read_one(query)
        read(query, query.model, false)
      end

      private

      # query = the DM Query instance
      # set = a Collection instance
      # arr boolean used to specify if the returned value should be an array or a single object instance
      def read(query, set, arr = true)
        options = extract_options(query.conditions)
        
        repository_name = query.repository.name
        properties = query.fields
        
        # begin
          complete_form( options )
          results_page = submit_form
          results = parse_results( results_page, query )
        # rescue
          # raise "Couldn't retrieve the data"
        # end
        results.each do |values|
          # values = result_values(result, properties, repository_name)
          # This is the core logic that handles the difference between all/first
          arr ? set.load(values) : (break set.load(values, query))
        end if results
        
      end
      
      def result_values(result, properties, repository_name)
        properties.map { |p| result.send(p.field(repository_name)) }
      end
      
      def extract_options(query_conditions)
        options = {}

        query_conditions.each do |condition|
          operator, property, value = condition
          raise "Property: #{property.name} not supported" unless SUPPORTED_PROPERTIES.include? property.name
          case operator
          when :eql, :in
            options[property.name] = value
          else
            raise "Query operator: #{operator.inspect} not supported."
          end
        end

        options
      end
      
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
          when :first_name, :person_first_name
            @search_form['fname'] = v
          when :last_name, :person_last_name
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
      # def parse_results
      #   @results_page.body.scan(/ACCT\.cfm\?ACCOUNT=(\d*)/).flatten
      # end
      
      def parse_results results_page, query
        model = query.model
        case model.to_s
        when 'LCPAL::Person'
          # just give back the person searched for, if he exists
          if results_page.body=~/Records \d thru \d of \d/
            arr = []
            arr << \
            query.conditions.inject([]) do |arr,tuple|
              operator, property, bind_value = *tuple
              arr << bind_value
              arr
            end
          else
            nil
          end
        when 'LCPAL::Parcel'
          results = []
          first_name = query.conditions.select{|condition| condition[1].name == :person_first_name}.first.last
          last_name = query.conditions.select{|condition| condition[1].name == :person_last_name}.first.last
          results_page.body.scan(/ACCT\.cfm\?ACCOUNT=(\d*)/).flatten.map{|id| [id,first_name,last_name]}
        else
          nil
        end
      end
      
    end
  end
end