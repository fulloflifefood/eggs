class EmailTemplate < ActiveRecord::Base

  require "liquid_filters"

  belongs_to :farm
  ### Validation
  validates_presence_of :subject, :from, :body, :name, :identifier

  # http://code.dunae.ca/validates_email_format_of.html
  # validates_email_format_of :from, :allow_nil => true, :allow_blank => true
  validates_email_format_of :cc, :allow_nil => true, :allow_blank => true
  validates_email_format_of :bcc, :allow_nil => true, :allow_blank => true

  validate :body_must_be_valid_liquid_format, :subject_must_be_valid_liquid_format

  liquid_methods :name, :body, :subject

  #
  # Puts the parse error from Liquid on the error list if parsing failed
  #
  def body_must_be_valid_liquid_format
    errors.add :body, @syntax_error unless @syntax_error.nil?
  end

  def subject_must_be_valid_liquid_format
    errors.add :subject, @subject_syntax_error unless @subject_syntax_error.nil?
  end

  ### Attributes
  attr_protected :template

  #
  # body contains the raw template. When updating this attribute, the
  # email_template parses the template and stores the serialized object
  # for quicker rendering.
  #
  def body=(text)
    self[:body] = text

    begin
      @template = Liquid::Template.parse(text)
    rescue Liquid::SyntaxError => error
      @syntax_error = error.message
    end
  end

  def subject=(text)
    self[:subject] = text

    begin
      @subject_template = Liquid::Template.parse(text)
    rescue Liquid::SyntaxError => error
      @subject_syntax_error = error.message
    end
  end

  ### Methods

  #
  # Delivers the email
  #
  def deliver_to(address, options = {})
    options[:cc] ||= cc unless cc.blank?
    options[:bcc] ||= bcc unless bcc.blank?

    # Liquid doesn't like symbols as keys
    options.stringify_keys!
    ApplicationMailer.email_template(address, self, options).deliver
  end

  #
  # Renders body as Liquid Markup template
  #
  def render_body(options = {})
    template.render options, :filters => [LiquidFilters]
  end

  def render_subject(options = {})
    subject_template.render options
  end

  #
  # Usable string representation
  #
  def to_s
    "[EmailTemplate] From: #{from}, '#{subject}': #{body}"
  end

 private
  #
  # Returns a usable Liquid:Template instance
  #
  def template
    @template ||= Liquid::Template.parse body
  end

  def subject_template
    @subject_template ||= Liquid::Template.parse subject
  end

end
