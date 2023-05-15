class Admin::BetsController < ApplicationController
  include ActiveRecord::Sanitization::ClassMethods
  def index
    @bets = if params[:search].blank?
              Bet.includes(:user, :item).all
            else
              Bet.joins(:user, :item)
                 .where('
                    `serial_number` LIKE :search OR
                    `items`.`name` LIKE :search OR
                    `users`.`email` LIKE :search', search: "%#{sanitize_sql_like(params[:search])}%")
            end
    @bets = @bets.where(state: params[:state])
    @bets = @bets.where('`created_at` >= ?', params[:start_date]) if params[:start_date].present?
    @bets = @bets.where('`created_at` <= ?', params[:end_date]) if params[:end_date].present?
  end
end
