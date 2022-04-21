class Api::V1::CoursesController < Api::BaseController
  before_action :find_course, only: [:show, :update, :destroy]

  def index
    @courses = Course.includes(chapters: [:units])
  end

  def create
    course = Course.new(course_params)
    #check course chapter unit record neeed to present in the same time
    form = CreateCourseForm.new(record: course)

    unless form.valid?
      render json: {  message: "Create unsuccess.", errors: form.errors.full_messages }, status: :not_acceptable
      return
    end

    if course.valid?
      course.save
      render json: { message: "Create success." }, status: :created
    else
      render json: { message: "Create unsuccess.", errors: course.errors.full_messages }, status: :not_acceptable
    end
  end

  def show
    @chapters = Chapter.includes(:units).where(course_id: @course.id)
  end

  def update
    if @course.update(course_params)
      render json: { message: "Update success." }, status: :ok
    else
      render json: { message: "Update unsuccess.", errors: @course.errors.full_messages }, status: :not_acceptable
    end
  end

  def destroy
    if @course.destroy
      render json: { message: "Destroy success." }, status: :accepted
    else
      render json: { message: "Destroy unsuccess." }, status: :unprocessable_entity
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :lecturer, :description, chapters_attributes: [:id, :name, :position, :_destroy, units_attributes: [:id, :name, :description, :content, :position, :_destroy]] )
  end

  def find_course
    @course = Course.find_by(id: params[:id])
    unless @course
      render json: { message: "Not found." }, status: :not_found
      return
    end
  end
end