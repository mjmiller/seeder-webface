class SynsetT2MapsController < ApplicationController
  # GET /synset_t2_maps
  # GET /synset_t2_maps.json
  def index
    @synset_t2_maps = SynsetT2Map.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @synset_t2_maps }
    end
  end

  # GET /synset_t2_maps/1
  # GET /synset_t2_maps/1.json
  def show
    @synset_t2_map = SynsetT2Map.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @synset_t2_map }
    end
  end

  # GET /synset_t2_maps/new
  # GET /synset_t2_maps/new.json
  def new
    @synset_t2_map = SynsetT2Map.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @synset_t2_map }
    end
  end

  # GET /synset_t2_maps/1/edit
  def edit
    @synset_t2_map = SynsetT2Map.find(params[:id])
  end

  # POST /synset_t2_maps
  # POST /synset_t2_maps.json
  def create
    @synset_t2_map = SynsetT2Map.new(params[:synset_t2_map])

    respond_to do |format|
      if @synset_t2_map.save
        format.html { redirect_to @synset_t2_map, notice: 'Synset t2 map was successfully created.' }
        format.json { render json: @synset_t2_map, status: :created, location: @synset_t2_map }
      else
        format.html { render action: "new" }
        format.json { render json: @synset_t2_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /synset_t2_maps/1
  # PUT /synset_t2_maps/1.json
  def update
    @synset_t2_map = SynsetT2Map.find(params[:id])

    respond_to do |format|
      if @synset_t2_map.update_attributes(params[:synset_t2_map])
        format.html { redirect_to @synset_t2_map, notice: 'Synset t2 map was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @synset_t2_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /synset_t2_maps/1
  # DELETE /synset_t2_maps/1.json
  def destroy
    @synset_t2_map = SynsetT2Map.find(params[:id])
    @synset_t2_map.destroy

    respond_to do |format|
      format.html { redirect_to synset_t2_maps_url }
      format.json { head :no_content }
    end
  end
end
