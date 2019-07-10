class User < ApplicationRecord
    has_many :relationships
    has_many :friends, through: :relationships
    has_many :attempts
    has_many :challenges, through: :attempts
    has_many :user_achievements
    has_many :achievements, through: :user_achievements
    has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "friend_id"
    has_many :inverse_friends, :through => :inverse_relationships, :source => :user
  
  

    validates :name, presence: true
    validates :username, presence: true, uniqueness: true
    has_secure_password

    
    def accept_challenge(challenge)
        @attempt = Attempt.create(user_id: self.id, challenge_id: challenge.id, status: "Accepted")
    end

    def complete_challenge(attempt)
        @attempt = Attempt.find(attempt.id)
        @attempt.update(status: "Completed")
    end
    
    def accepted_challenges
        x = self.attempts.select {|attempt| attempt.status == "Accepted"}
        y = x.map {|a| a.challenge}
        y
    end

    def completed_challenges
        x = self.attempts.select {|attempt| attempt.status == "Completed"}
        y = x.map {|a| a.challenge}
        y
    end

end
