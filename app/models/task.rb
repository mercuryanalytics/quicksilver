# frozen_string_literal: true

class Task < ApplicationRecord
  include Comparable

  SIZES = %w[small medium large xlarge].freeze

  belongs_to :board, optional: true
  belongs_to :owner, class_name: "User", optional: true

  before_validation :nillify_size

  validates :title, presence: true
  validates :size, inclusion: { in: SIZES }, allow_nil: true
  validates :priority, numericality: { only_integer: true, in: 0..10 }

  scope :available, -> { where(started_at: nil, completed_at: nil) }
  scope :active, -> { where.not(started_at: nil).where(completed_at: nil) }
  scope :recently_completed, -> { where("completed_at > ?", 1.month.ago) }
  scope :approved, -> { where(approved: true) }
  scope :wishlist, -> { where(board: Board.wishlist) }
  scope :suggestions, -> { where(board: Board.suggestions) }
  scope :highest_priority, -> { order(priority: :desc).limit(15) }

  def <=>(other)
    if size == other.size
      0
    elsif size.nil?
      -1
    elsif other.size.nil?
      1
    else
      SIZES.index(size) <=> SIZES.index(other.size)
    end
  end

  private

  def nillify_size
    self.size = nil if size.blank?
  end
end
