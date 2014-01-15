require 'sanitize'

module Prestashop
  module Mapper
    module Refinement
      refine String do 
        def plain
          self.clean.delete('<>;=#{}')
        end

        def clean
          Sanitize.clean self.unescape
        end

        def restricted
          Sanitize.clean(self.unescape, Sanitize::Config::RESTRICTED)
        end

        def relaxed
          Sanitize.clean(self.unescape, Sanitize::Config::RELAXED)
        end

        def unescape
          CGI.unescapeHTML(self)
        end

        def html enabled
          enabled ? self.unescape : self.relaxed
        end

        def truncate number = 0
          self.slice(0, number)
        end
      end

      refine Hash do 
        def clean!
          reject{|k,v| v.nil? or v.empty?}
        end

        def lang_search value, id_lang = nil
          id_lang = Prestashop::Client.settings.id_language unless id_lang
          if self[:language].kind_of?(Array) 
            self[:language].find{|l| l[:val] == value and l[:attr][:id] == id_lang}
          else
            self[:language][:val] == value and self[:language][:attr][:id] == id_lang
          end
        end

        def find_lang value, id_lang
          if self[:language].kind_of?(Array) 
            self[:language].find{|l| l[:val] == value and l[:attr][:id] == id_lang}
          else
            self[:language][:val] == value and self[:language][:attr][:id] == id_lang
          end
        end
      end
    end
  end
end