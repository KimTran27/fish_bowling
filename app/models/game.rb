class Game < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :creator, class_name: User
  has_many :rounds
  has_many :teams
  has_and_belongs_to_many :participants,
                          join_table: "games_participants",
                          class_name: User,
                          association_foreign_key: 'participant_id'

  after_initialize :initialize_rounds

  def to_param
    name
  end

  def current_round
    # if bowl is empty 
  end

  def minimum_players?
    self.participants.count >= 4
  end

  def unfinished_players
    self.participants.select do |participant|
      participant.cards_from(self).count < 4
    end
  end

  def cards_added?
    self.unfinished_players.count == 0
  end

  def bowl_empty?
    self.cards.all? do |card|
      !card.in_bowl?
    end
  end

  private

  def initialize_rounds
    RoundType.create_round_types
    3.times do |i|
      self.rounds << Round.new(round_type: RoundType.all[i])
    end

  end

end
