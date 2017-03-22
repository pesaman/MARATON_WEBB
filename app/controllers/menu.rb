#este es para los mensajes de las sesiones que van a leyaut 
enable :sessions

get '/registrar' do
 erb :registrar
end

get '/loogin_user' do
 erb :login
end

get '/logout' do
  session.clear
  session[:logout] = "Has cerrado sesión correctamente"
  redirect to '/'
end

get '/menudeck' do
   user_d = User.where(user_id: current_user.id)
  @decks = Deck.all
   erb :menudeck
end

before '/menudeck' do
  unless session[:email]
    session[:error] = "No has iniciado sesión"
    #i need to redirect to index to avoid go to /secret again
    redirect to '/'
  end
end

get '/find_game' do
  @count_good = 0 
  @count_bad = 0 
  p current_user
  @user = current_user.email
  @answer_game = Game.last
  game_answer = AnswerGame.where(game_id: @answer_game)
    game_answer.each do |values|
      if values.score == 1 
         @count_good +=1 
      else
         @count_bad +=1 
      end 
        if @count_good ==5
           session[:correct_user] = "Felicidades Todas Bien"
        elsif
           @count_bad ==5
           session[:incorrect_user] = "Muy mal Todas Mal"
        end
    end
   erb :find_game
end

get '/score_history' do
  # @count_good = 0 
  # @count_bad = 0 
  @answer_game = Game.last(5).reverse
  # userr = Game.find_by(user_id: id_user).user
  # p @usere = userr.email
  # game_answer = AnswerGame.where(game_id: @id_game)
    # game_answer.each do |values|
    #   if values.score == 1 
    #      @count_good +=1 
    #   else
    #      @count_bad +=1 
    #   end 
    #     @count_good 
    #     @count_bad 
    #   end
    # end
   erb :score
end

get '/show_deck/:id' do
  @deck_id = params[:id]
  @deck = Deck.find(@deck_id)
  @deck_questions = @deck.questions 
  gamee = Game.create(user_id: current_user.id, deck_id: @deck_id)
  @game = Game.last
  
  erb :show_deck
   
end

post "/result" do
  @ressul = []
  @ressulf = []
  contador_buenas = 0
  contador_malas = 0
  answer_value = params
  answer_value.each do |question_id, value| 
    @questionid = question_id
    value.each do |game_id, respuestas|  
     @game = game_id
        respuestas.each do |answers_id, resul_res |
          @answers = answers_id
          if resul_res == "t"    
             contador_buenas += 1 
             @ressul <<  score = 1 
          else 
            contador_malas += 1 
            @ressulf << score = 0
          end
          
          AnswerGame.create(game_id: @game, question_id: @questionid, user_answer: @answers, score: score) 
        end  
    end
  end
   redirect to '/find_game'
end


post '/registrar_user' do
  email = params[:email]
  password  = params[:password] 
  existe = User.find_by(email: email)
  user  = User.new(email: email, password: password)
  user.save
  if user.valid?
      session[:user_id] = user.id
      session[:correct_user] = "Usuario Creado con Exito"
      redirect to("/loogin_user")
  else 
    if existe
      session[:incorrect_user] = "Usuario ya Existe Intenta de Nuevo"
      redirect to '/registrar'
      else
    
      session[:incorrect_user] = "No puedes dejar campos vacios"
      redirect to '/registrar'
    end
  end
end

post '/loogin' do
  email = params[:email]
  password  = params[:password] 
  user_validate = User.autentic(email, password)
    if user_validate 
       session[:email] = email
       session[:user_id] = user_validate.id
       redirect to '/menudeck'
    else 
       session[:incorrect_login] = "Email y/o password incorrectos"
       redirect to '/loogin_user'
    end
end



