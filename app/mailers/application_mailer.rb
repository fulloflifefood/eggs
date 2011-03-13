class ApplicationMailer < ActionMailer::Base
  #
  # Delivers an email template to one or more receivers
  #
  def email_template(to, email_template, options = {})
    params = {
      :subject => email_template.render_subject(options),
      :to => to,
      :from => email_template.from,
    }

    params[:cc] =  options['cc'] if options.key?('cc')
    params[:bcc] = options['bcc'] if options.key?('bcc')
    
    mail params do |format|
  format.text { render :text => email_template.render_body(options) }
    end

  end
end
