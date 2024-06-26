class SchoolClassesController < ApplicationController
  before_action :set_school, only: %i[index new create destroy dashboard]

  def index
    @schoolclasses = SchoolClass.where(school_id: @school.id).order(:room_number).order(:beginning_of_time).order(:day_of_week)
  end

  def dashboard
    school_classes_table = SchoolClass.arel_table

    case_statement = Arel::Nodes::Case.new
    .when(school_classes_table[:day_of_week].eq("Dimanche")).then(1)
    .when(school_classes_table[:day_of_week].eq("Lundi")).then(2)
    .when(school_classes_table[:day_of_week].eq("Mardi")).then(3)
    .when(school_classes_table[:day_of_week].eq("Mercredi")).then(4)
    .when(school_classes_table[:day_of_week].eq("Jeudi")).then(5)
    .when(school_classes_table[:day_of_week].eq("Vendredi")).then(6)
    .when(school_classes_table[:day_of_week].eq("Samedi")).then(7)

    #recuperation des donnes par ecole en utilisant le case when
  @schoolclasses = SchoolClass.where(school_id: @school.id)
                              .order(:room_number)
                              .order(:beginning_of_time)
                              .order(case_statement)
                              .order(:day_of_week)

    #recuperation des romms dans un array
    roomnumber_arr = []
    @schoolclasses.each do |roomschool|
      roomnumber_arr << roomschool.room_number
    end
    instance_variable_set("@room", roomnumber_arr.uniq)
    instance_variable_set("@roomcount", @room.count - 1)

    #ajouter une boucle for
    w=0#asup
    if (@room.any?)

      @room.each do |room|

        #declaration des arrays pour la suite du programme
        day_arr = []
        begin_arr = []
        begin_time = []
        end_arr = []
        schoolday = []
        #recuperation des jours, heure de début, et la dernière heure de fin des cours
        @schoolclasses.each do |schoolclass|
          if schoolclass.room_number == room
            day_arr << schoolclass.day_of_week
            begin_arr << schoolclass.beginning_of_time.strftime("%H:%M")
            end_arr << schoolclass.end_of_time.strftime("%H:%M")
          end
        end

        #a garder pour !!!!!!!!!
        instance_variable_set("@schoolday_#{w}", day_arr.uniq)
        instance_variable_set("@endtime_#{w}", end_arr[-1])
        begin_time = begin_arr.uniq
        schoolday = day_arr.uniq
        #a garder pour !!!!!!!!!

        z = 0
        classdance = []
        begin_time.each do |timebegin|
          @schoolclasses.each do |schoolclasses|
            time_condition = schoolclasses.beginning_of_time.strftime("%H:%M").include?(timebegin)

            if time_condition
              #Use array to store the result instead of creating individual variables
              arr_cours_h = SchoolClass.where(school_id: @school.id).where(beginning_of_time: timebegin).where(room_number: room).order(case_statement).order(:day_of_week)
              instance_variable_set("@arr_cours_h#{z}", arr_cours_h)
            end
          end
          z += 1
        end

        y = 0
        begin_time.each do |timebegin|
          classdance << instance_variable_get("@arr_cours_h#{y}")
          y += 1
        end

        # ajoute l'horaire pour chaque element
        x=0
        begin_time.each do |timebegin|
          instance_variable_set("@cours_h#{x}", classdance[x].to_a.insert(0, timebegin))
          x += 1
        end

        t = 0
        danceclass = []
        m = 0
        classdance.each do |countarray|
          danceclass << instance_variable_get("@cours_h#{m}")
          # Use instance_variable_get to get the value of the instance variable
          m += 1
        end

        instance_variable_set("@danceclass", danceclass)
        instance_variable_set("@day", day_arr.uniq)

        p = 1
        @countday = []
        @day.each do |day|
          @countday << p
          p += 1
        end

        #ajout d'un element vide pour les boucles suivantes
        schoolday.insert(0,"")

        #ajout d'element vide dans les tableux pour gérer les horaires vides
        @danceclass.each do |danceclass|
          @countday.each do |countday|
            current_element = danceclass[countday]
            if current_element.nil? || current_element.day_of_week != schoolday[countday]

              #modifier cette ligne de code pour inserer les elements vide
              danceclass.insert(countday, "")
            end
          end
        end
        instance_variable_set("@danceclass_#{w}", @danceclass)
        instance_variable_set("@danceclasscount_#{w}", instance_variable_get("@danceclass_#{w}").count - 1)
        instance_variable_set("@v_#{w}", instance_variable_get("@cours_h#{t}").count - 1)

        w += 1
      end#end for each

    else
      redirect_to new_school_school_class_path(:school_id => @school.id), notice: "Vous avez été redirigé vers la page pour créer vos planning"
    end

  end

  def new
    @schoolclass = SchoolClass.new
    @school = School.find(params[:school_id])
    set_arg_creation
  end

  def create
    set_arg_creation

    @schoolclass = SchoolClass.new(schoolclass_params)

        @schoolclass.school = @school
        @schoolclassesroom = SchoolClass.where(beginning_of_time: @schoolclass.beginning_of_time, end_of_time: @schoolclass.end_of_time, day_of_week: @schoolclass.day_of_week, school_id: @schoolclass.school_id, room_number: @schoolclass.room_number)
        @schoolclassestea = SchoolClass.where(beginning_of_time: @schoolclass.beginning_of_time, end_of_time: @schoolclass.end_of_time, teacher_name: @schoolclass.teacher_name, day_of_week: @schoolclass.day_of_week)

        if @schoolclassestea.any?
          redirect_to new_school_school_class_path(:school_id => @school.id), notice: "#{@schoolclass.teacher_name} est déja pris à cette horaire"
        elsif @schoolclassesroom.any?
          redirect_to new_school_school_class_path(:school_id => @school.id), notice: "La salle est déja réservé à cette horaire dans cette école"
        elsif @schoolclass.save
          redirect_to schools_path, notice: "Votre cours a bien été crée"
        else
          render :new, status: :unprocessable_entity
        end
  end

  def destroy
    @schoolclass = SchoolClass.find(params[:id])
    @schoolclass.destroy
    redirect_to school_school_classes_path(:school_id => @school.id), status: :see_other
  end

  private

  def schoolclass_params
    params.require(:school_class).permit(:type_of_dance, :level, :end_of_time, :beginning_of_time, :day_of_week, :teacher_name, :room_number)
  end

  def set_school
    @school = School.find(params[:school_id])
  end

  def set_arg_creation
    @nameschool = School.where(id: @school.id, school_id: @school.school_id)
    if @school.school_id != nil
      school = @school.school_id
    elsif @school.school_id == nil
      school = @school.id
    end
    @teacherstoselect = Teacher.joins("INNER JOIN school_teachers ON school_teachers.teacher_id = teachers.id INNER JOIN schools ON schools.id = school_teachers.school_id where schools.id = #{school} or schools.school_id = #{school} ")
    #nombre de room
    x = @school.number_room
    arrtess = []#pour stocker les valeurs que je souhaite
    arrtess << x
    while x > 1
      x -= 1
      arrtess << x
    end
    @countarr = arrtess

  end
end
