# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if strike?

    @mark.to_i
  end

  private

  def strike?
    @mark == 'X'
  end
end
