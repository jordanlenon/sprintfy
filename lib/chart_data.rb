class ChartData
  def initialize(params)
    @params = params
    @entry = {}
    @squad = params[:squad] || get_squad
  end

  def data
    months_array
    Sprint.to_date(Date.today).by_squad(@squad).from_date(@params[:period]).each do |sprint|
      if @entry[grouping(sprint)]
        @entry[grouping(sprint)] += sprint.sp_scope(@params).to_f
      else
        @entry[grouping(sprint)] = sprint.sp_scope(@params).to_f
      end
    end
    @entry
  end

  private

  def months_array
    if @params[:period] == 'Mensal'
      12.times do |i|
        @entry[Date.today.months_ago(11-i).strftime('%b%y')] = 0
      end
    end
  end

  def get_squad
    @params[:person] ? Squad.where(id: User.where(id: @params[:person]).first.squad_id).first.try(:id) : nil
  end

  def grouping(sprint)
    {
      'Mensal' => "#{sprint.due_date.strftime('%b%y')}",
      'Semanal' => "#{sprint.due_date.beginning_of_week.strftime('%d/%b/%Y')}",
      'Sprint' => "Sprint #{sprint.squad_counter.to_s}"
    }[@params[:period]]
  end
end
