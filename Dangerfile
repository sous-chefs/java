# Reference: http://danger.systems/reference.html

# A pull request summary is required. Add a description of the pull request purpose.
# Add labels to the pull request in github to identify the type of change. https://help.github.com/articles/applying-labels-to-issues-and-pull-requests/
# Changelog must be updated for each pull request.
# Warnings will be issued for:
#    Pull request with more than 400 lines of code changed
#    Pull reqest that change more than 5 lines without test changes

def code_changes?
  code = %w(libraries attributes recipes resources)
  code.each do |location|
    return true unless git.modified_files.grep(/#{location}/).empty?
  end
  false
end

def test_changes?
  tests = %w(spec test .kitchen.yml .kitchen.dokken.yml)
  tests.each do |location|
    return true unless git.modified_files.grep(/#{location}/).empty?
  end
  false
end

fail 'Please provide a summary of your Pull Request.' if github.pr_body.length < 10

warn 'This is a big Pull Request.' if git.lines_of_code > 400

# Require a CHANGELOG entry for non-test changes.
if !git.modified_files.include?('CHANGELOG.md') && code_changes?
  fail 'Please include a [CHANGELOG](https://github.com/sous-chefs/java/blob/master/CHANGELOG.md) entry.'
end

# A sanity check for tests.
if git.lines_of_code > 5 && code_changes? && !test_changes?
  warn 'This Pull Request is probably missing tests.'
end
