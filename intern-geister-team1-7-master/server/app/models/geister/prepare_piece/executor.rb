module Geister
  module PreparePiece
    class Executor
      include ActiveModel::Model
      include ActiveModel::Validations::Callbacks

      attr_accessor :user, :game, :piece_preparations

      with_options presence: true do
        validates :user
        validates :game
        validates :piece_preparations, length: { is: 8 }
      end

      validates_with PointUniquenessValidator, PieceKindValidator
      validate :user_is_player

      validate :piece_preparations_valid_all
      before_validation :game_ensure_preparing!

      def piece_preparations=(params)
        @piece_preparations = params.map(&:symbolize_keys).map do |param|
          PiecePreparation.new(
            owner_user: user,
            game: game,
            point_x: param[:point_x],
            point_y: param[:point_y],
            kind: param[:kind]
          )
        end
      end

      def execute!
        prepare_piece! { game.play_start! if game.prepare_piece_completed? }
      end

      private

      def prepare_piece!
        validate!

        Piece.transaction do
          piece_preparations.each(&:save!)
        end

        yield if block_given?
      rescue ActiveModel::ValidationError => e
        # NOTE: piece_preparations以外のバリデーションエラーはサーバ側の問題なのでそのままraiseしている
        raise e unless errors_only_piece_preparations?

        raise_invalid_request_parameter_error!
      end

      def errors_only_piece_preparations?
        errors.details.except(:piece_preparations).blank?
      end

      def raise_invalid_request_parameter_error!
        raise Errors::InvalidRequestParameter, errors.full_messages.uniq.join(', ')
      end

      def game_ensure_preparing!
        raise ActionController::BadRequest.new, 'Specified game is not preparing' unless game.preparing?
      end

      def piece_preparations_valid_all
        return if piece_preparations.all?(&:valid?)

        errors.add :piece_preparations, :out_of_range_inclusion if piece_preparations.any?(&:out_of_range?)
        errors.add :piece_preparations, :wrong_kind_inclusion if piece_preparations.any?(&:wrong_kind?)
      end

      def user_is_player
        errors.add(:user, :invalid) unless user_is_player?
      end

      def user_is_player?
        game.first_mover_user?(user) || game.last_mover_user?(user)
      end
    end
  end
end
