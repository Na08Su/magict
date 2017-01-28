class NotesController < InheritedResources::Base
	def new
		@note = Note.new
		render :layout => false

	end
  private

    def note_params
      params.require(:note).permit(:content)
    end
end

