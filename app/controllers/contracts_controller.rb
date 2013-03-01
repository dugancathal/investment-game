class ContractsController < ApplicationController
  # GET /contracts/1/edit
  def edit
    @player = Player.find(params[:player_id])
    @contract = Contract.find(params[:id])
  end

  # PUT /contracts/1
  # PUT /contracts/1.json
  def update
    @player = Player.find(params[:player_id])
    @contract = Contract.find(params[:id])

    respond_to do |format|
      if @contract.update_attributes(params[:contract])
        format.html { redirect_to @player, notice: 'Contract was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end
end
