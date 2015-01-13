module DaysHelper
  def user_in_path?(user, path)
    path.map(&:user).include?(user)
  end

  def user_in_any_paths?(user, paths)
    paths.any? { |path| user_in_path?(user, path) }
  end

  def branch_contains_contribution_flag(leaf)
    if current_user && user_in_any_paths?(current_user, leaf.story.paths(leaf))
      "(contains your sentence)"
    end
  end

  def can_show_results(story)
    story.closed?
  end
end
