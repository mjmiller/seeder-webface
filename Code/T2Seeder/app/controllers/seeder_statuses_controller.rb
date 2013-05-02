class SeederStatusesController < ApplicationController
  # GET /seeder_statuses
  # GET /seeder_statuses.json
  def index
    @seeder_statuses = SeederStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seeder_statuses }
    end
  end

  # GET /seeder_statuses/1
  # GET /seeder_statuses/1.json
  def show
    @seeder_status = SeederStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @seeder_status }
    end
  end

  # GET /seeder_statuses/new
  # GET /seeder_statuses/new.json
  def new
    @seeder_status = SeederStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seeder_status }
    end
  end

  # GET /seeder_statuses/1/edit
  def edit
    @seeder_status = SeederStatus.find(params[:id])
  end

  # POST /seeder_statuses
  # POST /seeder_statuses.json
  def create
    @seeder_status = SeederStatus.new(params[:seeder_status])

    respond_to do |format|
      if @seeder_status.save
        format.html { redirect_to @seeder_status, notice: 'Seeder status was successfully created.' }
        format.json { render json: @seeder_status, status: :created, location: @seeder_status }
      else
        format.html { render action: "new" }
        format.json { render json: @seeder_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seeder_statuses/1
  # PUT /seeder_statuses/1.json
  def update
    @seeder_status = SeederStatus.find(params[:id])

    respond_to do |format|
      if @seeder_status.update_attributes(params[:seeder_status])
        format.html { redirect_to @seeder_status, notice: 'Seeder status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @seeder_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seeder_statuses/1
  # DELETE /seeder_statuses/1.json
  def destroy
    @seeder_status = SeederStatus.find(params[:id])
    @seeder_status.destroy

    respond_to do |format|
      format.html { redirect_to seeder_statuses_url }
      format.json { head :no_content }
    end
  end
end
