class User < ApplicationRecord
  after_commit :assign_default_role

  include Authority::UserAbilities

  belongs_to :squad, optional: true
  has_and_belongs_to_many :sprints, -> { distinct }
  has_many :story_points
  has_many :squad_managers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  def name_or_email
    self.name || self.email
  end

  def admin?
    self.has_role?(:admin)
  end

  def sprinter?
    self.has_role(:sprinter)
  end

  def total_sprint_days
    self.sprints.map(&:sprint_days).map(&:count).reduce(:+)
  end

  def average_sps_per_sprint
    sprints.each_with_object({}) do |sprint, sps_per_sprint|
      sprint_name = "#{sprint.squad.name}_#{sprint.squad_counter}"
      sprint_name = sprint_name.tr(' ', '_')
      story_points = sprint.story_points.by_user_on_sprint(self, sprint).value
      sps_per_sprint[sprint_name] = story_points / sprint.total_sprint_days
    end
  end

  def personal_evolution_chart_data
    [
      name: 'Média de SPs por dia por sprint',
      data: average_sps_per_sprint
    ]
  end

  private

  def assign_default_role
    self.add_role(:user)
  end
end
