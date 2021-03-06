class FarmsController < ApplicationController

  access_control do
    allow :admin
    allow :member, :to => [:show_essential_info]
  end
  
  # GET /farms
  # GET /farms.xml
  def index
    @farms = Farm.all.select { |farm| current_user.has_role?(:admin, farm)}

    respond_to do |format|
      if(@farms.size == 1)
        format.html {redirect_to(@farms.first)}
      else
        format.html # index.html.erb
      end
    end
  end

  # GET /farms/1
  # GET /farms/1.xml
  def show
    DeliveryStatusManager.update_statuses
    @farm = Farm.find(params[:id])
    @deliveries_finalized = Delivery.find_all_by_farm_id_and_status(@farm.id, "finalized", :order => "date ASC")
    @deliveries_inprogress = Delivery.find_all_by_farm_id_and_status(@farm.id, "inprogress", :order => "date ASC")
    @deliveries_open       = Delivery.find_all_by_farm_id_and_status(@farm.id, "open", :order => "date ASC")
    @deliveries_notyetopen = Delivery.find_all_by_farm_id_and_status(@farm.id, "notyetopen", :order => "date ASC")
    @deliveries_archived   = Delivery.find_all_by_farm_id_and_status(@farm.id, "archived", :order => "date DESC")

    @subscribable_products = Product.find_all_by_farm_id_and_subscribable(@farm.id, true, :order => "created_at ASC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @farm }

      format.csv do
        csv_string = FarmExporter.get_csv(@farm, 2010)

        send_data csv_string,
                :type => 'text/csv; charset=iso-8859-1; header=present',
                :disposition => "attachment; filename=#{@farm.name}#{2010}.csv"
      end
    end
  end

  def show_essential_info
    @snippet = Snippet.find_by_identifier_and_farm_id("essential_info", @farm.id)
    render :template => 'farms/essential_info'
  end

  # GET /farms/new
  # GET /farms/new.xml
  def new
    @farm = Farm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @farm }
    end
  end

  # GET /farms/1/edit
  def edit
    @farm = Farm.find(params[:id])
  end

  # POST /farms
  # POST /farms.xml
  def create
    @farm = Farm.new(params[:farm])

    respond_to do |format|
      if @farm.save
        flash[:notice] = 'Farm was successfully created.'
        format.html { redirect_to(@farm) }
        format.xml  { render :xml => @farm, :status => :created, :location => @farm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @farm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /farms/1
  # PUT /farms/1.xml
  def update
    @farm = Farm.find(params[:id])

    respond_to do |format|
      if @farm.update_attributes(params[:farm])
        flash[:notice] = 'Farm was successfully updated.'
        format.html { redirect_to(@farm) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @farm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /farms/1
  # DELETE /farms/1.xml
  def destroy
    @farm = Farm.find(params[:id])
    @farm.destroy

    respond_to do |format|
      format.html { redirect_to(farms_url) }
      format.xml  { head :ok }
    end
  end
end
