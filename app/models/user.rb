# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  ADMINISTRATORS = %w[mattw].map { |u| "#{u}@mercuryanalytics.com" }.freeze
  ENGINEERS = %w[engineer].map { |u| "#{u}@domain.me" }.freeze

  def admin?
    ADMINISTRATORS.include?(email)
  end

  def engineer?
    ENGINEERS.include?(email)
  end
end