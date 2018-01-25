class Board

	attr_accessor :board_cases
	attr_accessor :winning_combinations

	def initialize
		@board_cases = [] 
		(1..9).each do |i|
			@board_cases << BoardCase.new(i) #on stock dans un array les valeurs des cases
	
			#on verra par la suite, notre board sera une matirce 3*3, on va identifier chaque casepar un id ciffre, l'element 1*1 de la matrice ==> 1, 1*2 (ligne 1, colonne 2) ==> 2
			#les différentes combinaisons gagantes, une sorte de dictionnaire qu'on va utiliser par la suite
	    @winning_combinations = [
      [1, 2, 3], [4, 5, 6], [7, 8, 9],
      [1, 4, 7], [2, 5, 8], [3, 6, 9],
      [1, 5, 9], [3, 5, 7]
    ]
	end

  def board_display
    line_display = ""

    puts "-------------"

=begin 
    #Ceci est un code esthétique, qui va nous afficher le Board sous la forme : 
		
-------------
| 1 | 2 | 3 |
-------------
| 4 | 5 | 6 |
-------------
| 7 | 8 | 9 |
-------------

    	
=end

    @board_cases.each do |board_case|
      case board_case.case_id % 3 #le modulo est pour dire si c'est divisibke par 3
      when 1..2
        line_display += "| #{board_case.status} " #si c'est pas divisible, on est sur une case qui n'est pas à droite de l'ecran, donc pas besoin du |
      when 0
        line_display += "| #{board_case.status} |" #si c divisible par 3 ==> on est dans une case de droite ==> prend un |
        puts line_display
        line_display = ""
        puts "-------------"
      end
    end
  end

end

class BoardCase

	attr_accessor :case_id #on va définir chaque Case par un id (déja instancié, qui correspon à un chiffre simple)
	attr_accessor :status #la case à également un status, qui correspond à son Id et comme on le verra par la suite, à son état, suivant quel joueur joue ==> ça prendre O ou X

	def initialize(_id) 
		@case_id = _id
		@status = _id
	end

end

class Player

	attr_accessor :name, :sym

	#caque joueur à un nom et un symole X pour le premier joueur et O pour le 2ème
	def initialize(player_id, sym)
		puts "Joueur #{player_id}, merci d'indiquer votre nom : "
		@name = gets.chomp
		@sym = sym
	end

end

class Game

	def initialize
    @turns = 0 # Le compteur est important car c'est lui qui va servir de savoir qui est en train de jouer
    @cases_remaining = [1, 2, 3, 4, 5, 6, 7, 8, 9] #les case qui peuevnt encore être accessiles, c'est normal c'est le début du jeu. Cette variable va nous servir par ailleurs
  end

  def launch_game #démarrage du jeu
		@players = [Player.new(1, "X"), Player.new(2, "O")] #instantiation des joueurs

		@board = Board.new
		@board.board_display #affiche le board

		#le code suivant, est une loop en gros qui s'arrete soit si le jeux à un ganant ou une égalité, sinon il alimente le nombre de tours 
		loop do 
      play_turn
      if is_there_a_winner # if a player has won leave the game
        puts "#{@players[@turns%2].name} A GAGNE" #le % 2 est pour voir si c'est un trou pair ou impair et donc quel joeur joue
        break
      elsif @turns == 8 # après 9 tours, sui pas de gagant c'est que c'est égalité 
        puts "EGALITE"
        break
      end
      @turns += 1
    end
  end

  def play_turn
    puts "#{@players[@turns%2].name} c'est a ton tour de jouer :"
    case_selected = ""
    loop do
      case_selected = gets.chomp.to_i
      # pour vérifier que le joueur a bien coché une case libre
      if !@cases_remaining.include?(case_selected)
        puts "STP, entre un chiffre (entre 1 et 9, et qui n'a pas encore été joué) :"
      else
        @cases_remaining.delete(case_selected) #si un joueur coche une case encore libre, il faut supprimer sa valeur des valeur restantes à jouer
        break
      end
    end
    # on remplit le status de la case (si elle prend X ou un O) par le symole du joueur qui joue
    @board.board_cases[case_selected - 1].status = @players[@turns%2].sym
    # affiche l'état du board à chaque tour
    @board.board_display
	 end

	def is_there_a_winner
	    return false if @turns < 4 # on ne peut pas avoir de winner de toutes les manières 

	    # verifie si les cominaisons e
	    @board.winning_combinations.each do |combination|
	      checked_spaces = []
	      combination.each do |i|
	        # prend la valeur de cette cominaison
	        checked_spaces << @board.board_cases[i-1].status
	      end
	      # returns true if the line tested does contain a unique character
	      return true if checked_spaces.uniq.length == 1
	    end

	    return false
	 end

end

my_game = Game.new
my_game.launch_game 
end