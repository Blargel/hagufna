require 'discordrb'
require 'yaml'

config = YAML.load_file('./config.yaml')
TOKEN = config['token']
QUESTIONS = config['questions']

hagufna = Discordrb::Bot.new token: TOKEN

hagufna.message(with_text: '!test', in: '#testing') do |event|
  user = event.user
  missed_answers = []

  QUESTIONS.each_with_index do |question, ind|
    user.pm "Question #{ind+1} of #{QUESTIONS.count}\n#{question['message']}"

    user.await!(in: user.pm) do |test_event|
      if test_event.message.content.downcase != question['answer'].downcase
        missed_answers << question['message']
      end
    end
  end

  if missed_answers.empty?
    user.pm "You got all the questions right!"
  else
    user.pm "You missed #{missed_answers.count} questions. Read the guides and try again later."
  end
end

at_exit { hagufna.stop }
hagufna.run
