#pour tester les resultats
# day_arr_1 = []
# begin_arr_1 = []
# end_arr_1 = []
      # @schoolclasses.each do |schoolclass|
      #   if schoolclass.room_number == @room[w]
      #     day_arr_1 << schoolclass.day_of_week
      #     begin_arr_1 << schoolclass.beginning_of_time.strftime("%H:%M")
      #   end_arr_1 << schoolclass.end_of_time.strftime("%H:%M")
      #   end
      # end

      # @endtime_t = end_arr_1[-1]
      # @schoolday_t = day_arr_1.uniq
      # @begintime_t = begin_arr_1.uniq

      # arr_cours_h1 = []
      # arr_cours_h2 = []
      # arr_cours_h3 = []
      # arr_cours_h4 = []

      # @schoolclasses.each do |schoolclass|
      #   if (schoolclass.beginning_of_time.strftime("%H:%M").include?(@begintime_t[0]) && schoolclass.room_number == @room[w])
      #     arr_cours_h1 << schoolclass
      #   elsif (schoolclass.beginning_of_time.strftime("%H:%M").include?(@begintime_t[1]) && schoolclass.room_number == @room[w])
      #     arr_cours_h2 << schoolclass
      #   elsif (schoolclass.beginning_of_time.strftime("%H:%M").include?(@begintime_t[2]) && schoolclass.room_number == @room[w])
      #     arr_cours_h3 << schoolclass
      #   elsif (schoolclass.beginning_of_time.strftime("%H:%M").include?(@begintime_t[3]) && schoolclass.room_number == @room[w])
      #     arr_cours_h4 << schoolclass
      #   end
      # end

      # classdance1 = [arr_cours_h1, arr_cours_h2, arr_cours_h3, arr_cours_h4]
      # @countday1 = @schoolday_t.count - 1
      # @countarray1 = classdance1.count - 1

      # for countarray in 0..@countarray1
      #   for countday in 0..@countday1
      #     if (classdance1[countarray][countday] == nil)
      #       classdance1[countarray].insert(countday,"")
      #     elsif (classdance1[countarray][countday].day_of_week != @schoolday_t[countday])
      #       classdance1[countarray].insert(countday,"")
      #     end
      #   end
      # end

      #fin test resultat


      



      <tr>
          <% for i in 0..instance_variable_get("@danceclasscount_#{u}") %>
            <td><%= instance_variable_get("@danceclass_#{u}")[i][0] %></td>
            <% for t in 1..instance_variable_get("@v_#{u}")  %>
          <% if instance_variable_get("@danceclass_#{u}")[i][t] == "" %>
            <td>&nbsp;</td>
          <% else %>
            <td><%= instance_variable_get("@danceclass_#{u}")[i][t].level %><p><%= instance_variable_get("@danceclass_#{u}")[i][t].teacher_name %><p><%= instance_variable_get("@danceclass_#{u}")[i][t].type_of_dance %><p><%= instance_variable_get("@danceclass_#{u}")[i][t].day_of_week %><p><%= instance_variable_get("@danceclass_#{u}")[i][t].room_number %></td>
          <% end %>
        <% end  %>
          <% end %>
      </tr>
