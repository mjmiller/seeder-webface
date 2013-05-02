class ThEntriesController < ApplicationController
  # GET /th_entries
  # GET /th_entries.json
  def index
    @th_entries = ThEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @th_entries }
    end
  end

  # GET /th_entries/1
  # GET /th_entries/1.json
  def show
    @th_entry = ThEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @th_entry }
    end
  end

  # GET /th_entries/new
  # GET /th_entries/new.json
  def new
    @th_entry = ThEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @th_entry }
    end
  end

  # GET /th_entries/1/edit
  def edit
    @th_entry = ThEntry.find(params[:id])
  end

  # POST /th_entries
  # POST /th_entries.json
  def create
    @th_entry = ThEntry.new(params[:th_entry])

    respond_to do |format|
      if @th_entry.save
        format.html { redirect_to @th_entry, notice: 'Th entry was successfully created.' }
        format.json { render json: @th_entry, status: :created, location: @th_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @th_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /th_entries/1
  # PUT /th_entries/1.json
  def update
    @th_entry = ThEntry.find(params[:id])

    respond_to do |format|
      if @th_entry.update_attributes(params[:th_entry])
        format.html { redirect_to @th_entry, notice: 'Th entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @th_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /th_entries/1
  # DELETE /th_entries/1.json
  def destroy
    @th_entry = ThEntry.find(params[:id])
    @th_entry.destroy

    respond_to do |format|
      format.html { redirect_to th_entries_url }
      format.json { head :no_content }
    end
  end
end
