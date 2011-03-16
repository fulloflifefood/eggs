module Webrat
  class Link < Element
    def http_method
      if !@element["data-method"].blank?
        @element["data-method"]
      elsif !onclick.blank? && onclick.include?("f.submit()")
        http_method_from_js_form
      else
        :get
      end
    end
  end
end