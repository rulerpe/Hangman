
require 'yaml'

class Setup
	attr_accessor :word
	def initialize
		@word = get_word
	end

	def get_word
		load_file(random)
	end

	def random
		prng = Random.new
		ran_num = prng.rand(5)
	end

	def load_file(ran_num)
		count = 0
		File.open("5desk.txt").each do |line|
			return line if ran_num == count
			count += 1
		end
	end

end

class Game
	attr_accessor :word,:save
	def initialize(word)
		@word = word
		@temp_word = word.dup
		@guss_word = @word.gsub(/\w/, "_")
		@count = 0
		play
	end

	def set(guss)
		guss.each_char do |c|
			print c, ' '
		end 
	end

	def play
		while won?
			set(@guss_word)
			puts "You have #{11-@count} chances left"
			print "Please enter your guss: "
			guss_char = gets.chomp
			if guss_char == 'save'
				return @save = true
			end
			change(@temp_word.index(guss_char))
				
		end
	end

	def won?
		if @guss_word.eql?(@word)
			puts "You won, the word is #{@word}, you took #{@count} chances"
			false
		elsif @count > 9
			puts "You lost the word is #{@word}"
			false			
		else 
			@count += 1
			true
		end
	end

	def change(index)
		if index
			@guss_word[index] = @word[index]
			@temp_word[index] = '-'
		end 	
	end

end

print "1.contiune or 2.new game"
choice = gets.chomp
if choice == "1"
	rgame_file = File.new("save.yaml", "r")
	ryaml = rgame_file.read
	loaded = YAML::load(ryaml)
	loaded.play
else
	new_word = Setup.new
	new_game = Game.new(new_word.word)
end
if new_game.save
	yaml = YAML::dump(new_game)
	game_file = File.new("save.yaml", "w")
	game_file.write(yaml)
end