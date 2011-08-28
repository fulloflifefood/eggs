class LocationTagsController < ApplicationController

  access_control do
    allow :admin, :of => @farm
  end  

  def index
    @location_tags = @farm.location_tags

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @location_tags }
    end
  end

  # GET /location_tags/1
  # GET /location_tags/1.xml
  def show
    @location_tag = LocationTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location_tag }
    end
  end

  # GET /location_tags/new
  # GET /location_tags/new.xml
  def new
    @location_tag = LocationTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location_tag }
    end
  end

  # GET /location_tags/1/edit
  def edit
    @location_tag = LocationTag.find(params[:id])
  end

  # POST /location_tags
  # POST /location_tags.xml
  def create
    @location_tag = LocationTag.new(params[:location_tag])

    respond_to do |format|
      if @location_tag.save
        flash[:notice] = 'Location tag was successfully created.'        
        format.html { redirect_to (location_tags_path(:farm_id => @farm.id))}
        format.xml  { render :xml => @location_tag, :status => :created, :location => @location_tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /location_tags/1
  # PUT /location_tags/1.xml
  def update
    @location_tag = LocationTag.find(params[:id])

    respond_to do |format|
      if @location_tag.update_attributes(params[:location_tag])
        flash[:notice] = 'Location tag was successfully updated.'        
        format.html { redirect_to(location_tags_path(:farm_id => @farm.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location_tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /location_tags/1
  # DELETE /location_tags/1.xml
  def destroy
    @location_tag = LocationTag.find(params[:id])
    @location_tag.destroy

    respond_to do |format|
      format.html { redirect_to(location_tags_url(:farm_id => @farm.id)) }
      format.xml  { head :ok }
    end
  end
end
