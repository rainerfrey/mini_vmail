class PaginationResponder < ActionController::Responder
  def to_html
    if get? && resource.is_a?(ActiveRecord::Relation)
      controller.paginated_scope(resource)
    end
    super
  end
end