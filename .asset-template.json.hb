{
  "version_string": "{{ steps.create_version.outputs.previous_tag }}",
  "download_commit": "{{ env.GITHUB_SHA }}",
  "browse_url": "{{ context.repository.html_url }}",
  "issues_url": "{{ context.repository.html_url }}/issues",
  "icon_url": "https://raw.githubusercontent.com/Structed/godot-playfab/main/addons/godot-playfab/icon.png"
}