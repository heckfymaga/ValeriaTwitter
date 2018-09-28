module ApplicationHelper
  def bootstrap_class_for(name)
    { success:"alert-success",
      error:  "alert-danger",
      danger: "alert-danger",
      alert:  "alert-warning",
      notice: "alert-info"
    }[name.to_sym] || name
  end
  def build_breadcrumb(category)
    result = []
    category.ancestors.each do |ancestor|
      result << content_tag(:li, class: "breadcrumb-item") do
        link_to(ancestor.name, ancestor)
      end
    end
    result << content_tag(:li, category.name, class: "breadcrumb-item active")
    result.join('').html_safe
  end
  def get_tags(post)
    result = []
    post.tags.each do |tag|
      result << content_tag(:span, class: "post_tag") do
        link_to('#' + tag.name, tag_path(tag))
      end
    end
    result.join('').html_safe
  end
end
