# frozen_string_literal: true

# this module calculate moves for all the pieces
module MoveCalculator
  class << self
    def legal_moves(row, col, board)
      piece = board.piece_at(row, col)
      color = piece.color

      case piece
      when Pawn
        calculate_pawn_moves(row, col, color, piece, board)
      when Knight
        calculate_knight_moves(row, col, color, piece, board)
      when Rook
        calculate_rook_moves(row, col, color, piece, board)
      when Bishop
        calculate_bishop_moves(row, col, color, piece, board)
      when Queen
        calculate_queen_moves(row, col, color, piece, board)
      when King
        calculate_king_moves(row, col, color, piece, board)
      end
    end

    def possible_moves_from(array, board)
      legal_moves(array[0], array[1], board)
    end

    def calculate_king_moves(row, col, color, piece, board)
      moves = []
      # # king can move when the square is empty not under attack and not a friendly piece
      # # vertical_squares
      moves << [row + 1, col] if (row + 1).between?(0, 7) && !board.friendly_at?(piece.color, row + 1, col) && !square_under_attack?(row + 1, col, piece.enemy_color, board)
      moves << [row - 1, col] if (row - 1).between?(0, 7) && !board.friendly_at?(piece.color, row - 1, col) && !square_under_attack?(row - 1, col, piece.enemy_color, board)
      # # horizontal_square
      moves << [row, col + 1] if (col + 1).between?(0, 7) && !board.friendly_at?(piece.color, row, col + 1) && !square_under_attack?(row, col + 1, piece.enemy_color, board)
      moves << [row, col - 1] if (col - 1).between?(0, 7) && !board.friendly_at?(piece.color, row, col - 1) && !square_under_attack?(row, col - 1, piece.enemy_color, board)
      # # diagonal_square
      moves << [row + 1, col + 1] if (row + 1).between?(0, 7) && (col + 1).between?(0, 7) && !board.friendly_at?(piece.color, row + 1, col + 1) && !square_under_attack?(row + 1, col + 1, piece.enemy_color, board)
      moves << [row + 1, col - 1] if (row + 1).between?(0, 7) && (col - 1).between?(0, 7) && !board.friendly_at?(piece.color, row + 1, col - 1) && !square_under_attack?(row + 1, col - 1, piece.enemy_color, board)
      moves << [row - 1, col + 1] if (row - 1).between?(0, 7) && (col + 1).between?(0, 7) && !board.friendly_at?(piece.color, row - 1, col + 1) && !square_under_attack?(row - 1, col + 1, piece.enemy_color, board)
      moves << [row - 1, col - 1] if (row - 1).between?(0, 7) && (col - 1).between?(0, 7) && !board.friendly_at?(piece.color, row - 1, col - 1) && !square_under_attack?(row - 1, col - 1, piece.enemy_color, board)
      # castling
      moves << [row, col - 2, row, col - 1] if queen_side_castle_possible?(piece, board)
      moves << [row, col + 2, row, col + 1] if king_side_castle_possible?(piece, board)
      p moves

      moves
    end

    def check?(king, board)
      square_under_attack?(king.row, king.col, king.enemy_color, board)
    end

    def queen_side_castle_possible?(king, board)
      rook = board.piece_at(king.row, king.col - 4)
      return false if board.piece_at(king.row, king.col - 4).class != Rook
      return false if king.has_moved == true || rook.has_moved == true
      return false if check?(king, board)
      return false if square_under_attack?(king.row, king.col - 1, king.enemy_color, board) || board.piece_at(king.row, king.col - 1) != Board::EMPTY_SPOT
      return false if square_under_attack?(king.row, king.col - 2, king.enemy_color, board) || board.piece_at(king.row, king.col - 2) != Board::EMPTY_SPOT
      return false if square_under_attack?(king.row, king.col - 3, king.enemy_color, board) || board.piece_at(king.row, king.col - 3) != Board::EMPTY_SPOT

      true
    end

    def king_side_castle_possible?(king, board)
      rook = board.piece_at(king.row, king.col + 3)
      return false if board.piece_at(king.row, king.col + 3).class != Rook
      return false if king.has_moved == true || rook.has_moved == true
      return false if check?(king, board)
      return false if square_under_attack?(king.row, king.col + 1, king.enemy_color, board) || board.piece_at(king.row, king.col + 1) != Board::EMPTY_SPOT
      return false if square_under_attack?(king.row, king.col + 2, king.enemy_color, board) || board.piece_at(king.row, king.col + 2) != Board::EMPTY_SPOT

      true
    end

    def square_under_attack?(row, col, enemy_color, board)
      moves = []
      enemies = board.collect_all_pieces(enemy_color)
      enemies.each do |enemy|
        if enemy.instance_of?(Pawn)
          moves << pawn_attack_moves(enemy)
        elsif enemy.instance_of?(King)
          moves << king_attack_moves(enemy)
        else
          moves.push(possible_moves_from([enemy.row, enemy.col], board))
        end
      end
      enemy_moves = moves.flatten(1)
      enemy_moves.include?([row, col])
    end

    def pawn_attack_moves(enemy)
      moves = []
      direction = enemy.color == "white" ? -1 : +1
      [-1, + 1].each do |delta|
        column = enemy.col + delta
        moves.push([enemy.row + direction, column]) if column.between?(0, 7) && (enemy.row + direction).between?(0, 7)
      end
      moves
    end

    def king_attack_moves(king)
      attacked_squares = []

      (-1..1).each do |row_offset|
        (-1..1).each do |col_offset|
          next if row_offset.zero? && col_offset.zero?

          target_row = king.row + row_offset
          target_col = king.col + col_offset

          attacked_squares << [target_row, target_col] if target_row.between?(0, 7) && target_col.between?(0, 7)
        end
      end

      attacked_squares
    end

    def calculate_queen_moves(row, col, color, piece, board)
      moves = []
      moves << calculate_bishop_moves(row, col, color, piece, board)
      moves << calculate_rook_moves(row, col, color, piece, board)
      moves.flatten(1)
    end

    def calculate_pawn_moves(row, col, color, piece, board)
      if color == "black"
        calculate_black_pawn_moves(row, col, piece, board)
      else
        calculate_white_pawn_moves(row, col, piece, board)
      end
    end

    def calculate_knight_moves(row, col, color, piece, board)
      knight_moves(row, col, piece, board)
    end

    # For bishop moves calculation
    def calculate_bishop_moves(row, col, color, piece, board)
      moves = []
      # down right diagonal
      current_column = col
      (row + 1).upto(7) do |current_row|
        current_column += 1
        break if board.friendly_at?(color, current_row, current_column)
        break unless current_column.between?(0, 7)

        moves << [current_row, current_column]
        break if board.enemy_at?(color, current_row, current_column)
      end
      # # down left diagonal
      current_column = col
      (row + 1).upto(7) do |current_row|
        current_column -= 1
        break if board.friendly_at?(color, current_row, current_column)
        break unless current_column.between?(0, 7)

        moves << [current_row, current_column]
        break if board.enemy_at?(color, current_row, current_column)
      end

      # upright diagonal
      current_column = col
      (row - 1).downto(0) do |current_row|
        current_column += 1
        break if board.friendly_at?(color, current_row, current_column)
        break unless current_column.between?(0, 7)

        moves << [current_row, current_column]
        break if board.enemy_at?(color, current_row, current_column)
      end

      # upleft diagonal
      current_column = col
      (row - 1).downto(0) do |current_row|
        current_column -= 1
        break if board.friendly_at?(color, current_row, current_column)
        break unless current_column.between?(0, 7)

        moves << [current_row, current_column]
        break if board.enemy_at?(color, current_row, current_column)
      end
      moves
    end

    # For rook moves calculation
    def calculate_rook_moves(row, col, color, piece, board)
      moves = []
      # downward
      (row + 1).upto(7) do |current_row|
        break if board.friendly_at?(color, current_row, col)

        moves << [current_row, col]
        break if board.enemy_at?(color, current_row, col)
      end

      # upward
      (row - 1).downto(0) do |current_row|
        break if board.friendly_at?(color, current_row, col)

        moves << [current_row, col]
        break if board.enemy_at?(color, current_row, col)
      end
      # rightward
      (col + 1).upto(7) do |current_column|
        break if board.friendly_at?(color, row, current_column)

        moves << [row, current_column]
        break if board.enemy_at?(color, row, current_column)
      end
      # leftward
      (col - 1).downto(0) do |current_column|
        break if board.friendly_at?(color, row, current_column)

        moves << [row, current_column]
        break if board.enemy_at?(color, row, current_column)
      end
      moves
    end

    # For Black and White Knight move calculation
    def knight_moves(row, col, piece, board)
      adjacent = []
      empty = "\u2610"
      target = piece.enemy_color

      adjacent << [row + 2, col - 1]
      adjacent << [row + 2, col + 1]

      adjacent << [row + 1, col - 2]
      adjacent << [row - 1, col - 2]

      adjacent << [row + 1, col + 2]
      adjacent << [row - 1, col + 2]

      adjacent << [row - 2, col - 1]
      adjacent << [row - 2, col + 1]

      result = filter_illegal_position(adjacent)
      exclude_self_capture(result, board, empty, target)
    end

    def exclude_self_capture(array, board, empty, target)
      moves = []
      array.each do |(row, col)|
        piece = board.piece_at(row, col)
        if piece == empty
          moves << [row, col]
        elsif piece.color == target
          moves << [row, col]
        end
      end
      moves
    end

    def filter_illegal_position(array)
      array.reject do |inner_array|
        inner_array.any? do |element|
          element.negative? || element > 7
        end
      end
    end

    # For Black Pawn move calculation
    def calculate_black_pawn_moves(row, col, piece, board)
      moves = []
      empty = "\u2610"

      one_forward_row = row + 1
      two_forward_row = row + 2

      # stop if moving forward goes of board
      return moves if one_forward_row > 7

      one_forward = board.piece_at(one_forward_row, col)

      # one square move
      if one_forward == empty
        moves << [one_forward_row, col]

        # two squares forward (only if one forward is empty AND pawn hasn't moved)
        if !piece.has_moved && two_forward_row <= 7
          two_forward = board.piece_at(two_forward_row, col)
          moves << [two_forward_row, col] if two_forward == empty
        end
      end

      if col - 1 >= 0
        diag_right = board.piece_at(one_forward_row, col - 1)
        moves << [one_forward_row, col - 1] if diag_right != empty && diag_right.color == "white"
      end

      if col + 1 <= 7
        diag_left = board.piece_at(one_forward_row, col + 1)
        moves << [one_forward_row, col + 1] if diag_left != empty && diag_left.color == "white"
      end

      moves
    end

    # For White Pawn move calculation
    def calculate_white_pawn_moves(row, col, piece, board)
      moves = []
      empty = "\u2610"

      one_forward_row = row - 1
      two_forward_row = row - 2

      # Stop if moving forward is off-board
      return moves if one_forward_row.negative?

      one_forward = board.piece_at(one_forward_row, col)

      # one square forward
      if one_forward == empty
        moves << [one_forward_row, col]

        # two squares forward (only if one forward is empty AND pawn hasn't moved)
        if !piece.has_moved && two_forward_row >= 0
          two_forward = board.piece_at(two_forward_row, col)
          moves << [two_forward_row, col] if two_forward == empty
        end
      end

      # captures (only if diagonals are on-board)
      if col - 1 >= 0
        diag_right = board.piece_at(one_forward_row, col - 1)
        moves << [one_forward_row, col - 1] if diag_right != empty && diag_right.color == "black"
      end

      if col + 1 <= 7
        diag_right = board.piece_at(one_forward_row, col + 1)
        moves << [one_forward_row, col + 1] if diag_right != empty && diag_right.color == "black"
      end

      moves
    end
  end
end
