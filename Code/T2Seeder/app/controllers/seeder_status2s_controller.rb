class SeederStatus2sController < ApplicationController
  # GET /seeder_status2s
  # GET /seeder_status2s.json
  def index
    @seeder_status2s = SeederStatus2.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seeder_status2s }
    end
  end

  # GET /seeder_status2s/1
  # GET /seeder_status2s/1.json
  def show
    @seeder_status2 = SeederStatus2.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @seeder_status2 }
    end
  end

  # GET /seeder_status2s/new
  # GET /seeder_status2s/new.json
  def new
    @seeder_status2 = SeederStatus2.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seeder_status2 }
    end
  end

  # GET /seeder_status2s/1/edit
  def edit
    @seeder_status2 = SeederStatus2.find(params[:id])
  end

  # POST /seeder_status2s
  # POST /seeder_status2s.json
  def create
    @seeder_status2 = SeederStatus2.new(params[:seeder_status2])

    respond_to do |format|
      if @seeder_status2.save
        format.html { redirect_to @seeder_status2, notice: 'Seeder status2 was successfully created.' }
        format.json { render json: @seeder_status2, status: :created, location: @seeder_status2 }
      else
        format.html { render action: "new" }
        format.json { render json: @seeder_status2.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seeder_status2s/1
  # PUT /seeder_status2s/1.json
  def update
    @seeder_status2 = SeederStatus2.find(params[:id])

    respond_to do |format|
      if @seeder_status2.update_attributes(params[:seeder_status2])
        format.html { redirect_to @seeder_status2, notice: 'Seeder status2 was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @seeder_status2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seeder_status2s/1
  # DELETE /seeder_status2s/1.json
  def destroy
    @seeder_status2 = SeederStatus2.find(params[:id])
    @seeder_status2.destroy

    respond_to do |format|
      format.html { redirect_to seeder_status2s_url }
      format.json { head :no_content }
    end
  end
end
