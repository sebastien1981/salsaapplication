class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  def index
    @school = School.find(params[:school_id])
    if @school.school_id != nil
      school = @school.school_id
    elsif @school.school_id == nil
      school = @school.id
    end
    @teachers = Teacher.joins("INNER JOIN school_teachers ON school_teachers.teacher_id = teachers.id INNER JOIN schools ON schools.id = school_teachers.school_id where schools.id = '#{school}' or schools.school_id = '#{school}' ")
  end

  def new
    @school = School.find(params[:school_id])
    @teacher = Teacher.new
    @dances = Dance.all
  end

  def create
    @school = School.find(params[:school_id])
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      @schoolteacher = SchoolTeacher.new(school_id:@school.id, teacher_id: @teacher.id)
      @schoolteacher.save
      redirect_to school_teachers_path, notice: "Vous avez bien crée le professeur: #{@teacher.first_name} #{@teacher.last_name}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @school = School.find(params[:school_id])
  end

  def edit
    @school = School.find(params[:school_id])
  end

  def update
    @school = School.find(params[:school_id])
    @teacher.update(teacher_params)
    redirect_to school_teacher_path(@school,@teacher), notice: "Vous avez bien mis à jour le professeur: #{@teacher.first_name} #{@teacher.last_name}"
  end

  def destroy
    @school = School.find(params[:school_id])
    @teacher = Teacher.find(params[:id])
    @idtocatch = School.where("id= '#{@school.id}'or school_id='#{@school.id}'")
    idschooltodelete = []
    @idtocatch.each do |idto|
      idschooltodelete << idto.id
    end
    idschooltodelete.each do |schooltodelete|
      teachertodelete = @teacher.id
      @idtodelete = SchoolTeacher.where(:teacher_id => teachertodelete, :school_id => schooltodelete)
      idto = []
      @idtodelete.each do |idtodelete|
        idto << idtodelete.id
      end
      SchoolTeacher.delete(idto)
    end
    redirect_to school_teachers_path(@school), status: :see_other, notice: "Vous venez de supprimer ce #{@teacher.first_name} #{@teacher.last_name} de votre école"
  end

  def advancedsearch
    @school = School.find(params[:school_id])
    @teachers = Teacher.all.order(params[:sort])

    sql_subquery_firstname = "first_name ILIKE :first_name"
    sql_subquery_lastname = "last_name ILIKE :last_name"


    if params[:first_name].present? && params[:last_name].present?
      @matching_teachers = @teachers.where(sql_subquery_firstname, first_name: "%#{params[:first_name]}%")
                                   .where(sql_subquery_lastname, last_name: "%#{params[:last_name]}%")

      if @matching_teachers.present?
        @teachers = @matching_teachers
        idtoadd = []
        @teachers.each do |tea|
          idtoadd << tea.id
        end
        idtoadd.each do |idto|
          @schoolteacheck = SchoolTeacher.where(school_id: @school.id, teacher_id: idto)
          if @schoolteacheck.any?
            redirect_to school_advancedsearch_path, notice: "Ce prof est déja présent dans cette ecole"
          else
            #@schoolteacher = SchoolTeacher.new(school_id: @school.id, teacher_id: idto)
            #@schoolteacher.save
          end
        end

      else
        redirect_to new_school_teacher_path, notice: "Vous venez d'être redirigé sur la page pour création d'un professeur"
      end

    end
  end

  private

  def teacher_params
    params.require(:teacher)
          .permit(:first_name, :last_name, :date_of_birth, :phone_number, :address_mail, dance_ids: [])
  end

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end
end
