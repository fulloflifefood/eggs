class FeedbackMailer < ActionMailer::Base

  def feedback(feedback)
    @feedback = feedback
    mail(
        :to      => ENV['ADMIN_EMAIL'],
        :from    => '"Eggbasket Feedback" <noreply@eggbasket.org>',
        :subject => "[Feedback for YourSite] #{feedback.subject}"
    )
  end
end
