class MeetingsController < ApplicationController
  def index
    if params[:tag]
      @meetings = Tag.find_by(name: params[:tag]).meetings
    else
      @meetings = Meeting.all
    end
  end

  def new
    @meeting = Meeting.new
    @tags = Tag.all
  end

  def create
    @meeting = Meeting.new(
                           name: params[:name],
                           address: params[:address],
                           start_time: params[:start_time],
                           end_time: params[:end_time],
                           notes: params[:notes]
                           )

    if @meeting.save
      tag_ids = params[:tags]
      if tag_ids
        tag_ids.each do |tag_id|
          MeetingTag.create(
                            meeting_id: @meeting.id,
                            tag_id: tag_id
                            )
        end
      end
      flash[:success] = "meeting successfully created"
      redirect_to "/meetings"
    else
      @tags = Tag.all
      render :new
    end
  end

  def show
    @meeting = Meeting.find_by(id: params[:id])
  end

  def edit
    @meeting = Meeting.find(params[:id])
    @tags = Tag.all
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.assign_attributes(
                                name: params[:name],
                                address: params[:address],
                                start_time: params[:start_time],
                                end_time: params[:end_time],
                                notes: params[:notes]
                              )
    if @meeting.save
      @meeting.meeting_tags.destroy_all
      tag_ids = params[:tags]
      if tag_ids
        tag_ids.each do |tag_id|
          MeetingTag.create(
                            meeting_id: @meeting.id,
                            tag_id: tag_id
                            )
        end
      end
      flash[:success] = "Meeting successfully updated"
      redirect_to "/meetings/#{@meeting.id}"
    else
      @tags = Tag.all
      render :edit
    end
  end
end













